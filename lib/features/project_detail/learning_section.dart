import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import '../../providers.dart';
import '../../db/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';

/// Learning goals section (spec §6.2 §7)
/// Each goal: topic + toggle to mark done. Gold checkmark when done.
class LearningSection extends ConsumerWidget {
  const LearningSection({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(projectLearningGoalsProvider(projectId));

    return goalsAsync.when(
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
      data: (goals) {
        final done   = goals.where((g) => g.isDone).length;
        final total  = goals.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (total > 0) ...[
              Text(
                'Learning goals: $done of $total done',
                style: AppText.body().copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppDim.pad12),
            ],
            ...goals.map((g) => _GoalRow(goal: g)),
            const SizedBox(height: AppDim.pad8),
            TextButton.icon(
              onPressed: () => _showAddGoalSheet(context, ref),
              icon: const Icon(Icons.add_rounded, size: 16, color: AppColors.textSecondary),
              label: Text('Add goal', style: AppText.body()),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: AppColors.textSecondary,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddGoalSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddGoalSheet(projectId: projectId, ref: ref),
    );
  }
}

class _GoalRow extends ConsumerWidget {
  const _GoalRow({required this.goal});
  final LearningGoal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => ref.read(learningDaoProvider).markDone(goal.id, !goal.isDone),
            child: Container(
              width: 20, height: 20,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: goal.isDone ? AppColors.gold.withValues(alpha: 0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: goal.isDone ? AppColors.gold : AppColors.borderStrong,
                  width: 1.5,
                ),
              ),
              child: goal.isDone
                  ? const Icon(Icons.check_rounded, size: 13, color: AppColors.gold)
                  : null,
            ),
          ),
          const SizedBox(width: AppDim.pad12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.topic,
                  style: AppText.bodyWhite().copyWith(
                    decoration: goal.isDone ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.textMuted,
                    color: goal.isDone ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
                ),
                if (goal.description != null) ...[
                  const SizedBox(height: 2),
                  Text(goal.description!, style: AppText.body().copyWith(fontSize: 12)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddGoalSheet extends StatefulWidget {
  const _AddGoalSheet({required this.projectId, required this.ref});
  final String projectId;
  final WidgetRef ref;

  @override
  State<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<_AddGoalSheet> {
  final _topicCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();

  @override
  void dispose() {
    _topicCtrl.dispose();
    _descCtrl.dispose();
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
          Text('Add Learning Goal', style: AppText.title()),
          const SizedBox(height: AppDim.pad16),
          TextField(
            controller: _topicCtrl,
            autofocus: true,
            style: AppText.bodyWhite(),
            decoration: InputDecoration(
              hintText: 'e.g. Drift query optimisation',
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
            controller: _descCtrl,
            style: AppText.bodyWhite(),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Description (optional)',
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
                if (_topicCtrl.text.trim().isEmpty) return;
                await widget.ref.read(learningDaoProvider).insertGoal(
                  LearningGoalsCompanion.insert(
                    id: const Uuid().v4(),
                    projectId: widget.projectId,
                    topic: _topicCtrl.text.trim(),
                    description: Value(_descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim()),
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
