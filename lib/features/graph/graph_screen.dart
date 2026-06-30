import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphview/GraphView.dart' as gv;
import '../../providers.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../db/database.dart';

/// Graph / Map view — §5
/// Uses graphview with force-directed layout.
/// Nodes: circle=project, diamond=idea.
/// Edges: styled by relation type.
class GraphScreen extends ConsumerStatefulWidget {
  const GraphScreen({super.key, this.embeddedMode = false});
  final bool embeddedMode;

  @override
  ConsumerState<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends ConsumerState<GraphScreen> {
  final gv.Graph _graph = gv.Graph()..isTree = false;
  final gv.BuchheimWalkerConfiguration _config = gv.BuchheimWalkerConfiguration()
    ..siblingSeparation = 80
    ..levelSeparation = 80
    ..subtreeSeparation = 80
    ..orientation = 1; // 1 is ORIENTATION_TOP_BOTTOM in older graphview versions

  bool _graphBuilt = false;

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(homeProjectsProvider);
    final relationsAsync = ref.watch(allRelationsProvider);
    final decayLogsByProject = <String, DecayLog>{};

    return projectsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: PulseColors.accent)),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (projects) => relationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: PulseColors.accent)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (relations) {
          if (projects.isEmpty) return _EmptyGraph();
          return _buildGraph(context, projects, relations);
        },
      ),
    );
  }

  Widget _buildGraph(BuildContext context, List<Project> projects, List<Relation> relations) {
    // Build graph data
    final graph = gv.Graph()..isTree = false;
    final Map<String, gv.Node> nodeMap = {};

    // Add project nodes
    for (final project in projects) {
      final node = gv.Node.Id(project.id);
      nodeMap[project.id] = node;
      graph.addNode(node);
    }

    // Add edges
    for (final rel in relations) {
      final from = nodeMap[rel.fromId];
      final to = nodeMap[rel.toId];
      if (from != null && to != null) {
        graph.addEdge(from, to, paint: _edgePaint(rel.relationType));
      }
    }

    final algo = gv.FruchtermanReingoldAlgorithm(gv.FruchtermanReingoldConfiguration(iterations: 300));

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.3,
      maxScale: 2.5,
      child: gv.GraphView(
        graph: graph,
        algorithm: algo,
        paint: Paint()
          ..color = PulseColors.border
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke,
        builder: (gv.Node node) {
          final id = node.key?.value as String?;
          final project = projects.firstWhere(
            (p) => p.id == id,
            orElse: () => projects.first,
          );
          return _ProjectNode(
            project: project,
            onTap: () => context.pushNamed('projectDetail', pathParameters: {'id': project.id}),
          );
        },
      ),
    );
  }

  Paint _edgePaint(String relationType) {
    return Paint()
      ..color = PulseColors.forRelationType(relationType)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
  }
}

class _ProjectNode extends ConsumerWidget {
  const _ProjectNode({required this.project, required this.onTap});
  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(decayLogsProvider(project.id));
    final latestLog = logsAsync.valueOrNull?.isNotEmpty == true ? logsAsync.valueOrNull!.last : null;
    final zone = latestLog?.zone ?? 'active';
    final zoneColor = PulseColors.forZone(zone);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        constraints: const BoxConstraints(minWidth: 80, maxWidth: 140),
        decoration: BoxDecoration(
          color: PulseColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: zoneColor.withOpacity(0.6), width: 1.5),
          boxShadow: [
            BoxShadow(color: zoneColor.withOpacity(0.1), blurRadius: 8, spreadRadius: 1),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 7, height: 7, decoration: BoxDecoration(color: zoneColor, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                project.name,
                style: PulseTypography.labelMedium.copyWith(color: PulseColors.textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_tree_outlined, color: PulseColors.textTertiary, size: 40),
          const SizedBox(height: 16),
          Text('No projects to map', style: PulseTypography.titleSmall),
          const SizedBox(height: 8),
          Text('Add projects and connect them to see the relationship graph.', style: PulseTypography.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
