import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_graph_view/flutter_graph_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../home/home_providers.dart';
import 'pulse_graph_convertor.dart';
import 'pulse_graph_shapes.dart';
import '../../widgets/zone_badge.dart';

/// Map screen — spec §6.8
/// Force-directed relationship graph.
/// Nodes are sized by weight, coloured by decay zone, labelled with score.
/// Edges are styled by relation type.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  String _zoneFilter = 'all';
  String _edgeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final projectsAsync  = ref.watch(enrichedProjectsProvider);
    final relationsAsync = ref.watch(allRelationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text('Map', style: AppText.title()),
                  const Spacer(),
                  _FilterBtn(
                    label: 'Zone: $_zoneFilter',
                    options: const ['all', 'active', 'drifting', 'cold', 'critical'],
                    current: _zoneFilter,
                    onPick: (v) => setState(() => _zoneFilter = v),
                  ),
                  const SizedBox(width: 8),
                  _FilterBtn(
                    label: 'Edge: $_edgeFilter',
                    options: const [
                      'all', 'depends_on', 'blocks', 'inspired_by', 'part_of', 'related_to'
                    ],
                    current: _edgeFilter,
                    onPick: (v) => setState(() => _edgeFilter = v),
                  ),
                ],
              ),
            ),
            // ── Legend dots ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _Dot(color: AppColors.zoneActiveFg,   label: 'Active'),
                  _Dot(color: AppColors.zoneDriftingFg, label: 'Drifting'),
                  _Dot(color: AppColors.zoneColdFg,     label: 'Cold'),
                  _Dot(color: AppColors.zoneCriticalFg, label: 'Critical'),
                ],
              ),
            ),
            // ── Graph canvas ─────────────────────────────────────────────
            Expanded(
              child: projectsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5, color: AppColors.gold)),
                error: (e, _) => Center(
                  child: Text('Graph error: $e', style: AppText.body())),
                data: (projects) {
                  final relations = relationsAsync.valueOrNull ?? [];

                  // Apply filters
                  var fp = projects;
                  var fr = relations;

                  if (_zoneFilter != 'all') {
                    final ids = fp
                        .where((p) => p.zone == _zoneFilter)
                        .map((p) => p.project.id)
                        .toSet();
                    fp = fp.where((p) => ids.contains(p.project.id)).toList();
                    fr = fr
                        .where((r) => ids.contains(r.fromId) && ids.contains(r.toId))
                        .toList();
                  }
                  if (_edgeFilter != 'all') {
                    fr = fr.where((r) => r.relationType == _edgeFilter).toList();
                  }

                  if (fp.isEmpty) {
                    return Center(
                      child: Text(
                        'No projects yet.\nCreate one to see the map.',
                        textAlign: TextAlign.center,
                        style: AppText.body(),
                      ),
                    );
                  }

                  final opts = Options()
                    ..enableHit = true
                    ..panelDelay = const Duration(milliseconds: 300)
                    ..showText   = false   // we draw the score ourselves
                    ..graphStyle = (GraphStyle()
                      ..tagColor = {
                        'active'  : AppColors.zoneActiveBg,
                        'drifting': AppColors.zoneDriftingBg,
                        'cold'    : AppColors.zoneColdBg,
                        'critical': AppColors.zoneCriticalBg,
                      })
                    ..vertexShape = PulseVertexShape()
                    ..edgeShape   = PulseEdgeShape()
                    ..vertexPanelBuilder = (hoverVertex) =>
                        _nodePanel(context, hoverVertex);

                  return FlutterGraphWidget(
                    data: {'projects': fp, 'relations': fr},
                    algorithm: RandomAlgorithm(
                      decorators: [
                        CoulombDecorator(),
                        HookeDecorator(),
                        CoulombCenterDecorator(),
                        HookeCenterDecorator(),
                        ForceDecorator(),
                        ForceMotionDecorator(),
                        TimeCounterDecorator(),
                      ],
                    ),
                    convertor: PulseGraphConvertor(),
                    options: opts,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Hover panel shown when mouse rests on a node.
  Widget _nodePanel(BuildContext context, Vertex hoverVertex) {
    final d     = (hoverVertex.data as Map?) ?? {};
    final name  = d['name']  as String? ?? '—';
    final score = (d['score'] as double? ?? 0).toInt();
    final zone  = d['zone']  as String? ?? 'active';
    final id    = d['id']    as String? ?? '';

    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              ZoneBadge(zone: zone),
              const SizedBox(width: 8),
              Text(
                score.toString(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              if (id.isNotEmpty) context.push('/project/$id');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderStrong),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Open →',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter button
// ─────────────────────────────────────────────────────────────────────────────

class _FilterBtn extends StatelessWidget {
  const _FilterBtn({
    required this.label,
    required this.options,
    required this.current,
    required this.onPick,
  });
  final String label;
  final List<String> options;
  final String current;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.surface2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
        builder: (_) => ListView(
          shrinkWrap: true,
          children: options.map((o) => ListTile(
            title: Text(
              o,
              style: AppText.body().copyWith(
                color: o == current ? AppColors.gold : AppColors.textPrimary),
            ),
            onTap: () { onPick(o); Navigator.pop(context); },
          )).toList(),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderStrong),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label, style: AppText.label().copyWith(color: AppColors.textSecondary)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Legend dot
// ─────────────────────────────────────────────────────────────────────────────

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 6, height: 6,
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      Text(label, style: AppText.label()),
      const SizedBox(width: 12),
    ],
  );
}
