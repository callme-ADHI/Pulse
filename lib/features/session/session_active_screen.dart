import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import '../../providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';
import '../../engine/decay/decay_calculator.dart';

/// Session Active screen — spec §6.3
/// Full-screen black canvas. Large mono timer. Tag chips. Ghost Stop button.
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

  static const _tags = ['code', 'read', 'plan', 'design', 'research'];

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
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$h : $m : $s';
  }

  Future<void> _stop(BuildContext context) async {
    _timer?.cancel();

    final result = await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const StopSheet(),
    );

    if (!mounted) return;
    if (result == null) {
      // User dismissed without stopping — restart timer
      _startTimer();
      return;
    }

    setState(() => _stopping = true);
    try {
      final now = DateTime.now();
      final duration = now.difference(_startedAt!).inSeconds;
      final sessionDao = ref.read(sessionDaoProvider);
      final projectDao = ref.read(projectDaoProvider);

      await sessionDao.endSession(
        widget.sessionId,
        now,
        duration,
        result['tag'],
        stopReason: result['stopReason'],
        stopNote: result['stopNote'],
        nextStep: result['nextStep'],
      );

      // EMA gap update
      final project = await projectDao.getProjectById(widget.projectId);
      if (project != null) {
        final gapDays = project.lastSessionAt != null
            ? _startedAt!.difference(project.lastSessionAt!).inMinutes / 1440.0
            : project.avgGapDays;
        final newAvg = DecayCalculator.updateAvgGap(project.avgGapDays, gapDays);
        await projectDao.updateAvgGapDays(widget.projectId, newAvg);
        await projectDao.updateLastSessionAt(widget.projectId, now);
        final nextStep = result['nextStep'];
        if (nextStep != null && nextStep.isNotEmpty) {
          await projectDao.updateLastNote(widget.projectId, nextStep);
        }
      }

      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _stopping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectName = ref.watch(projectByIdProvider(widget.projectId)).valueOrNull?.name ?? '…';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(projectName),
            Expanded(child: _timerArea()),
            _tagRow(),
            _stopButton(),
          ],
        ),
      ),
    );
  }

  Widget _topBar(String name) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDim.pad20, AppDim.pad16, AppDim.pad20, 0),
      child: Row(
        children: [
          Text(
            'AEVORAX · PULSE',
            style: AppText.label().copyWith(color: AppColors.textMuted),
          ),
          const Spacer(),
          Text(
            name,
            style: AppText.label().copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _timerArea() {
    return Center(
      child: Text(
        _elapsedFormatted,
        style: AppText.monoTimer(),
      ),
    );
  }

  Widget _tagRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDim.pad20, vertical: AppDim.pad16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _tags.map((t) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDim.pad4),
          child: _TagChip(label: t),
        )).toList(),
      ),
    );
  }

  Widget _stopButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDim.pad20, 0, AppDim.pad20, AppDim.pad28,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: _stopping
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.gold,
                ),
              )
            : OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.borderDefault),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDim.radiusBtn),
                  ),
                ),
                onPressed: () => _stop(context),
                child: Text('Stop Session', style: AppText.titleSmall()),
              ),
      ),
    );
  }
}

class _TagChip extends StatefulWidget {
  const _TagChip({required this.label});
  final String label;

  @override
  State<_TagChip> createState() => _TagChipState();
}

class _TagChipState extends State<_TagChip> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _selected = !_selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _selected ? AppColors.goldDeep.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDim.radiusBtn),
          border: Border.all(
            color: _selected ? AppColors.gold : AppColors.borderDefault,
          ),
        ),
        child: Text(
          widget.label,
          style: AppText.body().copyWith(
            fontSize: 12,
            color: _selected ? AppColors.gold : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Stop Sheet — spec §6.3
/// Bottom sheet with: stop reason radio group + next step text field.
class StopSheet extends StatefulWidget {
  const StopSheet({super.key});

  @override
  State<StopSheet> createState() => _StopSheetState();
}

class _StopSheetState extends State<StopSheet> {
  String? _stopReason;
  final _nextStepCtrl = TextEditingController();

  static const _reasons = [
    ('completed_goal', 'Completed my goal for today'),
    ('got_blocked', 'Got blocked'),
    ('ran_out_of_time', 'Ran out of time'),
    ('lost_focus', 'Lost focus'),
    ('external_interrupt', 'External interrupt'),
    ('other', 'Other'),
  ];

  @override
  void dispose() {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36, height: 3,
              decoration: BoxDecoration(
                color: AppColors.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDim.pad20),
          Text('Why are you stopping?', style: AppText.title()),
          const SizedBox(height: AppDim.pad12),
          ..._reasons.map((r) => _ReasonRow(
            value: r.$1,
            label: r.$2,
            selected: _stopReason == r.$1,
            onTap: () => setState(() => _stopReason = r.$1),
          )),
          const SizedBox(height: AppDim.pad20),
          Text('Next step (optional)', style: AppText.titleSmall()),
          const SizedBox(height: AppDim.pad8),
          TextField(
            controller: _nextStepCtrl,
            style: AppText.bodyWhite(),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'What do I pick up next time?',
              hintStyle: AppText.body(),
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
              contentPadding: const EdgeInsets.all(AppDim.pad12),
            ),
          ),
          const SizedBox(height: AppDim.pad20),
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
              onPressed: () => Navigator.of(context).pop({
                'stopReason': _stopReason,
                'nextStep': _nextStepCtrl.text.trim(),
              }),
              child: Text('Confirm Stop', style: AppText.titleSmall().copyWith(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonRow extends StatelessWidget {
  const _ReasonRow({
    required this.value,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String value;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 18, height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.gold : AppColors.borderStrong,
                  width: selected ? 5 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: AppDim.pad12),
            Text(label, style: AppText.body().copyWith(
              color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            )),
          ],
        ),
      ),
    );
  }
}
