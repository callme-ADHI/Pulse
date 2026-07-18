import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';
import '../../db/database.dart';

/// Horizontal-scroll phase strip with deadline support.
class PhaseStrip extends StatelessWidget {
  const PhaseStrip({
    super.key,
    required this.phases,
    required this.onAddPhase,
    required this.onTapPhase,
  });

  final List<ExecutionPhase> phases;
  final VoidCallback onAddPhase;
  final void Function(ExecutionPhase) onTapPhase;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...phases.map((p) => _PhaseCard(phase: p, onTap: () => onTapPhase(p))),
          _AddPhaseCard(onTap: onAddPhase),
        ],
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({required this.phase, required this.onTap});
  final ExecutionPhase phase;
  final VoidCallback onTap;

  bool get _isDelayed  => phase.status == 'delayed';
  bool get _isOverdue  =>
      phase.deadline != null &&
      phase.status != 'done' &&
      phase.status != 'delayed' &&
      phase.deadline!.isBefore(DateTime.now());

  Color get _statusColor => switch (phase.status) {
    'in_progress' => AppColors.gold,
    'done'        => AppColors.zoneActiveFg,
    'delayed'     => AppColors.zoneCriticalFg,
    _             => AppColors.textMuted,
  };

  Color get _borderColor {
    if (_isDelayed || _isOverdue) return AppColors.zoneCriticalFg.withValues(alpha: 0.6);
    if (phase.status == 'in_progress') return AppColors.gold.withValues(alpha: 0.4);
    if (phase.status == 'done') return AppColors.zoneActiveFg.withValues(alpha: 0.25);
    return AppColors.borderDefault;
  }

  String get _deadlineLabel {
    if (phase.deadline == null) return '';
    final now = DateTime.now();
    final d = phase.deadline!;
    if (phase.status == 'done') {
      return 'Done ${_fmtDate(phase.doneAt ?? d)}';
    }
    if (d.isBefore(now)) {
      final days = now.difference(d).inDays;
      return days == 0 ? 'Due today' : '${days}d overdue';
    }
    final days = d.difference(now).inDays;
    return days == 0 ? 'Due today' : '$days d left';
  }

  Color get _deadlineColor {
    if (phase.deadline == null) return AppColors.textMuted;
    final now = DateTime.now();
    if (phase.status == 'done') return AppColors.zoneActiveFg;
    if (phase.deadline!.isBefore(now)) return AppColors.zoneCriticalFg;
    final days = phase.deadline!.difference(now).inDays;
    if (days <= 2) return AppColors.zoneColdFg;
    if (days <= 7) return AppColors.zoneDriftingFg;
    return AppColors.textSecondary;
  }

  static String _fmtDate(DateTime d) =>
      '${d.day} ${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][d.month - 1]}';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 168,
        margin: const EdgeInsets.only(right: AppDim.pad8),
        padding: const EdgeInsets.all(AppDim.pad12),
        decoration: BoxDecoration(
          color: (_isDelayed || _isOverdue)
              ? AppColors.zoneCriticalBg
              : phase.status == 'in_progress'
                  ? AppColors.surface2
                  : AppColors.surface1,
          borderRadius: BorderRadius.circular(AppDim.radiusCard),
          border: Border.all(color: _borderColor, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status row
            Row(
              children: [
                Container(
                  width: 7, height: 7,
                  decoration: BoxDecoration(
                    color: _statusColor,
                    shape: BoxShape.circle,
                    boxShadow: phase.status == 'in_progress'
                        ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.5), blurRadius: 6)]
                        : null,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    (_isDelayed || _isOverdue)
                        ? 'DELAYED'
                        : phase.status.replaceAll('_', ' ').toUpperCase(),
                    style: AppText.label().copyWith(
                      color: _statusColor,
                      fontSize: 9.5,
                      letterSpacing: 0.8,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Phase name
            Text(
              phase.name,
              style: AppText.titleSmall().copyWith(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            // Deadline badge
            if (phase.deadline != null)
              Row(
                children: [
                  Icon(
                    (_isDelayed || _isOverdue)
                        ? Icons.warning_amber_rounded
                        : Icons.schedule_rounded,
                    size: 11,
                    color: _deadlineColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _deadlineLabel,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: _deadlineColor,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _AddPhaseCard extends StatelessWidget {
  const _AddPhaseCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: AppDim.pad8),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(AppDim.radiusCard),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: AppColors.textMuted, size: 20),
            SizedBox(height: 4),
            Text('Phase', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
