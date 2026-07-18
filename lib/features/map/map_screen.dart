import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../providers.dart';
import '../../db/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../home/home_providers.dart';
import 'pulse_graph_node.dart';
import 'pulse_graph_edge.dart';
import 'pulse_graph_controller.dart';
import 'pulse_graph_painter.dart';

// ════════════════════════════════════════════════════════════════════════════
// MAP SCREEN — Obsidian-style force-directed graph
// ════════════════════════════════════════════════════════════════════════════

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with TickerProviderStateMixin {
  late PulseGraphController _controller;
  bool _initialized = false;
  Map<String, Offset> _savedPositions = {};

  @override
  void initState() {
    super.initState();
    _controller = PulseGraphController(vsync: this);
    _loadPersistedState();
  }

  Future<void> _loadPersistedState() async {
    _savedPositions = await _controller.loadPositions();
    final vp = await _controller.loadViewport();
    if (vp != null && mounted) {
      _controller.panOffset = vp.pan;
      _controller.zoomLevel  = vp.zoom;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncData(List<Project> projects, List<Idea> ideas, List<Relation> relations,
      List<ProjectWithDecay> enriched) {
    final enrichedMap = {for (var e in enriched) e.project.id: e};

    final nodes = <PulseGraphNode>[
      ...projects.where((p) => p.status != 'dropped').map((p) {
        final e = enrichedMap[p.id];
        return PulseGraphNode(
          id: p.id,
          label: p.name,
          zone: e?.zone ?? 'active',
          score: e?.score.toDouble() ?? 0,
          weight: p.weight,
          type: 'project',
        );
      }),
      ...ideas.where((i) => i.status == 'unsorted' || i.status == 'linked').map((i) => PulseGraphNode(
        id: i.id,
        label: i.content.length > 30 ? '${i.content.substring(0, 28)}…' : i.content,
        zone: 'idea',
        type: 'idea',
      )),
    ];

    // Implicit edges: ideas linked to a project via idea.projectId
    final nodeIds = {for (final n in nodes) n.id};
    final edges = [
      ...relations.map((r) => PulseGraphEdge(
        sourceId: r.fromId,
        targetId: r.toId,
        type: PulseEdgeTypeX.fromString(r.relationType),
      )),
      // Gold edges for ideas that are linked to a project
      ...ideas
          .where((i) =>
              i.projectId != null &&
              (i.status == 'unsorted' || i.status == 'linked') &&
              nodeIds.contains(i.id) &&
              nodeIds.contains(i.projectId))
          .map((i) => PulseGraphEdge(
                sourceId: i.id,
                targetId: i.projectId!,
                type: PulseEdgeType.inspiredBy, // inspiredBy renders as gold dashed
              )),
    ].where((e) => nodeIds.contains(e.sourceId) && nodeIds.contains(e.targetId)).toList();

    _controller.updateData(nodes, edges, savedPositions: _savedPositions);

    if (!_initialized && nodes.isNotEmpty) {
      _initialized = true;
      final allHaveSaved = nodes.every((n) => _savedPositions.containsKey(n.id));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (!allHaveSaved) {
          _controller.reset(MediaQuery.of(context).size);
        } else if (_controller.zoomLevel == 1.0 && _controller.panOffset == Offset.zero) {
          _controller.fitAll(MediaQuery.of(context).size);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(homeProjectsProvider);
    final ideasAsync    = ref.watch(allIdeasProvider);
    final relationsAsync = ref.watch(allRelationsProvider);
    final enrichedAsync = ref.watch(enrichedProjectsProvider);

    final projects = projectsAsync.valueOrNull ?? [];
    final ideas    = ideasAsync.valueOrNull ?? [];
    final relations = relationsAsync.valueOrNull ?? [];
    final enriched  = enrichedAsync.valueOrNull ?? [];

    _syncData(projects, ideas, relations, enriched);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _GraphInteraction(
            controller: _controller,
            onNodeTap: (id) {
              // Check if it's a project or idea
              final proj = projects.where((p) => p.id == id).firstOrNull;
              if (proj != null) {
                context.push('/project/${proj.id}');
              }
            },
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('PROJECT MAP', style: GoogleFonts.inter(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          letterSpacing: 2.5, color: Colors.white,
                        )),
                        const SizedBox(height: 2),
                        Text('Force-directed relationship graph', style: GoogleFonts.inter(
                          fontSize: 11, color: Colors.white24)),
                      ],
                    ),
                  ),
                  _SmallBtn(icon: Icons.add, onTap: () => _showAddRelationSheet(context, ref)),
                ],
              ),
            ),
          ),

          // Zoom controls
          Positioned(
            top: 100,
            right: 14,
            child: _ZoomControls(controller: _controller),
          ),

          // Legend
          Positioned(
            bottom: 100,
            left: 14,
            child: const _Legend(),
          ),

          // Node count
          Positioned(
            bottom: 100,
            left: 0, right: 0,
            child: Center(
              child: ListenableBuilder(
                listenable: _controller,
                builder: (_, __) => _NodeCount(count: _controller.nodes.length),
              ),
            ),
          ),

          // Minimap
          Positioned(
            bottom: 100,
            right: 14,
            child: _Minimap(controller: _controller),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// INTERACTION HANDLER
// ════════════════════════════════════════════════════════════════════════════

class _GraphInteraction extends StatefulWidget {
  final PulseGraphController controller;
  final Function(String) onNodeTap;
  const _GraphInteraction({required this.controller, required this.onNodeTap});

  @override
  State<_GraphInteraction> createState() => _GraphInteractionState();
}

class _GraphInteractionState extends State<_GraphInteraction> {
  PulseGraphNode? _draggedNode;
  Offset _pointerDownPos = Offset.zero;
  bool _isDragging = false;
  double _prevScale = 1.0;
  Offset _prevFocal = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onDown,
      onPointerMove: _onMove,
      onPointerUp: _onUp,
      child: GestureDetector(
        onScaleStart: (d) { _prevScale = 1.0; _prevFocal = d.localFocalPoint; },
        onScaleUpdate: (d) {
          if (_draggedNode != null) return;
          final scaleDelta = d.scale / _prevScale;
          _prevScale = d.scale;
          if ((scaleDelta - 1.0).abs() > 0.0005) widget.controller.zoomAt(scaleDelta, d.localFocalPoint);
          final panDelta = d.localFocalPoint - _prevFocal;
          _prevFocal = d.localFocalPoint;
          if (panDelta.distance > 0.1) widget.controller.pan(panDelta);
        },
        onScaleEnd: (_) { _prevScale = 1.0; },
        behavior: HitTestBehavior.opaque,
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (_, __) => CustomPaint(
            size: Size.infinite,
            painter: PulseGraphPainter(
              nodes: widget.controller.nodes,
              edges: widget.controller.edges,
              panOffset: widget.controller.panOffset,
              zoomLevel: widget.controller.zoomLevel,
              rotationAngle: widget.controller.rotationAngle,
            ),
          ),
        ),
      ),
    );
  }

  void _onDown(PointerDownEvent e) {
    _pointerDownPos = e.localPosition;
    _isDragging = false;
    final cp = _toCanvas(e.localPosition);
    _draggedNode = _findAt(cp);
  }

  void _onMove(PointerMoveEvent e) {
    if (_draggedNode == null) return;
    widget.controller.moveNode(_draggedNode!, _toCanvas(e.localPosition));
    _isDragging = true;
  }

  void _onUp(PointerUpEvent e) {
    if (_draggedNode != null) {
      widget.controller.onNodeDropped();
      _draggedNode = null;
      _isDragging = false;
    }
    if ((e.localPosition - _pointerDownPos).distance < 8 && !_isDragging) {
      final tapped = _findAt(_toCanvas(e.localPosition));
      if (tapped != null) widget.onNodeTap(tapped.id);
    }
  }

  Offset _toCanvas(Offset screen) =>
      (screen - widget.controller.panOffset) / widget.controller.zoomLevel;

  PulseGraphNode? _findAt(Offset cp) {
    for (var n in widget.controller.nodes.reversed) {
      if ((n.position - cp).distance < (n.finalRadius + 14)) return n;
    }
    return null;
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ZOOM CONTROLS
// ════════════════════════════════════════════════════════════════════════════

class _ZoomControls extends StatelessWidget {
  final PulseGraphController controller;
  const _ZoomControls({required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Btn(icon: Icons.add, onTap: () => controller.zoom(1.25, size)),
          _div,
          _Btn(icon: Icons.remove, onTap: () => controller.zoom(0.8, size)),
          _div,
          _Btn(icon: Icons.fit_screen_outlined, onTap: () => controller.fitAll(size)),
          _div,
          _Btn(icon: Icons.refresh, onTap: () => controller.reset(size)),
        ],
      ),
    );
  }

  static Widget get _div => Container(height: 0.5, color: Colors.white.withValues(alpha: 0.07));
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Btn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SizedBox(width: 36, height: 36, child: Icon(icon, color: Colors.white38, size: 17)),
  );
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SmallBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Icon(icon, color: Colors.white54, size: 17),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════
// LEGEND
// ════════════════════════════════════════════════════════════════════════════

class _Legend extends StatelessWidget {
  const _Legend();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(const Color(0xFF1DB87B), 'ACTIVE'),
        _dot(const Color(0xFFC9911D), 'DRIFTING'),
        _dot(const Color(0xFFC9601D), 'COLD'),
        _dot(const Color(0xFFC93030), 'CRITICAL'),
        _dot(const Color(0xFFC9A84C), 'IDEA'),
      ],
    ),
  );

  Widget _dot(Color c, String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(children: [
      Container(width: 6, height: 6, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
      const SizedBox(width: 7),
      Text(label, style: GoogleFonts.inter(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.w600, letterSpacing: 1.0)),
    ]),
  );
}

// ════════════════════════════════════════════════════════════════════════════
// NODE COUNT
// ════════════════════════════════════════════════════════════════════════════

class _NodeCount extends StatelessWidget {
  final int count;
  const _NodeCount({required this.count});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(99),
      border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
    ),
    child: Text('$count NODES', style: GoogleFonts.inter(
      color: Colors.white24, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
  );
}

// ════════════════════════════════════════════════════════════════════════════
// MINIMAP
// ════════════════════════════════════════════════════════════════════════════

class _Minimap extends StatelessWidget {
  final PulseGraphController controller;
  const _Minimap({required this.controller});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (_, __) => Container(
      width: 110, height: 80,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(painter: _MinimapPainter(controller: controller)),
    ),
  );
}

class _MinimapPainter extends CustomPainter {
  final PulseGraphController controller;
  _MinimapPainter({required this.controller});

  @override
  void paint(Canvas canvas, Size size) {
    final nodes = controller.nodes;
    if (nodes.isEmpty) return;

    double minX = nodes.first.position.dx, maxX = minX;
    double minY = nodes.first.position.dy, maxY = minY;
    for (var n in nodes) {
      minX = math.min(minX, n.position.dx); maxX = math.max(maxX, n.position.dx);
      minY = math.min(minY, n.position.dy); maxY = math.max(maxY, n.position.dy);
    }
    final gW = maxX - minX + 120, gH = maxY - minY + 120;
    final scale = math.min(size.width / gW, size.height / gH);
    final cx = size.width  / 2 - (minX + maxX) / 2 * scale;
    final cy = size.height / 2 - (minY + maxY) / 2 * scale;
    final offset = Offset(cx, cy);

    for (var n in nodes) {
      canvas.drawCircle(n.position * scale + offset,
        math.max(n.finalRadius * scale, 1.5),
        Paint()..color = n.zoneColor.withValues(alpha: 0.7));
    }
    final vl = -controller.panOffset.dx / controller.zoomLevel;
    final vt = -controller.panOffset.dy / controller.zoomLevel;
    final rect = Rect.fromLTRB(
      vl * scale + offset.dx, vt * scale + offset.dy,
      (vl + 400 / controller.zoomLevel) * scale + offset.dx,
      (vt + 800 / controller.zoomLevel) * scale + offset.dy,
    );
    canvas.drawRect(rect, Paint()..color = Colors.white.withValues(alpha: 0.05)..style = PaintingStyle.fill);
    canvas.drawRect(rect, Paint()..color = Colors.white.withValues(alpha: 0.22)..style = PaintingStyle.stroke..strokeWidth = 0.8);
  }

  @override
  bool shouldRepaint(_MinimapPainter old) => true;
}

// ════════════════════════════════════════════════════════════════════════════
// ADD RELATION SHEET
// ════════════════════════════════════════════════════════════════════════════

class _NodeOption {
  final String id, name, type;
  _NodeOption({required this.id, required this.name, required this.type});
  @override bool operator ==(Object o) => o is _NodeOption && id == o.id && type == o.type;
  @override int get hashCode => id.hashCode ^ type.hashCode;
}

void _showAddRelationSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (_) => _AddRelationSheet(ref: ref),
  );
}

class _AddRelationSheet extends StatefulWidget {
  const _AddRelationSheet({required this.ref});
  final WidgetRef ref;
  @override State<_AddRelationSheet> createState() => _AddRelationSheetState();
}

class _AddRelationSheetState extends State<_AddRelationSheet> {
  _NodeOption? _from, _to;
  String _relationType = 'related_to';
  bool _saving = false;
  final _types = ['depends_on', 'blocks', 'inspired_by', 'part_of', 'related_to'];

  @override
  Widget build(BuildContext context) {
    final projects = widget.ref.watch(homeProjectsProvider).valueOrNull ?? [];
    final ideas    = widget.ref.watch(allIdeasProvider).valueOrNull ?? [];
    final options  = [
      ...projects.map((p) => _NodeOption(id: p.id, name: p.name, type: 'project')),
      ...ideas.map((i)    => _NodeOption(id: i.id, name: i.content.length > 40 ? '${i.content.substring(0, 38)}…' : i.content, type: 'idea')),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 28),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add Relationship', style: AppText.title()),
                IconButton(icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary), onPressed: () => Navigator.pop(context)),
              ],
            ),
            if (options.length < 2)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('You need at least 2 projects or ideas to create a relationship.', style: AppText.body()),
              )
            else ...[
              const SizedBox(height: 16),
              _label('FROM NODE'),
              const SizedBox(height: 6),
              _dropdown<_NodeOption>(
                value: _from,
                hint: 'Select source node',
                items: options.map((o) => DropdownMenuItem(value: o, child: Text('${o.name} [${o.type.toUpperCase()}]', style: AppText.bodyWhite(), overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (v) => setState(() { _from = v; if (_to == v) _to = null; }),
              ),
              const SizedBox(height: 16),
              _label('RELATION TYPE'),
              const SizedBox(height: 6),
              _dropdown<String>(
                value: _relationType,
                items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t.replaceAll('_', ' ').toUpperCase(), style: AppText.bodyWhite()))).toList(),
                onChanged: (v) { if (v != null) setState(() => _relationType = v); },
              ),
              const SizedBox(height: 16),
              _label('TO NODE'),
              const SizedBox(height: 6),
              _dropdown<_NodeOption>(
                value: _to,
                hint: 'Select target node',
                items: options.where((o) => o != _from).map((o) => DropdownMenuItem(value: o, child: Text('${o.name} [${o.type.toUpperCase()}]', style: AppText.bodyWhite(), overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (v) => setState(() => _to = v),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold, foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _saving || _from == null || _to == null ? null : _save,
                  child: _saving
                      ? const CircularProgressIndicator(strokeWidth: 1.5, color: Colors.black)
                      : Text('Create Relation', style: AppText.titleSmall().copyWith(color: Colors.black)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t, style: AppText.label().copyWith(fontSize: 11));
  Widget _dropdown<T>({required T? value, String? hint, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value, isExpanded: true, dropdownColor: AppColors.surface2,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          hint: hint != null ? Text(hint, style: AppText.body()) : null,
          items: items, onChanged: onChanged,
        ),
      ),
    );

  Future<void> _save() async {
    final from = _from, to = _to;
    if (from == null || to == null) return;
    setState(() => _saving = true);
    try {
      final dao = widget.ref.read(relationDaoProvider);
      final exists = await dao.relationExists(from.id, to.id, _relationType);
      if (exists) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: AppColors.surface2,
          content: Text('This relationship already exists', style: TextStyle(color: Colors.white)),
        ));
        return;
      }
      await dao.insertRelation(RelationsCompanion.insert(
        id: const Uuid().v4(),
        fromId: from.id, toId: to.id,
        fromType: from.type, toType: to.type,
        relationType: _relationType, createdAt: DateTime.now(),
      ));
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
