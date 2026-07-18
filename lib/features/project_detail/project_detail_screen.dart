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
import 'project_connections_section.dart';

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
                    // ── Project Status & Zone Info ──────────────────
                    Row(
                      children: [
                        ZoneBadge(zone: zone),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surface1,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.borderStrong),
                          ),
                          child: Text(
                            'DECAY SCORE: ${score.toInt()}%',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.zoneFg(zone),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

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

                    // ── Connections (Project-Project & Project-Idea) ──
                    _SectionHeader('PROJECT CONNECTIONS'),
                    const SizedBox(height: 12),
                    ProjectConnectionsSection(projectId: projectId),
                    const SizedBox(height: 24),

                    // ── Ideas List ───────────────────────────────────
                    Row(
                      children: [
                        Expanded(child: _SectionHeader('LINKED IDEAS')),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => _showManageIdeasSheet(context, ref, project.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.edit_rounded, color: AppColors.gold, size: 12),
                                const SizedBox(width: 4),
                                Text('Edit', style: AppText.label().copyWith(color: AppColors.gold, fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

class _DetailAppBar extends ConsumerWidget {
  const _DetailAppBar({
    required this.project,
    required this.zone,
    required this.score,
  });

  final Project project;
  final String zone;
  final double score;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      expandedHeight: 130,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left_rounded, color: AppColors.textSecondary, size: 28),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_rounded, color: AppColors.textSecondary, size: 20),
          onPressed: () => _showEditProjectSheet(context, ref, project),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary, size: 20),
          color: AppColors.surface2,
          onSelected: (value) async {
            if (value == 'drop') {
              final reason = await _showDropDialog(context, project.name);
              if (reason != null) {
                await ref.read(projectDaoProvider).dropProject(project.id, reason);
                if (context.mounted) {
                  context.pop();
                }
              }
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'drop',
              child: Row(
                children: [
                  Icon(Icons.block_rounded, color: Colors.redAccent, size: 18),
                  SizedBox(width: 8),
                  Text('Drop Project', style: TextStyle(color: Colors.redAccent)),
                ],
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(56, 0, 56, 14),
        title: Text(
          project.name,
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
    return GestureDetector(
      onTap: () => context.push('/idea/${idea.id}'),
      child: Padding(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    idea.content,
                    style: AppText.body().copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (idea.description != null && idea.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      idea.description!,
                      style: AppText.body().copyWith(color: AppColors.textMuted, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.textMuted),
          ],
        ),
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

class _SessionRow extends ConsumerWidget {
  const _SessionRow({required this.session});
  final Session session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fmt = DateFormat('MMM d, yyyy');
    final dur = session.durationSeconds;
    final durStr = dur != null
        ? '${(dur ~/ 3600).toString().padLeft(2, '0')}:${((dur % 3600) ~/ 60).toString().padLeft(2, '0')}'
        : '—';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Dismissible(
        key: Key(session.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.zoneCriticalFg.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.delete_outline_rounded, color: AppColors.zoneCriticalFg),
        ),
        confirmDismiss: (direction) async {
          return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.surface2,
              title: Text('Delete Session?', style: AppText.title()),
              content: Text('Are you sure you want to delete this session? This action cannot be undone.', style: AppText.body()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('CANCEL', style: AppText.body().copyWith(color: AppColors.textMuted)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('DELETE', style: AppText.body().copyWith(color: AppColors.zoneCriticalFg)),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) {
          ref.read(sessionDaoProvider).deleteSession(session.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.surface2,
              content: Text('Session deleted', style: AppText.body()),
            ),
          );
        },
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => _EditSessionSheet(session: session, ref: ref),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                const Spacer(),
                const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditSessionSheet extends StatefulWidget {
  const _EditSessionSheet({required this.session, required this.ref});
  final Session session;
  final WidgetRef ref;

  @override
  State<_EditSessionSheet> createState() => _EditSessionSheetState();
}

class _EditSessionSheetState extends State<_EditSessionSheet> {
  late final TextEditingController _durationCtrl;
  late final TextEditingController _tagCtrl;
  late final TextEditingController _nextStepCtrl;
  String? _stopReason;

  final List<String> _stopReasons = [
    'completed_goal',
    'got_blocked',
    'ran_out_of_time',
    'lost_focus',
    'external_interrupt',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    final minutes = (widget.session.durationSeconds ?? 0) ~/ 60;
    _durationCtrl = TextEditingController(text: minutes.toString());
    _tagCtrl = TextEditingController(text: widget.session.tag ?? '');
    _nextStepCtrl = TextEditingController(text: widget.session.nextStep ?? '');
    _stopReason = widget.session.stopReason;
  }

  @override
  void dispose() {
    _durationCtrl.dispose();
    _tagCtrl.dispose();
    _nextStepCtrl.dispose();
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Edit Session', style: AppText.title()),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.zoneCriticalFg),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.surface2,
                        title: Text('Delete Session?', style: AppText.title()),
                        content: Text('Are you sure you want to delete this session?', style: AppText.body()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('CANCEL', style: AppText.body().copyWith(color: AppColors.textMuted)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('DELETE', style: AppText.body().copyWith(color: AppColors.zoneCriticalFg)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await widget.ref.read(sessionDaoProvider).deleteSession(widget.session.id);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.surface2,
                            content: Text('Session deleted', style: AppText.body()),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: AppDim.pad16),
            Text('DURATION (MINUTES)', style: AppText.body().copyWith(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            TextField(
              controller: _durationCtrl,
              keyboardType: TextInputType.number,
              style: AppText.bodyWhite(),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface3,
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
              ),
            ),
            const SizedBox(height: AppDim.pad16),
            Text('TAG', style: AppText.body().copyWith(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            TextField(
              controller: _tagCtrl,
              style: AppText.bodyWhite(),
              decoration: InputDecoration(
                hintText: 'e.g. coding, writing, research',
                hintStyle: AppText.body().copyWith(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surface3,
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
              ),
            ),
            const SizedBox(height: AppDim.pad16),
            Text('STOP REASON', style: AppText.body().copyWith(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surface3,
                borderRadius: BorderRadius.circular(AppDim.radiusInput),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _stopReason,
                  isExpanded: true,
                  dropdownColor: AppColors.surface2,
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                  hint: Text('Select stop reason', style: AppText.body().copyWith(color: AppColors.textMuted)),
                  items: _stopReasons.map((r) {
                    return DropdownMenuItem<String>(
                      value: r,
                      child: Text(
                        r.replaceAll('_', ' ').toUpperCase(),
                        style: AppText.bodyWhite(),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => _stopReason = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: AppDim.pad16),
            Text('NEXT STEP', style: AppText.body().copyWith(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            TextField(
              controller: _nextStepCtrl,
              maxLines: 3,
              style: AppText.bodyWhite(),
              decoration: InputDecoration(
                hintText: 'What will you do next?',
                hintStyle: AppText.body().copyWith(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surface3,
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
              ),
            ),
            const SizedBox(height: AppDim.pad20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDim.radiusBtn),
                  ),
                ),
                onPressed: () async {
                  final durationMin = int.tryParse(_durationCtrl.text.trim()) ?? 0;
                  final durationSec = durationMin * 60;
                  await widget.ref.read(sessionDaoProvider).updateSession(
                    widget.session.id,
                    tag: Value(_tagCtrl.text.trim().isEmpty ? null : _tagCtrl.text.trim()),
                    stopReason: Value(_stopReason),
                    nextStep: Value(_nextStepCtrl.text.trim().isEmpty ? null : _nextStepCtrl.text.trim()),
                    durationSeconds: Value(durationSec),
                  );
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text('Save Changes', style: AppText.titleSmall().copyWith(color: Colors.black)),
              ),
            ),
          ],
        ),
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
  DateTime? _deadline;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sumCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.gold,
            onPrimary: Colors.black,
            surface: AppColors.surface2,
            onSurface: Colors.white,
          ),
          dialogTheme: const DialogThemeData(
            backgroundColor: AppColors.surface2,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  static String _fmtDate(DateTime d) =>
      '${d.day} ${["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"][d.month - 1]} ${d.year}';

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
          const SizedBox(height: AppDim.pad12),
          // Deadline picker row
          GestureDetector(
            onTap: () => _pickDeadline(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface3,
                borderRadius: BorderRadius.circular(AppDim.radiusInput),
                border: Border.all(
                  color: _deadline != null ? AppColors.gold.withValues(alpha: 0.5) : AppColors.borderDefault,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: _deadline != null ? AppColors.gold : AppColors.textMuted,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _deadline != null
                        ? 'Deadline: ${_fmtDate(_deadline!)}'
                        : 'Set deadline (optional)',
                    style: AppText.body().copyWith(
                      color: _deadline != null ? AppColors.gold : AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (_deadline != null)
                    GestureDetector(
                      onTap: () => setState(() => _deadline = null),
                      child: const Icon(Icons.close_rounded, size: 16, color: AppColors.textSecondary),
                    ),
                ],
              ),
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
                    status: const Value('upcoming'),
                    order: phases.length,
                    deadline: Value(_deadline),
                  ),
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: Text('Add Phase', style: AppText.titleSmall().copyWith(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditPhaseSheet extends StatefulWidget {
  const _EditPhaseSheet({required this.phase, required this.ref});
  final ExecutionPhase phase;
  final WidgetRef ref;

  @override
  State<_EditPhaseSheet> createState() => _EditPhaseSheetState();
}

class _EditPhaseSheetState extends State<_EditPhaseSheet> {
  late DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _deadline = widget.phase.deadline;
  }

  Future<void> _pickDeadline(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.gold,
            onPrimary: Colors.black,
            surface: AppColors.surface2,
            onSurface: Colors.white,
          ),
          dialogTheme: const DialogThemeData(
            backgroundColor: AppColors.surface2,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  static String _fmtDate(DateTime d) =>
      '${d.day} ${["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"][d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDim.radiusCard)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Edit Phase: ${widget.phase.name}', style: AppText.title()),
          const SizedBox(height: AppDim.pad16),
          // Status selection
          ...['upcoming', 'in_progress', 'done'].map((s) => ListTile(
            dense: true,
            title: Text(
              s.replaceAll('_', ' ').toUpperCase(),
              style: AppText.body().copyWith(
                color: widget.phase.status == s ? AppColors.gold : AppColors.textPrimary,
              ),
            ),
            trailing: widget.phase.status == s
                ? const Icon(Icons.check_rounded, color: AppColors.gold)
                : null,
            onTap: () async {
              await widget.ref.read(phaseDaoProvider).updateStatus(
                widget.phase.id,
                s,
                doneAt: s == 'done' ? DateTime.now() : null,
              );
              // Save deadline update too
              await widget.ref.read(phaseDaoProvider).updatePhase(
                ExecutionPhasesCompanion(
                  id: Value(widget.phase.id),
                  deadline: Value(_deadline),
                ),
              );
              if (context.mounted) Navigator.pop(context);
            },
          )),
          const SizedBox(height: 8),
          const Divider(color: AppColors.borderStrong),
          // Deadline picker
          GestureDetector(
            onTap: () => _pickDeadline(context),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface3,
                borderRadius: BorderRadius.circular(AppDim.radiusInput),
                border: Border.all(
                  color: _deadline != null ? AppColors.gold.withValues(alpha: 0.5) : AppColors.borderDefault,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: _deadline != null ? AppColors.gold : AppColors.textMuted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _deadline != null
                          ? 'Deadline: ${_fmtDate(_deadline!)}'
                          : 'Set deadline',
                      style: AppText.body().copyWith(
                        color: _deadline != null ? AppColors.gold : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (_deadline != null)
                    GestureDetector(
                      onTap: () => setState(() => _deadline = null),
                      child: const Icon(Icons.close_rounded, size: 16, color: AppColors.textSecondary),
                    ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDim.radiusBtn),
              ),
            ),
            onPressed: () async {
              await widget.ref.read(phaseDaoProvider).updatePhase(
                ExecutionPhasesCompanion(
                  id: Value(widget.phase.id),
                  deadline: Value(_deadline),
                ),
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save Deadline'),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.borderStrong),
          ListTile(
            dense: true,
            title: Text('Delete Phase', style: AppText.body().copyWith(color: AppColors.zoneCriticalFg)),
            leading: const Icon(Icons.delete_outline_rounded, color: AppColors.zoneCriticalFg),
            onTap: () async {
              await widget.ref.read(phaseDaoProvider).deletePhase(widget.phase.id);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

Future<String?> _showDropDialog(BuildContext context, String projectName) async {
  final ctrl = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF0D0D0D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text('Drop "$projectName"?', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dropped projects are removed from active lists but preserved in the archive with their reason.', style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 16),
          const Text('REASON (OPTIONAL)', style: TextStyle(color: Color(0xFFC9A84C), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            autofocus: true,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Why are you dropping this? (optional)',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFC93030), width: 1.5)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white38))),
        TextButton(
          onPressed: () => Navigator.pop(ctx, ctrl.text.trim().isEmpty ? 'No reason given' : ctrl.text.trim()),
          child: const Text('DROP IT', style: TextStyle(color: Color(0xFFC93030), fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        ),
      ],
    ),
  );
}

void _showManageIdeasSheet(BuildContext context, WidgetRef ref, String projectId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ManageIdeasSheet(projectId: projectId),
  );
}

class _ManageIdeasSheet extends ConsumerStatefulWidget {
  const _ManageIdeasSheet({required this.projectId});
  final String projectId;

  @override
  ConsumerState<_ManageIdeasSheet> createState() => _ManageIdeasSheetState();
}

class _ManageIdeasSheetState extends ConsumerState<_ManageIdeasSheet> {
  final _newIdeaCtrl = TextEditingController();
  bool _adding = false;

  @override
  void dispose() {
    _newIdeaCtrl.dispose();
    super.dispose();
  }

  Future<void> _quickAdd() async {
    final text = _newIdeaCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _adding = true);
    try {
      final id = const Uuid().v4();
      await ref.read(ideaDaoProvider).insertIdea(
        IdeasCompanion.insert(
          id: id,
          content: text,
          projectId: Value(widget.projectId),
          status: const Value('linked'),
          createdAt: DateTime.now(),
        ),
      );
      _newIdeaCtrl.clear();
    } finally {
      setState(() => _adding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ideasAsync = ref.watch(allIdeasProvider);
    final allIdeas = ideasAsync.valueOrNull ?? [];
    final linkedIdeas = allIdeas.where((i) => i.projectId == widget.projectId && i.status == 'linked').toList();
    final unsortedIdeas = allIdeas.where((i) => i.status == 'unsorted').toList();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDim.radiusCard)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDim.pad20, AppDim.pad16, AppDim.pad20,
        MediaQuery.of(context).viewInsets.bottom + AppDim.pad28,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Manage Linked Ideas', style: AppText.title()),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppDim.pad16),
            Text('QUICK ADD IDEA', style: AppText.label().copyWith(color: AppColors.gold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newIdeaCtrl,
                    style: AppText.bodyWhite(),
                    decoration: InputDecoration(
                      hintText: 'New idea to link...',
                      hintStyle: AppText.body().copyWith(color: AppColors.textMuted),
                      filled: true,
                      fillColor: AppColors.surface3,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.gold, width: 1.0)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _quickAdd(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: _adding ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.black)) : const Icon(Icons.add_rounded),
                  onPressed: _adding ? null : _quickAdd,
                ),
              ],
            ),
            const SizedBox(height: AppDim.pad24),

            // Linked Ideas Section
            Text('LINKED TO THIS PROJECT', style: AppText.label().copyWith(color: AppColors.gold)),
            const SizedBox(height: 8),
            if (linkedIdeas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('No ideas linked yet.', style: AppText.body().copyWith(color: AppColors.textMuted)),
              )
            else
              ...linkedIdeas.map((idea) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface3,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded, color: AppColors.gold, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(idea.content, style: AppText.bodyWhite().copyWith(fontSize: 13))),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.link_off_rounded, color: Colors.redAccent, size: 18),
                      onPressed: () async {
                        await ref.read(ideaDaoProvider).updateIdea(
                          IdeasCompanion(
                            id: Value(idea.id),
                            projectId: const Value(null),
                            status: const Value('unsorted'),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              )),
            const SizedBox(height: AppDim.pad24),

            // Unsorted Inbox Ideas Section
            Text('ADD FROM INBOX', style: AppText.label().copyWith(color: AppColors.gold)),
            const SizedBox(height: 8),
            if (unsortedIdeas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Inbox is empty.', style: AppText.body().copyWith(color: AppColors.textMuted)),
              )
            else
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView(
                  shrinkWrap: true,
                  children: unsortedIdeas.map((idea) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surface1,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderDefault),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mail_outline_rounded, color: AppColors.textMuted, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(idea.content, style: AppText.body().copyWith(fontSize: 13, color: AppColors.textSecondary))),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add_link_rounded, color: AppColors.gold, size: 18),
                          onPressed: () async {
                            await ref.read(ideaDaoProvider).linkIdeaToProject(idea.id, widget.projectId);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void _showEditProjectSheet(BuildContext context, WidgetRef ref, Project project) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _EditProjectSheet(project: project, ref: ref),
  );
}

class _EditProjectSheet extends StatefulWidget {
  const _EditProjectSheet({required this.project, required this.ref});
  final Project project;
  final WidgetRef ref;

  @override
  State<_EditProjectSheet> createState() => _EditProjectSheetState();
}

class _EditProjectSheetState extends State<_EditProjectSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _estHoursCtrl;
  late double _weight;
  bool _saving = false;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.project.name);
    _descCtrl = TextEditingController(text: widget.project.description ?? '');
    final estHours = widget.project.estimatedMinutes != null
        ? widget.project.estimatedMinutes! / 60.0
        : null;
    _estHoursCtrl = TextEditingController(
      text: estHours != null ? estHours.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '') : '',
    );
    _weight = widget.project.weight ?? 1.0;
    _startDate = widget.project.startDate;
    _endDate = widget.project.endDate;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _estHoursCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final now = DateTime.now();
    final initial = isStart ? (_startDate ?? now) : (_endDate ?? now.add(const Duration(days: 30)));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 3650)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.gold, surface: AppColors.surface2),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) _endDate = null;
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final hours = double.tryParse(_estHoursCtrl.text.trim());
      final minutes = hours != null ? (hours * 60).toInt() : null;

      await widget.ref.read(projectDaoProvider).updateProject(
        ProjectsCompanion(
          id: Value(widget.project.id),
          name: Value(_nameCtrl.text.trim()),
          description: Value(_descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim()),
          weight: Value(_weight),
          estimatedMinutes: Value(minutes),
          startDate: Value(_startDate),
          endDate: Value(_endDate),
        ),
      );

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Edit Project Info', style: AppText.title()),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppDim.pad16),
            Text('PROJECT NAME', style: AppText.body().copyWith(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              style: AppText.bodyWhite(),
              decoration: _inputDec('e.g. Habit Atlas'),
            ),
            const SizedBox(height: AppDim.pad16),
            Text('DESCRIPTION / NOTES', style: AppText.body().copyWith(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              style: AppText.bodyWhite(),
              decoration: _inputDec('What are you building and why?'),
            ),
            const SizedBox(height: AppDim.pad16),
            Text('WEIGHT', style: AppText.body().copyWith(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(
              'How much does this project matter right now? Higher = faster decay.',
              style: AppText.body().copyWith(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.gold,
                      inactiveTrackColor: AppColors.borderStrong,
                      thumbColor: AppColors.gold,
                      overlayColor: AppColors.gold.withValues(alpha: 0.15),
                      trackHeight: 2,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    ),
                    child: Slider(
                      value: _weight,
                      min: 0.1,
                      max: 5.0,
                      divisions: 49,
                      onChanged: (v) => setState(() => _weight = v),
                    ),
                  ),
                ),
                const SizedBox(width: AppDim.pad12),
                SizedBox(
                  width: 40,
                  child: Text(
                    _weight.toStringAsFixed(1),
                    style: AppText.monoMed(),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDim.pad16),
            Text('ESTIMATED HOURS (OPTIONAL)', style: AppText.body().copyWith(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            TextField(
              controller: _estHoursCtrl,
              style: AppText.bodyWhite(),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDec('e.g. 80'),
            ),
            const SizedBox(height: AppDim.pad16),
            Text('TIMELINE (OPTIONAL)', style: AppText.body().copyWith(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(child: _EditDatePicker(
                  label: 'START DATE',
                  date: _startDate,
                  onTap: () => _pickDate(true),
                  onClear: () => setState(() => _startDate = null),
                )),
                const SizedBox(width: 12),
                Expanded(child: _EditDatePicker(
                  label: 'DEADLINE',
                  date: _endDate,
                  onTap: () => _pickDate(false),
                  onClear: () => setState(() => _endDate = null),
                  isDeadline: true,
                )),
              ],
            ),
            const SizedBox(height: AppDim.pad24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDim.radiusBtn),
                  ),
                ),
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const CircularProgressIndicator(strokeWidth: 1.5, color: Colors.black)
                    : Text(
                        'Save Changes',
                        style: AppText.titleSmall().copyWith(color: Colors.black),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: AppText.body().copyWith(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surface3,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.0),
        ),
        contentPadding: const EdgeInsets.all(AppDim.pad12),
      );
}

class _EditDatePicker extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap, onClear;
  final bool isDeadline;

  const _EditDatePicker({
    required this.label, required this.date,
    required this.onTap, required this.onClear,
    this.isDeadline = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;
    final fmt = DateFormat('MMM dd, yyyy');
    final daysLeft = hasDate ? date!.difference(DateTime.now()).inDays : null;
    final overdue = isDeadline && daysLeft != null && daysLeft < 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: hasDate
              ? (overdue ? const Color(0xFF1A0505) : AppColors.gold.withValues(alpha: 0.07))
              : AppColors.surface3,
          borderRadius: BorderRadius.circular(AppDim.radiusInput),
          border: Border.all(
            color: hasDate
                ? (overdue ? const Color(0xFFC93030) : AppColors.gold.withValues(alpha: 0.5))
                : AppColors.borderDefault,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: AppText.label().copyWith(fontSize: 9, color: hasDate ? AppColors.gold : AppColors.textMuted)),
                if (hasDate) GestureDetector(onTap: onClear, child: const Icon(Icons.close_rounded, size: 14, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 6),
            if (hasDate) ...[
              Text(fmt.format(date!), style: AppText.bodyWhite().copyWith(fontSize: 13)),
              if (isDeadline && daysLeft != null) ...[
                const SizedBox(height: 2),
                Text(
                  overdue ? '${-daysLeft}d overdue' : (daysLeft == 0 ? 'Today!' : '$daysLeft days left'),
                  style: TextStyle(fontSize: 10, color: overdue ? const Color(0xFFC93030) : AppColors.textSecondary),
                ),
              ],
            ] else
              Text('Tap to set', style: AppText.body().copyWith(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
