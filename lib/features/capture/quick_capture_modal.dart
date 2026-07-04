import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:uuid/uuid.dart';
import '../../providers.dart';
import '../../db/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';

/// Quick capture modal — spec §6.5
/// Opens from FAB. Saves raw idea to Inbox immediately.
/// Target: <200ms from tap to keyboard up.
class QuickCaptureModal extends ConsumerStatefulWidget {
  const QuickCaptureModal({super.key});

  @override
  ConsumerState<QuickCaptureModal> createState() =>
      _QuickCaptureModalState();
}

class _QuickCaptureModalState extends ConsumerState<QuickCaptureModal> {
  final _ctrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(ideaDaoProvider).insertIdea(
        IdeasCompanion.insert(
          id: const Uuid().v4(),
          content: text,
          createdAt: DateTime.now(),
          status: const Value('unsorted'),
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppDim.radiusCard)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDim.pad20,
        AppDim.pad20,
        AppDim.pad20,
        MediaQuery.of(context).viewInsets.bottom + AppDim.pad28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDim.pad16),
          Text("What's on your mind?",
              style: AppText.label().copyWith(color: AppColors.gold)),
          const SizedBox(height: AppDim.pad8),
          TextField(
            controller: _ctrl,
            autofocus: true,
            style: GoogleFonts.dmSans(
                color: AppColors.textPrimary, fontSize: 15),
            maxLines: 3,
            minLines: 1,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(
              hintText: 'Dump an idea…',
              hintStyle: GoogleFonts.dmSans(
                  color: AppColors.textMuted, fontSize: 14),
              filled: true,
              fillColor: AppColors.surface3,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDim.radiusInput),
                borderSide:
                    const BorderSide(color: AppColors.borderDefault),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDim.radiusInput),
                borderSide:
                    const BorderSide(color: AppColors.borderDefault),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDim.radiusInput),
                borderSide: const BorderSide(
                    color: AppColors.gold, width: 1.5),
              ),
              contentPadding: const EdgeInsets.all(AppDim.pad12),
            ),
          ),
          const SizedBox(height: AppDim.pad16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDim.radiusBtn)),
              ),
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.background),
                    )
                  : Text('Save to Inbox',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
            ),
          ),
        ],
      ),
    );
  }
}
