import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import '../../providers.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../engine/decay/decay_calculator.dart';

/// Session Active screen — §7.4
/// Full-screen timer, large monospace elapsed time, single Stop button.
/// On stop: optional one-word tag + "next step" note saved as lastNote.
class SessionActiveScreen extends ConsumerStatefulWidget {
  const SessionActiveScreen({
    super.key,
    required this.projectId,
    required this.sessionId,
  });

  final String projectId;
  final String sessionId;

  @override
  ConsumerState<SessionActiveScreen> createState() => _SessionActiveScreenState();
}

class _SessionActiveScreenState extends ConsumerState<SessionActiveScreen> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  DateTime? _startedAt;
  bool _stopping = false;

  static const _tags = ['code', 'read', 'plan', 'design', 'review', 'debug'];

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final sessions = await ref.read(sessionDaoProvider).getSessionsForProject(widget.projectId);
    final session = sessions.where((s) => s.id == widget.sessionId).firstOrNull;
    if (session != null) {
      _startedAt = session.startedAt;
      _elapsed = DateTime.now().difference(_startedAt!);
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _elapsedFormatted {
    final h = _elapsed.inHours;
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  Future<void> _stop(BuildContext context) async {
    _timer?.cancel();

    String? selectedTag;
    String? nextNote;

    // Show stop sheet
    final result = await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _StopSheet(tags: _tags),
    );

    if (result != null) {
      selectedTag = result['tag'];
      nextNote = result['note'];
    }

    if (!mounted) return;
    setState(() => _stopping = true);

    try {
      final now = DateTime.now();
      final duration = now.difference(_startedAt!).inSeconds;
      final sessionDao = ref.read(sessionDaoProvider);
      final projectDao = ref.read(projectDaoProvider);

      await sessionDao.endSession(widget.sessionId, now, duration, selectedTag);

      // EMA update for avgGapDays
      final project = await projectDao.getProjectById(widget.projectId);
      if (project != null) {
        final gapDays = project.lastSessionAt != null
            ? _startedAt!.difference(project.lastSessionAt!).inMinutes / 1440.0
            : project.avgGapDays;
        final newAvg = DecayCalculator.updateAvgGap(project.avgGapDays, gapDays);
        await projectDao.updateAvgGapDays(widget.projectId, newAvg);
        await projectDao.updateLastSessionAt(widget.projectId, now);
        if (nextNote != null && nextNote.isNotEmpty) {
          await projectDao.updateLastNote(widget.projectId, nextNote);
        }
      }

      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _stopping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectAsync = ref.watch(projectByIdProvider(widget.projectId));
    final projectName = projectAsync.valueOrNull?.name ?? '...';

    return Scaffold(
      backgroundColor: PulseColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text(projectName, style: PulseTypography.titleSmall.copyWith(color: PulseColors.textSecondary)),
                  const Spacer(),
                  // Live indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: PulseColors.zoneActiveBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: PulseColors.zoneActive.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: PulseColors.zoneActive, shape: BoxShape.circle)),
                        const SizedBox(width: 5),
                        Text('Live', style: PulseTypography.labelSmall.copyWith(color: PulseColors.zoneActive)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Timer
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_elapsedFormatted, style: PulseTypography.monoDisplay.copyWith(fontSize: 64, fontWeight: FontWeight.w200)),
                    const SizedBox(height: 8),
                    Text('elapsed', style: PulseTypography.labelMedium),
                  ],
                ),
              ),
            ),

            // Stop button
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 48),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: _stopping
                  ? const Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: PulseColors.accent))
                  : ElevatedButton(
                      onPressed: () => _stop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PulseColors.surface,
                        foregroundColor: PulseColors.textPrimary,
                        side: const BorderSide(color: PulseColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('Stop Session', style: PulseTypography.titleSmall),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StopSheet extends StatefulWidget {
  const _StopSheet({required this.tags});
  final List<String> tags;

  @override
  State<_StopSheet> createState() => _StopSheetState();
}

class _StopSheetState extends State<_StopSheet> {
  String? _selectedTag;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: PulseColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 36, height: 3, decoration: BoxDecoration(color: PulseColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Text('SESSION WRAP', style: PulseTypography.labelSmall.copyWith(color: PulseColors.textTertiary, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Text('What were you doing?', style: PulseTypography.titleSmall),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.tags.map((tag) {
              final sel = _selectedTag == tag;
              return GestureDetector(
                onTap: () => setState(() => _selectedTag = sel ? null : tag),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? PulseColors.accentDim : PulseColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: sel ? PulseColors.accent.withOpacity(0.5) : PulseColors.border),
                  ),
                  child: Text(tag, style: PulseTypography.bodySmall.copyWith(color: sel ? PulseColors.accent : PulseColors.textSecondary)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text('What\'s next?', style: PulseTypography.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 2,
            style: PulseTypography.bodyMedium,
            decoration: const InputDecoration(hintText: 'One sentence — where to re-enter next time'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop({'tag': _selectedTag, 'note': _noteController.text.trim()}),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}
