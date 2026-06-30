import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../db/database.dart';
import '../../providers.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../widgets/zone_badge.dart';
import '../graph/graph_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PulseColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildSegmentedToggle(),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  HomeListView(),
                  GraphScreen(embeddedMode: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pulse', style: PulseTypography.displayMedium),
              Text(
                'by AEVORAX',
                style: PulseTypography.labelMedium.copyWith(
                  color: PulseColors.textTertiary,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            color: PulseColors.textSecondary,
            onPressed: () => context.pushNamed('weeklyReport'),
            tooltip: 'Weekly Report',
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: PulseColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: PulseColors.border),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: PulseColors.surfaceElevated,
            borderRadius: BorderRadius.circular(6),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelStyle: PulseTypography.labelLarge.copyWith(
            color: PulseColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: PulseTypography.labelLarge.copyWith(
            color: PulseColors.textTertiary,
          ),
          labelColor: PulseColors.textPrimary,
          unselectedLabelColor: PulseColors.textTertiary,
          tabs: const [
            Tab(text: 'List'),
            Tab(text: 'Map'),
          ],
        ),
      ),
    );
  }
}

// ── Home List View ─────────────────────────────────────────────────────────────

class HomeListView extends ConsumerWidget {
  const HomeListView({super.key});

  static const _zoneOrder = ['critical', 'cold', 'drifting', 'active'];

  List<Project> _sortProjects(List<Project> projects) {
    return [...projects]..sort((a, b) {
        // Sort by zone severity using DecayScore if available
        // For now, sort by lastSessionAt (most stale first for critical)
        // Full zone sorting happens after Phase 5 decay engine is wired
        final aTime = a.lastSessionAt ?? a.createdAt;
        final bTime = b.lastSessionAt ?? b.createdAt;
        return aTime.compareTo(bTime); // oldest first
      });
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
        final sorted = _sortProjects(projects);
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          itemCount: sorted.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
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
    if (dt == null) return 'never';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    return 'just now';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get latest decay log for zone color
    final latestLogAsync = ref.watch(decayLogsProvider(project.id));
    final latestLog = latestLogAsync.valueOrNull?.isNotEmpty == true
        ? latestLogAsync.valueOrNull!.last
        : null;
    final zone = latestLog?.zone ?? 'active';

    return GestureDetector(
      onTap: () => context.pushNamed(
        'projectDetail',
        pathParameters: {'id': project.id},
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: PulseColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: zone == 'critical'
                ? PulseColors.zoneCritical.withOpacity(0.4)
                : PulseColors.border,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Zone dot
              ZoneDot(zone: zone, size: 9),
              const SizedBox(width: 12),
              // Project info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: PulseTypography.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          _relativeTime(project.lastSessionAt),
                          style: PulseTypography.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        _PriorityTag(priority: project.priority),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Start session button
              _StartSessionButton(project: project),
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
            border: Border.all(color: PulseColors.zoneActive.withOpacity(0.4)),
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
              const SizedBox(width: 5),
              Text(
                'Live',
                style: PulseTypography.labelSmall.copyWith(
                  color: PulseColors.zoneActive,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: hasAnyActive
          ? null
          : () => _startSession(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: hasAnyActive
              ? PulseColors.surfaceElevated
              : PulseColors.accentDim,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasAnyActive
                ? PulseColors.border
                : PulseColors.accent.withOpacity(0.5),
          ),
        ),
        child: Text(
          'Start',
          style: PulseTypography.labelSmall.copyWith(
            color: hasAnyActive
                ? PulseColors.textTertiary
                : PulseColors.accent,
          ),
        ),
      ),
    );
  }

  Future<void> _startSession(BuildContext context, WidgetRef ref) async {
    final sessionDao = ref.read(sessionDaoProvider);
    final projectDao = ref.read(projectDaoProvider);
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

// Minimal uuid helper to avoid importing uuid in widget layer
class _UuidHelper {
  const _UuidHelper();
  String v4() {
    // Falls back to a timestamp-based id in the widget layer.
    // The real uuid import is in service layers.
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}

class _PriorityTag extends StatelessWidget {
  const _PriorityTag({required this.priority});
  final String priority;

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      'high' => PulseColors.zoneCritical,
      'low' => PulseColors.textTertiary,
      _ => PulseColors.textSecondary,
    };
    return Text(
      priority.toUpperCase(),
      style: PulseTypography.labelSmall.copyWith(
        color: color,
        fontSize: 9,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: PulseColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: PulseColors.border),
              ),
              child: const Icon(
                Icons.radar_rounded,
                color: PulseColors.textTertiary,
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No projects yet',
              style: PulseTypography.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Start with a project you\'re already working on, or paste an AI-generated YAML plan.',
              style: PulseTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.pushNamed('newProject'),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('New Project'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => context.pushNamed('import'),
                  icon: const Icon(Icons.content_paste_rounded, size: 16),
                  label: const Text('Paste YAML'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
