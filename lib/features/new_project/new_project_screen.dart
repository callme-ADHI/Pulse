import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:intl/intl.dart';
import '../../providers.dart';
import '../../db/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';

/// New Project screen — with linked ideas and optional deadline.
class NewProjectScreen extends ConsumerStatefulWidget {
  const NewProjectScreen({
    super.key,
    this.initialName,
    this.initialDescription,
    this.ideaId,
  });

  final String? initialName;
  final String? initialDescription;
  final String? ideaId;

  @override
  ConsumerState<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends ConsumerState<NewProjectScreen> {
  final _nameCtrl     = TextEditingController();
  final _descCtrl     = TextEditingController();
  final _estHoursCtrl = TextEditingController();
  double _weight = 1.0;
  bool _saving = false;

  // Deadline
  DateTime? _startDate;
  DateTime? _endDate;

  // Linked ideas (extra idea IDs to link in addition to the promoted one)
  final Set<String> _linkedIdeaIds = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) _nameCtrl.text = widget.initialName!;
    if (widget.initialDescription != null) _descCtrl.text = widget.initialDescription!;
    if (widget.ideaId != null && widget.ideaId!.isNotEmpty) _linkedIdeaIds.add(widget.ideaId!);
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
      final id = const Uuid().v4();
      final estimatedHours = double.tryParse(_estHoursCtrl.text.trim());
      final estimatedMinutes = estimatedHours != null ? (estimatedHours * 60).toInt() : null;

      await ref.read(projectDaoProvider).insertProject(
        ProjectsCompanion.insert(
          id: id,
          name: _nameCtrl.text.trim(),
          description: Value(_descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim()),
          weight: Value(_weight),
          estimatedMinutes: Value(estimatedMinutes),
          startDate: Value(_startDate),
          endDate: Value(_endDate),
          createdAt: DateTime.now(),
        ),
      );

      // Link all selected ideas to this project
      final ideaDao = ref.read(ideaDaoProvider);
      for (final ideaId in _linkedIdeaIds) {
        await ideaDao.promoteIdea(ideaId, id);
      }

      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ideasAsync = ref.watch(allIdeasProvider);
    final allIdeas = ideasAsync.valueOrNull?.where((i) => i.status == 'unsorted').toList() ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
        title: Text('New Project', style: AppText.title()),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDim.pad20),
        children: [
          _FieldLabel('PROJECT NAME'),
          const SizedBox(height: AppDim.pad8),
          TextField(
            controller: _nameCtrl,
            autofocus: true,
            style: AppText.bodyWhite(),
            decoration: _inputDec('e.g. Habit Atlas'),
          ),
          const SizedBox(height: AppDim.pad24),
          _FieldLabel('DESCRIPTION / INITIAL IDEA DUMP'),
          const SizedBox(height: AppDim.pad8),
          TextField(
            controller: _descCtrl,
            style: AppText.bodyWhite(),
            maxLines: 4,
            decoration: _inputDec('What are you building and why?'),
          ),
          const SizedBox(height: AppDim.pad24),

          // Deadline section
          _FieldLabel('TIMELINE (OPTIONAL)'),
          const SizedBox(height: 6),
          Text('Optional start and end dates. The deadline will be flagged on project cards.',
              style: AppText.body()),
          const SizedBox(height: AppDim.pad12),
          Row(
            children: [
              Expanded(child: _DatePicker(
                label: 'START DATE',
                date: _startDate,
                onTap: () => _pickDate(true),
                onClear: () => setState(() => _startDate = null),
              )),
              const SizedBox(width: 12),
              Expanded(child: _DatePicker(
                label: 'DEADLINE',
                date: _endDate,
                onTap: () => _pickDate(false),
                onClear: () => setState(() => _endDate = null),
                isDeadline: true,
              )),
            ],
          ),

          const SizedBox(height: AppDim.pad24),
          _FieldLabel('WEIGHT'),
          const SizedBox(height: AppDim.pad4),
          Text('How much does this project matter right now? Higher = faster decay.', style: AppText.body()),
          const SizedBox(height: AppDim.pad12),
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
                    min: 0.1, max: 5.0, divisions: 49,
                    onChanged: (v) => setState(() => _weight = v),
                  ),
                ),
              ),
              const SizedBox(width: AppDim.pad12),
              SizedBox(
                width: 40,
                child: Text(_weight.toStringAsFixed(1), style: AppText.monoMed(), textAlign: TextAlign.end),
              ),
            ],
          ),

          const SizedBox(height: AppDim.pad24),
          _FieldLabel('ESTIMATED HOURS (OPTIONAL)'),
          const SizedBox(height: AppDim.pad8),
          TextField(
            controller: _estHoursCtrl,
            style: AppText.bodyWhite(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _inputDec('e.g. 80'),
          ),

          // Linked ideas section
          if (allIdeas.isNotEmpty) ...[
            const SizedBox(height: AppDim.pad24),
            _FieldLabel('LINK INBOX IDEAS (OPTIONAL)'),
            const SizedBox(height: 6),
            Text('Select ideas to promote and link to this project.',
                style: AppText.body()),
            const SizedBox(height: AppDim.pad12),
            ...allIdeas.map((idea) {
              final selected = _linkedIdeaIds.contains(idea.id);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected) _linkedIdeaIds.remove(idea.id);
                  else _linkedIdeaIds.add(idea.id);
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.gold.withValues(alpha: 0.10) : AppColors.surface1,
                    borderRadius: BorderRadius.circular(AppDim.radiusInput),
                    border: Border.all(color: selected ? AppColors.gold : AppColors.borderDefault, width: selected ? 1.5 : 1.0),
                  ),
                  child: Row(
                    children: [
                      Icon(selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                          size: 18, color: selected ? AppColors.gold : AppColors.textMuted),
                      const SizedBox(width: 10),
                      Expanded(child: Text(idea.content, style: AppText.body().copyWith(color: selected ? Colors.white : AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              );
            }),
          ],

          const SizedBox(height: AppDim.pad28),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDim.radiusBtn)),
              ),
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold)
                  : Text('Create Project', style: AppText.titleSmall().copyWith(color: Colors.black)),
            ),
          ),
          const SizedBox(height: AppDim.pad28),
        ],
      ),
    );
  }

  InputDecoration _inputDec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: AppText.body(),
    filled: true,
    fillColor: AppColors.surface2,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.gold, width: 1.0)),
    contentPadding: const EdgeInsets.all(AppDim.pad16),
  );
}

class _DatePicker extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap, onClear;
  final bool isDeadline;

  const _DatePicker({
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
              : AppColors.surface2,
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppText.label().copyWith(color: AppColors.gold));
  }
}
