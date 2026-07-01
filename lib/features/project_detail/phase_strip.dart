import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';
import '../../db/database.dart';

/// Horizontal-scroll phase strip (spec §6.2 §4)
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
      height: 90,
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

  Color get _dotColor => switch (phase.status) {
    'in_progress' => AppColors.gold,
    'done'        => AppColors.zoneActiveFg,
    _             => AppColors.textMuted,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: AppDim.pad8),
        padding: const EdgeInsets.all(AppDim.pad12),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(AppDim.radiusCard),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: _dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppDim.pad8),
                Expanded(
                  child: Text(
                    phase.status.replaceAll('_', ' ').toUpperCase(),
                    style: AppText.label(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDim.pad8),
            Text(
              phase.name,
              style: AppText.titleSmall().copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (phase.summary != null) ...[
              const SizedBox(height: 4),
              Text(
                phase.summary!,
                style: AppText.body().copyWith(fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
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
