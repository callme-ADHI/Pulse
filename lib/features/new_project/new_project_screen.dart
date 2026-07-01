import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import '../../providers.dart';
import '../../db/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';

/// New Project screen — spec §6.6
/// Three fields: name, description, weight slider + estimated hours.
class NewProjectScreen extends ConsumerStatefulWidget {
  const NewProjectScreen({super.key, this.initialName, this.initialDescription});
  final String? initialName;
  final String? initialDescription;

  @override
  ConsumerState<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends ConsumerState<NewProjectScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _estHoursCtrl = TextEditingController();
  double _weight = 1.0;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) _nameCtrl.text = widget.initialName!;
    if (widget.initialDescription != null) _descCtrl.text = widget.initialDescription!;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _estHoursCtrl.dispose();
    super.dispose();
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
          createdAt: DateTime.now(),
        ),
      );

      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          _FieldLabel('WEIGHT'),
          const SizedBox(height: AppDim.pad4),
          Text(
            'How much does this project matter right now? Higher = faster decay.',
            style: AppText.body(),
          ),
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
          const SizedBox(height: AppDim.pad24),
          _FieldLabel('ESTIMATED HOURS (OPTIONAL)'),
          const SizedBox(height: AppDim.pad8),
          TextField(
            controller: _estHoursCtrl,
            style: AppText.bodyWhite(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _inputDec('e.g. 80'),
          ),
          const SizedBox(height: AppDim.pad28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDim.radiusBtn),
                ),
              ),
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const CircularProgressIndicator(
                      strokeWidth: 1.5, color: AppColors.gold,
                    )
                  : Text(
                      'Create Project',
                      style: AppText.titleSmall().copyWith(color: Colors.black),
                    ),
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
    contentPadding: const EdgeInsets.all(AppDim.pad16),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppText.label().copyWith(color: AppColors.gold));
  }
}
