import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../db/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/zone_badge.dart';
import 'home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(enrichedProjectsProvider);
    final liveAsync     = ref.watch(liveSessionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PULSE', style: AppText.display().copyWith(fontSize: 22)),
                      Text('BY AEVORAX',
                        style: AppText.label().copyWith(color: AppColors.gold, letterSpacing: 2)),
                    ],
                  ),
                  const Spacer(),
                  // Live session chip
                  liveAsync.when(
                    data: (s) => s != null
                        ? GestureDetector(
                            onTap: () => context.push(
                                '/session/${s.projectId}?sessionId=${s.id}'),
                            child: _LiveChip(session: s))
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => context.push('/new-project'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderStrong),
                        borderRadius: BorderRadius.circular(AppDim.radiusBtn),
                      ),
                      child: Text('+ New',
                        style: AppText.label().copyWith(color: AppColors.textSecondary)),
                    ),
                  ),
                ],
              ),
            ),
            // ── List ──────────────────────────────────────────────────────
            Expanded(
              child: projectsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5, color: AppColors.gold)),
                error: (e, _) =>
                    Center(child: Text('Error: $e', style: AppText.body())),
                data: (list) {
                  final active = list.where((p) => p.project.status == 'active').toList();
                  final paused = list.where((p) => p.project.status == 'paused').toList();

                  if (list.isEmpty) return const _EmptyState();

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                    children: [
                      ...active.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ProjectCard(item: p),
                      )),
                      if (paused.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _PausedSection(projects: paused),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Spec §6.1 project card layout.
class ProjectCard extends ConsumerWidget {
  const ProjectCard({required this.item, super.key});
  final ProjectWithDecay item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p     = item.project;
    final score = item.score;
    final zone  = item.zone;

    return GestureDetector(
      onTap: () => context.push('/project/${p.id}'),
      child: Container(
        padding: const EdgeInsets.all(AppDim.cardPad),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(AppDim.radiusCard),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: name + zone pill
            Row(
              children: [
                Expanded(
                  child: Text(p.name,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                ZoneBadge(zone: zone),
              ],
            ),
            // Row 2: last note / next step
            if (p.lastNote?.isNotEmpty ?? false) ...[
              const SizedBox(height: 4),
              Text('↳ ${p.lastNote}',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 14),
            // Row 3: score + since label + Start button
            Row(
              children: [
                Text(
                  score.toInt().toString(),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.zoneFg(zone),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _sinceLabel(p.lastSessionAt),
                    style: AppText.label(),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final notifier =
                        ref.read(sessionNotifierProvider.notifier);
                    final sessionId = await notifier.startSession(p.id);
                    if (sessionId != null && context.mounted) {
                      context.push(
                          '/session/${p.id}?sessionId=$sessionId');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      border: Border.all(color: AppColors.borderStrong),
                      borderRadius: BorderRadius.circular(AppDim.radiusBtn),
                    ),
                    child: Text('▶  Start',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _sinceLabel(DateTime? dt) {
    if (dt == null) return 'No sessions yet';
    final d = DateTime.now().difference(dt).inDays;
    if (d == 0) return 'Today';
    if (d == 1) return '1d ago';
    return '${d}d ago';
  }
}

/// Collapsed paused section with count badge.
class _PausedSection extends StatefulWidget {
  const _PausedSection({required this.projects});
  final List<ProjectWithDecay> projects;

  @override
  State<_PausedSection> createState() => _PausedSectionState();
}

class _PausedSectionState extends State<_PausedSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Text('Paused · ${widget.projects.length}',
                style: AppText.label().copyWith(color: AppColors.textSecondary)),
              const SizedBox(width: 6),
              Icon(
                _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 16,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 8),
          ...widget.projects.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ProjectCard(item: p),
          )),
        ],
      ],
    );
  }
}

class _LiveChip extends StatefulWidget {
  const _LiveChip({required this.session});
  final Session session;

  @override
  State<_LiveChip> createState() => _LiveChipState();
}

class _LiveChipState extends State<_LiveChip> {
  late Timer _t;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _elapsed = DateTime.now().difference(widget.session.startedAt);
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() =>
            _elapsed = DateTime.now().difference(widget.session.startedAt));
      }
    });
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: AppColors.zoneActiveFg),
        borderRadius: BorderRadius.circular(AppDim.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6, height: 6,
            decoration: const BoxDecoration(
              color: AppColors.zoneActiveFg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text('$h:$m:$s',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('No projects yet', style: AppText.body()),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Btn(label: 'New project', onTap: () => context.push('/new-project')),
              const SizedBox(width: 10),
              _Btn(label: 'Paste YAML', gold: true, onTap: () => context.push('/import')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  const _Btn({required this.label, required this.onTap, this.gold = false});
  final String label;
  final VoidCallback onTap;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: gold ? AppColors.gold : Colors.transparent,
          border: Border.all(color: gold ? AppColors.gold : AppColors.borderStrong),
          borderRadius: BorderRadius.circular(AppDim.radiusBtn),
        ),
        child: Text(label,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: gold ? AppColors.background : AppColors.textPrimary)),
      ),
    );
  }
}
