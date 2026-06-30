import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import '../../db/database.dart';
import '../../providers.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import 'package:uuid/uuid.dart';

class NewProjectScreen extends ConsumerStatefulWidget {
  const NewProjectScreen({super.key});

  @override
  ConsumerState<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends ConsumerState<NewProjectScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _priority = 'medium';
  bool _saving = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      const uuid = Uuid();
      final id = uuid.v4();
      await ref.read(projectDaoProvider).insertProject(
        ProjectsCompanion.insert(
          id: id,
          name: _nameController.text.trim(),
          description: Value(_descController.text.trim().isEmpty ? null : _descController.text.trim()),
          priority: Value(_priority),
          createdAt: DateTime.now(),
          colorSeed: Value(id.substring(0, 6)),
        ),
      );
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Project created'), action: SnackBarAction(label: 'View', onPressed: () => context.pushNamed('projectDetail', pathParameters: {'id': id}))),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PulseColors.background,
      appBar: AppBar(
        title: const Text('New Project'),
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => context.pop()),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 1.5, color: PulseColors.accent))
                : TextButton(onPressed: _save, child: Text('Create', style: PulseTypography.titleSmall.copyWith(color: PulseColors.accent))),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('PROJECT NAME', style: PulseTypography.labelSmall.copyWith(color: PulseColors.textTertiary, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              autofocus: true,
              style: PulseTypography.titleMedium,
              decoration: const InputDecoration(hintText: 'e.g. Habit Atlas'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 24),
            Text('DESCRIPTION', style: PulseTypography.labelSmall.copyWith(color: PulseColors.textTertiary, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              style: PulseTypography.bodyMedium,
              decoration: const InputDecoration(hintText: 'What are you building and why? (optional)'),
            ),
            const SizedBox(height: 24),
            Text('PRIORITY', style: PulseTypography.labelSmall.copyWith(color: PulseColors.textTertiary, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final p in [('Low', 'low', PulseColors.textTertiary), ('Medium', 'medium', PulseColors.textSecondary), ('High', 'high', PulseColors.zoneCritical)])
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _priority = p.$2),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _priority == p.$2 ? p.$3.withOpacity(0.12) : PulseColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _priority == p.$2 ? p.$3.withOpacity(0.5) : PulseColors.border, width: _priority == p.$2 ? 1.5 : 1.0),
                        ),
                        child: Center(child: Text(p.$1, style: PulseTypography.bodyMedium.copyWith(color: _priority == p.$2 ? p.$3 : PulseColors.textSecondary, fontWeight: _priority == p.$2 ? FontWeight.w600 : FontWeight.w400))),
                      ),
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
