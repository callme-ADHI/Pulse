import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import '../../providers.dart';
import '../../db/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';

/// Dead time section — spec §6.2 §7.5
/// Collapsed by default. Shows count + excluded days. Expand to see list + add button.
class DeadTimeSection extends ConsumerStatefulWidget {
  const DeadTimeSection({super.key, required this.projectId, required this.decayScore});
  final String projectId;
  final double decayScore;

  @override
  ConsumerState<DeadTimeSection> createState() => _DeadTimeSectionState();
}

class _DeadTimeSectionState extends ConsumerState<DeadTimeSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final dtAsync = ref.watch(projectDeadTimesProvider(widget.projectId));

    return dtAsync.when(
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
      data: (periods) {
        final totalDays = _calcTotalDays(periods);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Text(
                    'Dead time: ${periods.length} period${periods.length == 1 ? '' : 's'} · ${totalDays.toStringAsFixed(0)} days excluded',
                    style: AppText.body().copyWith(color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                ],
              ),
            ),
            if (_expanded) ...[
              const SizedBox(height: AppDim.pad12),
              ...periods.map((dt) => _DeadTimeRow(dt: dt, onDelete: () => _delete(dt.id))),
              const SizedBox(height: AppDim.pad8),
              TextButton.icon(
                onPressed: () => _showAddSheet(context),
                icon: const Icon(Icons.add_rounded, size: 16, color: AppColors.textSecondary),
                label: Text('Add dead time', style: AppText.body()),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: AppColors.textSecondary,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  double _calcTotalDays(List<DeadTime> periods) {
    double total = 0;
    for (final dt in periods) {
      total += dt.toDate.difference(dt.fromDate).inMinutes / 1440.0;
    }
    return total;
  }

  Future<void> _delete(String id) async {
    await ref.read(deadTimeDaoProvider).deleteDeadTime(id);
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddDeadTimeSheet(projectId: widget.projectId),
    );
  }
}

class _DeadTimeRow extends StatelessWidget {
  const _DeadTimeRow({required this.dt, required this.onDelete});
  final DeadTime dt;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final fmt  = DateFormat('MMM d, yyyy');
    final days = dt.toDate.difference(dt.fromDate).inDays;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            '${fmt.format(dt.fromDate)} – ${fmt.format(dt.toDate)}',
            style: AppText.monoSmall(),
          ),
          const SizedBox(width: AppDim.pad8),
          Text('$days d', style: AppText.monoSmall().copyWith(color: AppColors.gold)),
          if (dt.reason != null) ...[
            const SizedBox(width: AppDim.pad8),
            Text(dt.reason!, style: AppText.body().copyWith(fontSize: 11)),
          ],
          const Spacer(),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.close_rounded, size: 15, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _AddDeadTimeSheet extends ConsumerStatefulWidget {
  const _AddDeadTimeSheet({required this.projectId});
  final String projectId;

  @override
  ConsumerState<_AddDeadTimeSheet> createState() => _AddDeadTimeSheetState();
}

class _AddDeadTimeSheetState extends ConsumerState<_AddDeadTimeSheet> {
  DateTime? _from;
  DateTime? _to;
  String _reason = 'holiday';
  final _noteCtrl = TextEditingController();

  static const _reasons = ['sick', 'blocked', 'holiday', 'other'];

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.gold),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => isFrom ? _from = picked : _to = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, yyyy');

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
          Text('Add Dead Time', style: AppText.title()),
          const SizedBox(height: AppDim.pad16),
          Row(
            children: [
              Expanded(
                child: _DateBtn(
                  label: _from == null ? 'From' : fmt.format(_from!),
                  onTap: () => _pickDate(true),
                ),
              ),
              const SizedBox(width: AppDim.pad8),
              Expanded(
                child: _DateBtn(
                  label: _to == null ? 'To' : fmt.format(_to!),
                  onTap: () => _pickDate(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDim.pad16),
          Text('REASON', style: AppText.label()),
          const SizedBox(height: AppDim.pad8),
          Wrap(
            spacing: AppDim.pad8,
            children: _reasons.map((r) => GestureDetector(
              onTap: () => setState(() => _reason = r),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _reason == r ? AppColors.gold.withValues(alpha: 0.15) : AppColors.surface3,
                  borderRadius: BorderRadius.circular(AppDim.radiusPill),
                  border: Border.all(
                    color: _reason == r ? AppColors.gold : AppColors.borderDefault,
                  ),
                ),
                child: Text(r, style: AppText.body().copyWith(
                  color: _reason == r ? AppColors.gold : AppColors.textSecondary,
                  fontSize: 12,
                )),
              ),
            )).toList(),
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
              onPressed: (_from == null || _to == null || !_to!.isAfter(_from!))
                  ? null
                  : () async {
                      await ref.read(deadTimeDaoProvider).insertDeadTime(
                        DeadTimesCompanion.insert(
                          id: const Uuid().v4(),
                          projectId: widget.projectId,
                          fromDate: _from!,
                          toDate: _to!,
                          reason: Value(_reason),
                        ),
                      );
                      if (context.mounted) Navigator.pop(context);
                    },
              child: Text('Save', style: AppText.titleSmall().copyWith(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateBtn extends StatelessWidget {
  const _DateBtn({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDim.pad12, vertical: AppDim.pad12),
        decoration: BoxDecoration(
          color: AppColors.surface3,
          borderRadius: BorderRadius.circular(AppDim.radiusBtn),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: AppDim.pad8),
            Text(label, style: AppText.body().copyWith(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
