import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import '../../providers.dart';
import '../../db/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/zone_badge.dart';
import '../../widgets/decay_chart.dart';
import 'phase_strip.dart';
import 'learning_section.dart';
import 'dead_time_section.dart';
import 'analytics_section.dart';

/// Project Detail (Mission Control) screen — spec §6.2
/// High-fidelity detail page containing all 9 sections of the project instrument panel.
class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync   = ref.watch(projectByIdProvider(projectId));
    final sessionsAsync  = ref.watch(projectSessionsProvider(projectId));
    final ideasAsync     = ref.watch(projectIdeasProvider(projectId));
    final phasesAsync    = ref.watch(projectPhasesProvider(projectId));
    final decayLogsAsync = ref.watch(decayLogsProvider(projectId));

    return projectAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Error: $e', style: AppText.body())),
      ),
      data: (project) {
        if (project == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('Project not found', style: AppText.body())),
          );
        }

        final latestLog = decayLogsAsync.valueOrNull?.isNotEmpty == true
            ? decayLogsAsync.valueOrNull!.last
            : null;
        final zone = latestLog?.zone ?? 'active';
        final score = latestLog?.score ?? 0.0;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // ── Header (Section 1 & 2) ───────────────────────────
              _DetailAppBar(
                project: project,
                zone: zone,
                score: score,
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Status Controls ──────────────────────────────
                    _StatusControls(project: project),
                    const SizedBox(height: 20),

                    // ── Section 3: Where you left off ───────────────
                    if (project.lastNote != null && project.lastNote!.isNotEmpty) ...[
                      _SectionHeader('WHERE YOU LEFT OFF'),
                      const SizedBox(height: 8),
                      _LastNoteCard(note: project.lastNote!),
                      const SizedBox(height: 24),
                    ],

                    // ── Section 4: Execution Phases ──────────────────
                    _SectionHeader('EXECUTION PHASES'),
                    const SizedBox(height: 12),
                    phasesAsync.when(
                      loading: () => const SizedBox(height: 90),
                      error: (_, __) => const SizedBox(height: 90),
                      data: (phases) => PhaseStrip(
                        phases: phases,
                        onAddPhase: () => _showAddPhaseSheet(context, ref),
                        onTapPhase: (p) => _showEditPhaseSheet(context, ref, p),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Section 5: Decay History (30d) ───────────────
                    _SectionHeader('DECAY TIMELINE (30D)'),
                    const SizedBox(height: 12),
                    DecayChart(projectId: projectId),
                    const SizedBox(height: 24),

                    // ── Section 6: Learning Goals ────────────────────
                    _SectionHeader('LEARNING GOALS'),
                    const SizedBox(height: 12),
                    LearningSection(projectId: projectId),
                    const SizedBox(height: 24),

                    // ── Section 7: Dead Time ─────────────────────────
                    _SectionHeader('DEAD TIME ACCOUNTING'),
                    const SizedBox(height: 12),
                    DeadTimeSection(projectId: projectId, decayScore: score),
                    const SizedBox(height: 24),

                    // ── Section 8 & 9: Analytics ─────────────────────
                    _SectionHeader('PROJECT INTELLIGENCE'),
                    const SizedBox(height: 12),
                    AnalyticsSection(project: project),
                    const SizedBox(height: 24),

                    // ── Ideas List ───────────────────────────────────
                    _SectionHeader('LINKED IDEAS'),
                    const SizedBox(height: 12),
                    ideasAsync.when(
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                      data: (ideas) {
                        if (ideas.isEmpty) {
                          return Text('No ideas linked to this project',
                              style: AppText.body().copyWith(color: AppColors.textMuted));
                        }
                        return Column(
                          children: ideas.map((i) => _IdeaRow(idea: i)).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // ── Session History ──────────────────────────────
                    _SectionHeader('SESSION LOGS'),
                    const SizedBox(height: 12),
                    sessionsAsync.when(
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                      data: (sessions) => _SessionTimeline(sessions: sessions),
                    ),
                    const SizedBox(height: 80),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddPhaseSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddPhaseSheet(projectId: projectId, ref: ref),
    );
  }

  void _showEditPhaseSheet(BuildContext context, WidgetRef ref, ExecutionPhase phase) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditPhaseSheet(phase: phase, ref: ref),
    );
  }
}

class _DetailAppBar extends StatelessWidget {
  const _DetailAppBar({
    required this.project,
    required this.zone,
    required this.score,
  });

  final Project project;
  final String zone;
  final double score;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 130,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left_rounded, color: AppColors.textSecondary, size: 28),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                project.name,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            ZoneBadge(zone: zone),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surface3,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.borderStrong),
              ),
              child: Text(
                score.toInt().toString(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.zoneFg(zone),
                ),
              ),
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.surface1, AppColors.background],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusControls extends ConsumerWidget {
  const _StatusControls({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = project.status;

    return Row(
      children: [
        if (status == 'active') ...[
          Expanded(
            child: _ActionBtn(
              label: 'Pause project',
              onPressed: () => ref.read(projectDaoProvider).updateStatus(project.id, 'paused'),
            ),
          ),
        ] else if (status == 'paused') ...[
          Expanded(
            child: _ActionBtn(
              label: 'Resume project',
              onPressed: () => ref.read(projectDaoProvider).updateStatus(project.id, 'active'),
            ),
          ),
        ],
        const SizedBox(width: 8),
        Expanded(
          child: _ActionBtn(
            label: status == 'completed' ? 'Re-open' : 'Complete',
            onPressed: () {
              final next = status == 'completed' ? 'active' : 'completed';
              ref.read(projectDaoProvider).updateStatus(project.id, next);
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.archive_outlined, color: AppColors.textMuted),
          onPressed: () {
            ref.read(projectDaoProvider).updateStatus(project.id, 'archived');
            context.pop();
          },
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surface1,
          border: Border.all(color: AppColors.borderStrong),
          borderRadius: BorderRadius.circular(AppDim.radiusBtn),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Text(
        note,
        style: GoogleFonts.dmSans(
          fontSize: 13,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
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
        Text(
          text,
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(child: Divider(color: AppColors.borderDefault, height: 1)),
      ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.lightbulb_outline_rounded, size: 14, color: AppColors.gold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              idea.content,
              style: AppText.body().copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionTimeline extends StatelessWidget {
  const _SessionTimeline({required this.sessions});
  final List<Session> sessions;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Text(
        'No sessions recorded yet.',
        style: AppText.body().copyWith(color: AppColors.textMuted),
      );
    }

    return Column(
      children: sessions.take(8).map((s) => _SessionRow(session: s)).toList(),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});
  final Session session;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, yyyy');
    final dur = session.durationSeconds;
    final durStr = dur != null
        ? '${(dur ~/ 3600).toString().padLeft(2, '0')}:${((dur % 3600) ~/ 60).toString().padLeft(2, '0')}'
        : '—';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(fmt.format(session.startedAt), style: AppText.monoSmall()),
          const SizedBox(width: 12),
          Text(durStr, style: AppText.monoSmall().copyWith(color: AppColors.gold)),
          if (session.tag != null) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surface3,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.borderStrong),
              ),
              child: Text(
                session.tag!,
                style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.textSecondary),
              ),
            ),
          ],
          if (session.stopReason != null) ...[
            const SizedBox(width: 8),
            Text(
              '(${session.stopReason!.replaceAll('_', ' ')})',
              style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Sheets for adding/editing phases ─────────────────────────────────

class _AddPhaseSheet extends StatefulWidget {
  const _AddPhaseSheet({required this.projectId, required this.ref});
  final String projectId;
  final WidgetRef ref;

  @override
  State<_AddPhaseSheet> createState() => _AddPhaseSheetState();
}

class _AddPhaseSheetState extends State<_AddPhaseSheet> {
  final _nameCtrl = TextEditingController();
  final _sumCtrl  = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sumCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDim.radiusCard)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDim.pad20, AppDim.pad16, AppDim.pad20,
        MediaQuery.of(context).viewInsets.bottom + AppDim.pad28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Execution Phase', style: AppText.title()),
          const SizedBox(height: AppDim.pad16),
          TextField(
            controller: _nameCtrl,
            autofocus: true,
            style: AppText.bodyWhite(),
            decoration: InputDecoration(
              hintText: 'Phase name (e.g. Design Spec)',
              hintStyle: AppText.body(),
              filled: true, fillColor: AppColors.surface3,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDim.radiusInput),
                borderSide: const BorderSide(color: AppColors.borderDefault),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDim.radiusInput),
                borderSide: const BorderSide(color: AppColors.borderDefault),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDim.radiusInput),
                borderSide: const BorderSide(color: AppColors.borderStrong, width: 1.5),
              ),
              contentPadding: const EdgeInsets.all(AppDim.pad12),
            ),
          ),
          const SizedBox(height: AppDim.pad8),
          TextField(
            controller: _sumCtrl,
            style: AppText.bodyWhite(),
            decoration: InputDecoration(
              hintText: 'Summary (optional)',
              hintStyle: AppText.body(),
              filled: true, fillColor: AppColors.surface3,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDim.radiusInput),
                borderSide: const BorderSide(color: AppColors.borderDefault),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDim.radiusInput),
                borderSide: const BorderSide(color: AppColors.borderDefault),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDim.radiusInput),
                borderSide: const BorderSide(color: AppColors.borderStrong, width: 1.5),
              ),
              contentPadding: const EdgeInsets.all(AppDim.pad12),
            ),
          ),
          const SizedBox(height: AppDim.pad16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDim.radiusBtn),
                ),
              ),
              onPressed: () async {
                if (_nameCtrl.text.trim().isEmpty) return;
                final phases = await widget.ref
                    .read(phaseDaoProvider)
                    .getPhasesForProject(widget.projectId);

                await widget.ref.read(phaseDaoProvider).insertPhase(
                  ExecutionPhasesCompanion.insert(
                    id: const Uuid().v4(),
                    projectId: widget.projectId,
                    name: _nameCtrl.text.trim(),
                    summary: Value(_sumCtrl.text.trim().isEmpty ? null : _sumCtrl.text.trim()),
                    status: const Value('not_started'),
                    order: phases.length,
                  ),
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: Text('Add', style: AppText.titleSmall().copyWith(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditPhaseSheet extends StatelessWidget {
  const _EditPhaseSheet({required this.phase, required this.ref});
  final ExecutionPhase phase;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDim.radiusCard)),
      ),
      padding: const EdgeInsets.all(AppDim.pad20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Edit Phase: ${phase.name}', style: AppText.title()),
          const SizedBox(height: AppDim.pad16),
          ...['not_started', 'in_progress', 'done'].map((s) => ListTile(
            title: Text(
              s.replaceAll('_', ' ').toUpperCase(),
              style: AppText.body().copyWith(
                color: phase.status == s ? AppColors.gold : AppColors.textPrimary,
              ),
            ),
            trailing: phase.status == s
                ? const Icon(Icons.check_rounded, color: AppColors.gold)
                : null,
            onTap: () async {
              await ref.read(phaseDaoProvider).updateStatus(
                phase.id,
                s,
                doneAt: s == 'done' ? DateTime.now() : null,
              );
              Navigator.pop(context);
            },
          )),
          const SizedBox(height: AppDim.pad8),
          const Divider(color: AppColors.borderStrong),
          ListTile(
            title: Text('Delete Phase', style: AppText.body().copyWith(color: AppColors.zoneCriticalFg)),
            leading: const Icon(Icons.delete_outline_rounded, color: AppColors.zoneCriticalFg),
            onTap: () async {
              await ref.read(phaseDaoProvider).deletePhase(phase.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
