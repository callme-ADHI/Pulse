import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';
import '../home/home_providers.dart';
import '../../providers.dart';

/// Session Active screen — spec §6.3
/// Full-screen black canvas. 48px mono timer. Tag chips. Ghost Stop button.
class SessionActiveScreen extends ConsumerStatefulWidget {
  const SessionActiveScreen({
    super.key,
    required this.projectId,
    required this.sessionId,
  });
  final String projectId;
  final String sessionId;

  @override
  ConsumerState<SessionActiveScreen> createState() =>
      _SessionActiveScreenState();
}

class _SessionActiveScreenState
    extends ConsumerState<SessionActiveScreen> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  DateTime? _startedAt;
  String? _selectedTag;

  static const _tags = ['code', 'read', 'plan', 'design', 'research'];

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final sessions = await ref
        .read(sessionDaoProvider)
        .getSessionsForProject(widget.projectId);
    final session =
        sessions.where((s) => s.id == widget.sessionId).firstOrNull;
    if (session != null) {
      setState(() {
        _startedAt = session.startedAt;
        _elapsed = DateTime.now().difference(_startedAt!);
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() =>
              _elapsed = DateTime.now().difference(_startedAt!));
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$h : $m : $s';
  }

  void _showStopSheet() {
    String? reason;
    final noteCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface2,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppDim.radiusCard)),
          ),
          padding: EdgeInsets.fromLTRB(
              20, 24, 20, MediaQuery.of(ctx).viewInsets.bottom + 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36, height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.borderStrong,
                    borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Text('Why are you stopping?', style: AppText.title()),
              const SizedBox(height: 14),
              ...['completed_goal', 'got_blocked', 'ran_out_of_time',
                  'lost_focus', 'external_interrupt', 'other'].map((r) =>
                GestureDetector(
                  onTap: () => setS(() => reason = r),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11),
                    decoration: BoxDecoration(
                      color: reason == r ? AppColors.surface3 : Colors.transparent,
                      border: Border.all(
                          color: reason == r
                              ? AppColors.gold
                              : AppColors.borderDefault),
                      borderRadius: BorderRadius.circular(AppDim.radiusBtn),
                    ),
                    child: Text(
                      _reasonLabel(r),
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: reason == r
                            ? AppColors.gold
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                )),
              const SizedBox(height: 14),
              Text('Next step (optional)',
                  style: AppText.label().copyWith(color: AppColors.gold)),
              const SizedBox(height: 8),
              TextField(
                controller: noteCtrl,
                style: GoogleFonts.dmSans(
                    color: AppColors.textPrimary, fontSize: 14),
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'What do I pick up next time?',
                  hintStyle: GoogleFonts.dmSans(
                      color: AppColors.textMuted, fontSize: 13),
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
                        color: AppColors.borderStrong, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(AppDim.pad12),
                ),
              ),
              const SizedBox(height: 20),
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
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await ref
                        .read(sessionNotifierProvider.notifier)
                        .endSession(
                          widget.sessionId,
                          tag: _selectedTag,
                          stopReason: reason,
                          nextStep: noteCtrl.text.trim().isEmpty
                              ? null
                              : noteCtrl.text.trim(),
                        );
                    if (mounted) context.go('/home');
                  },
                  child: Text('Confirm Stop',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _reasonLabel(String r) => switch (r) {
    'completed_goal'     => 'Completed my goal for today',
    'got_blocked'        => 'Got blocked',
    'ran_out_of_time'    => 'Ran out of time',
    'lost_focus'         => 'Lost focus',
    'external_interrupt' => 'External interrupt',
    _                    => 'Other',
  };

  @override
  Widget build(BuildContext context) {
    final projectName = ref
            .watch(projectByIdProvider(widget.projectId))
            .valueOrNull
            ?.name ??
        '…';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDim.pad20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.only(top: AppDim.pad20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.chevron_left,
                          color: AppColors.textMuted, size: 26),
                    ),
                    const Spacer(),
                    Text('SESSION ACTIVE',
                        style: AppText.label()
                            .copyWith(color: AppColors.textMuted)),
                    const Spacer(),
                    Text(projectName,
                        style: AppText.label()
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const Spacer(),
              // Timer
              Text(_formatted,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: 1,
                )),
              const SizedBox(height: 40),
              // Tag chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _tags.map((t) => GestureDetector(
                  onTap: () => setState(
                      () => _selectedTag = _selectedTag == t ? null : t),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedTag == t
                            ? AppColors.gold
                            : AppColors.borderDefault,
                        width: _selectedTag == t ? 1.5 : 1.0,
                      ),
                      borderRadius: BorderRadius.circular(AppDim.radiusPill),
                    ),
                    child: Text(t,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: _selectedTag == t
                            ? AppColors.gold
                            : AppColors.textSecondary,
                      )),
                  ),
                )).toList(),
              ),
              const Spacer(),
              // Stop button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.borderStrong),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDim.radiusBtn)),
                  ),
                  onPressed: _showStopSheet,
                  child: Text('Stop Session', style: AppText.titleSmall()),
                ),
              ),
              const SizedBox(height: AppDim.pad28),
            ],
          ),
        ),
      ),
    );
  }
}
