import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../db/database.dart';
import '../../providers.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../widgets/zone_badge.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: PulseColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            const Expanded(child: HomeListView()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PULSE',
                style: PulseTypography.displayMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'BY AEVORAX',
                style: PulseTypography.labelSmall.copyWith(
                  color: PulseColors.accent,
                  fontSize: 10,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => context.pushNamed('weeklyReport'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bar_chart_rounded, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  'Report',
                  style: PulseTypography.titleSmall.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Home List View ─────────────────────────────────────────────────────────────

class HomeListView extends ConsumerWidget {
  const HomeListView({super.key});

  List<Project> _sortProjects(List<Project> projects, WidgetRef ref) {
    // Sort projects: we can sort by decay score descending (critical first)
    final sorted = [...projects];
    sorted.sort((a, b) {
      final aLog = ref.read(decayLogsProvider(a.id)).valueOrNull?.lastOrNull;
      final bLog = ref.read(decayLogsProvider(b.id)).valueOrNull?.lastOrNull;
      final aScore = aLog?.score ?? 0.0;
      final bScore = bLog?.score ?? 0.0;
      return bScore.compareTo(aScore); // highest score (critical) first
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(homeProjectsProvider);

    return projectsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: PulseColors.accent,
        ),
      ),
      error: (e, _) => Center(
        child: Text('Error: $e', style: PulseTypography.bodySmall),
      ),
      data: (projects) {
        if (projects.isEmpty) {
          return _EmptyState();
        }
        final sorted = _sortProjects(projects, ref);
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          itemCount: sorted.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _ProjectRow(project: sorted[index]),
        );
      },
    );
  }
}

class _ProjectRow extends ConsumerWidget {
  const _ProjectRow({required this.project});
  final Project project;

  String _relativeTime(DateTime? dt) {
    if (dt == null) return 'Never started';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 1) return '${diff.inDays}d since last session';
    if (diff.inHours >= 1) return '${diff.inHours}h since last session';
    return 'Session just completed';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get latest decay log for zone color & score
    final latestLogAsync = ref.watch(decayLogsProvider(project.id));
    final latestLog = latestLogAsync.valueOrNull?.isNotEmpty == true
        ? latestLogAsync.valueOrNull!.last
        : null;
    final zone = latestLog?.zone ?? 'active';
    final score = latestLog?.score ?? 0.0;

    return GestureDetector(
      onTap: () => context.pushNamed(
        'projectDetail',
        pathParameters: {'id': project.id},
      ),
      child: Container(
        decoration: BoxDecoration(
          color: PulseColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: PulseColors.surfaceOverlay,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: PulseTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ZoneBadge(zone: zone),
                ],
              ),
              if (project.description != null && project.description!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  project.description!,
                  style: PulseTypography.bodySmall.copyWith(
                    color: PulseColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'Score: ',
                            style: PulseTypography.bodySmall.copyWith(
                              color: PulseColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${score.toInt()}',
                            style: PulseTypography.monoLarge.copyWith(
                              color: PulseColors.forZone(zone),
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _relativeTime(project.lastSessionAt),
                        style: PulseTypography.bodySmall.copyWith(
                          color: PulseColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  _StartSessionButton(project: project),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartSessionButton extends ConsumerWidget {
  const _StartSessionButton({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSession = ref.watch(activeSessionProvider).valueOrNull;
    final isThisProject = activeSession?.projectId == project.id;
    final hasAnyActive = activeSession != null;

    if (isThisProject) {
      return GestureDetector(
        onTap: () => context.pushNamed(
          'sessionActive',
          pathParameters: {'projectId': project.id},
          queryParameters: {'sessionId': activeSession!.id},
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: PulseColors.zoneActiveBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: PulseColors.zoneActive.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: PulseColors.zoneActive,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'LIVE',
                style: PulseTypography.labelSmall.copyWith(
                  color: PulseColors.zoneActive,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF222222), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: hasAnyActive ? null : () => _startSession(context, ref),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.play_arrow_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            'Start',
            style: PulseTypography.titleSmall.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Future<void> _startSession(BuildContext context, WidgetRef ref) async {
    final sessionDao = ref.read(sessionDaoProvider);
    const uuid = _UuidHelper();
    final sessionId = uuid.v4();
    final now = DateTime.now();

    await sessionDao.startSession(
      SessionsCompanion.insert(
        id: sessionId,
        projectId: project.id,
        startedAt: now,
      ),
    );

    if (context.mounted) {
      context.pushNamed(
        'sessionActive',
        pathParameters: {'projectId': project.id},
        queryParameters: {'sessionId': sessionId},
      );
    }
  }
}

class _UuidHelper {
  const _UuidHelper();
  String v4() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'NO PROJECTS YET',
            style: PulseTypography.labelSmall.copyWith(
              color: PulseColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pushNamed('newProject'),
            child: const Text('New Project'),
          ),
        ],
      ),
    );
  }
}
