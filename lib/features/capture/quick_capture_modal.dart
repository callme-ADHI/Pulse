import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import '../../providers.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../db/database.dart';
import 'package:uuid/uuid.dart';

/// Quick Capture modal — §7.6
/// Single text field, Save, closes in <200ms. No project picker.
class QuickCaptureModal extends ConsumerStatefulWidget {
  const QuickCaptureModal({super.key});

  @override
  ConsumerState<QuickCaptureModal> createState() => _QuickCaptureModalState();
}

class _QuickCaptureModalState extends ConsumerState<QuickCaptureModal> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _saving = true);
    const uuid = Uuid();
    await ref.read(ideaDaoProvider).insertIdea(
      IdeasCompanion.insert(id: uuid.v4(), content: text, createdAt: DateTime.now()),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: PulseColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 36, height: 3, decoration: BoxDecoration(color: PulseColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Text('CAPTURE', style: PulseTypography.labelSmall.copyWith(color: PulseColors.textTertiary, letterSpacing: 1.5)),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLines: 3,
            style: PulseTypography.bodyLarge,
            decoration: const InputDecoration(hintText: 'What\'s on your mind?', border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Discard')),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 1.5)) : const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
