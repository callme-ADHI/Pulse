import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../widgets/zone_badge.dart';
import '../../widgets/decay_chart.dart';
import '../../db/database.dart';

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectByIdProvider(projectId));
    final sessionsAsync = ref.watch(projectSessionsProvider(projectId));
    final ideasAsync = ref.watch(projectIdeasProvider(projectId));
    final relationsAsync = ref.watch(projectRelationsProvider(projectId));
    final decayLogsAsync = ref.watch(decayLogsProvider(projectId));

    return projectAsync.when(
      loading: () => const Scaffold(backgroundColor: PulseColors.background, body: Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: PulseColors.accent))),
      error: (e, _) => Scaffold(backgroundColor: PulseColors.background, body: Center(child: Text('Error: $e'))),
      data: (project) {
        if (project == null) {
          return Scaffold(backgroundColor: PulseColors.background, body: Center(child: Text('Project not found', style: PulseTypography.bodyMedium)));
        }
        final latestLog = decayLogsAsync.valueOrNull?.isNotEmpty == true ? decayLogsAsync.valueOrNull!.last : null;
        final zone = latestLog?.zone ?? 'active';
        final score = latestLog?.score ?? 0.0;

        return Scaffold(
          backgroundColor: PulseColors.background,
          body: CustomScrollView(
            slivers: [
              _DetailAppBar(project: project, zone: zone, score: score),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (project.lastNote != null) _LastNoteCard(note: project.lastNote!),
                      if (project.description != null) ...[
                        const SizedBox(height: 16),
                        Text(project.description!, style: PulseTypography.bodyMedium.copyWith(color: PulseColors.textSecondary)),
                      ],
                      const SizedBox(height: 28),
                      _SectionHeader('Decay History — 30d'),
                      const SizedBox(height: 12),
                      DecayChart(projectId: projectId),
                      const SizedBox(height: 28),
                      _SectionHeader('Sessions'),
                      const SizedBox(height: 12),
                      sessionsAsync.when(
                        loading: () => const SizedBox(),
                        error: (_, __) => const SizedBox(),
                        data: (sessions) => _SessionTimeline(sessions: sessions, projectId: projectId),
                      ),
                      const SizedBox(height: 28),
                      _SectionHeader('Ideas'),
                      const SizedBox(height: 12),
                      ideasAsync.when(
                        loading: () => const SizedBox(),
                        error: (_, __) => const SizedBox(),
                        data: (ideas) => ideas.isEmpty
                          ? Text('No ideas linked yet', style: PulseTypography.bodySmall)
                          : Column(children: ideas.map((i) => _IdeaRow(idea: i)).toList()),
                      ),
                      const SizedBox(height: 28),
                      _SectionHeader('Relations'),
                      const SizedBox(height: 12),
                      relationsAsync.when(
                        loading: () => const SizedBox(),
                        error: (_, __) => const SizedBox(),
                        data: (rels) => _RelationList(relations: rels, projectId: projectId),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailAppBar extends StatelessWidget {
  const _DetailAppBar({required this.project, required this.zone, required this.score});
  final Project project;
  final String zone;
  final double score;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: PulseColors.background,
      leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(project.name, style: PulseTypography.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 12),
            ZoneBadge(zone: zone),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: PulseColors.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: PulseColors.border),
              ),
              child: Text(score.toStringAsFixed(0), style: PulseTypography.scoreSmall.copyWith(color: PulseColors.forZone(zone))),
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [PulseColors.surface, PulseColors.background],
            ),
          ),
        ),
      ),
    );
  }
}

class _LastNoteCard extends StatelessWidget {
  const _LastNoteCard({required this.note});
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PulseColors.accentDim.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PulseColors.accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WHERE YOU LEFT OFF', style: PulseTypography.labelSmall.copyWith(color: PulseColors.accent, letterSpacing: 1.5)),
          const SizedBox(height: 6),
          Text(note, style: PulseTypography.bodyMedium),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: PulseTypography.titleSmall),
        const SizedBox(width: 8),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _SessionTimeline extends ConsumerWidget {
  const _SessionTimeline({required this.sessions, required this.projectId});
  final List<Session> sessions;
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSessionAsync = ref.watch(activeSessionProvider);
    final active = activeSessionAsync.valueOrNull;
    final isActiveForThis = active?.projectId == projectId;

    if (sessions.isEmpty && !isActiveForThis) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No sessions yet', style: PulseTypography.bodySmall),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {}, // handled by Start button on home
            icon: const Icon(Icons.play_arrow_rounded, size: 16),
            label: const Text('Start a Session'),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (isActiveForThis && active != null)
          _LiveSessionRow(session: active),
        ...sessions.take(10).map((s) => _SessionRow(session: s)),
        if (sessions.length > 10)
          TextButton(onPressed: () {}, child: Text('View all ${sessions.length} sessions')),
      ],
    );
  }
}

class _LiveSessionRow extends StatelessWidget {
  const _LiveSessionRow({required this.session});
  final Session session;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PulseColors.zoneActiveBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PulseColors.zoneActive.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.circle, color: PulseColors.zoneActive, size: 8),
          const SizedBox(width: 8),
          Text('Session active', style: PulseTypography.bodySmall.copyWith(color: PulseColors.zoneActive)),
          const Spacer(),
          TextButton(
            onPressed: () => context.pushNamed('sessionActive', pathParameters: {'projectId': session.projectId}, queryParameters: {'sessionId': session.id}),
            child: const Text('Return'),
          ),
        ],
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});
  final Session session;

  @override
  Widget build(BuildContext context) {
    final duration = session.durationSeconds;
    final durationStr = duration == null ? '—' : '${(duration ~/ 3600).toString().padLeft(2, '0')}:${((duration % 3600) ~/ 60).toString().padLeft(2, '0')}';
    final date = DateFormat('MMM d').format(session.startedAt);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(date, style: PulseTypography.monoSmall.copyWith(fontSize: 12)),
          const SizedBox(width: 12),
          Text(durationStr, style: PulseTypography.monoSmall),
          const SizedBox(width: 12),
          if (session.tag != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: PulseColors.surfaceElevated, borderRadius: BorderRadius.circular(4)),
              child: Text(session.tag!, style: PulseTypography.labelSmall.copyWith(fontSize: 10)),
            ),
        ],
      ),
    );
  }
}

class _IdeaRow extends StatelessWidget {
  const _IdeaRow({required this.idea});
  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline_rounded, size: 14, color: PulseColors.textTertiary),
          const SizedBox(width: 8),
          Expanded(child: Text(idea.content, style: PulseTypography.bodySmall.copyWith(color: PulseColors.textSecondary))),
        ],
      ),
    );
  }
}

class _RelationList extends StatelessWidget {
  const _RelationList({required this.relations, required this.projectId});
  final List<Relation> relations;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    if (relations.isEmpty) {
      return Text('No relations yet', style: PulseTypography.bodySmall);
    }
    return Column(
      children: relations.map((r) => _RelationRow(relation: r, currentProjectId: projectId)).toList(),
    );
  }
}

class _RelationRow extends StatelessWidget {
  const _RelationRow({required this.relation, required this.currentProjectId});
  final Relation relation;
  final String currentProjectId;

  @override
  Widget build(BuildContext context) {
    final isOutgoing = relation.fromId == currentProjectId;
    final type = relation.relationType.replaceAll('_', ' ');
    final color = PulseColors.forRelationType(relation.relationType);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(isOutgoing ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded, size: 14, color: color),
          const SizedBox(width: 8),
          Text(type, style: PulseTypography.labelMedium.copyWith(color: color)),
          const SizedBox(width: 8),
          Expanded(child: Text(isOutgoing ? relation.toId : relation.fromId, style: PulseTypography.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
