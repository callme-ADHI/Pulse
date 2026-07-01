import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// AEVORAX Pulse — canonical typography (spec §1.2)
/// UI font: DM Sans. Mono font: JetBrains Mono.
abstract final class AppText {
  static TextStyle display() => GoogleFonts.dmSans(
    fontSize: 32, fontWeight: FontWeight.w700,
    letterSpacing: -0.03 * 32, color: AppColors.textPrimary,
  );

  static TextStyle title() => GoogleFonts.dmSans(
    fontSize: 20, fontWeight: FontWeight.w600,
    letterSpacing: -0.02 * 20, color: AppColors.textPrimary,
  );

  static TextStyle titleSmall() => GoogleFonts.dmSans(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle body() => GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w400,
    height: 1.6, color: AppColors.textSecondary,
  );

  static TextStyle bodyWhite() => GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w400,
    height: 1.6, color: AppColors.textPrimary,
  );

  /// Uppercase section label — 10px, 600 weight, +0.12em spacing
  static TextStyle label() => GoogleFonts.dmSans(
    fontSize: 10, fontWeight: FontWeight.w600,
    letterSpacing: 1.2, color: AppColors.textMuted,
    decoration: TextDecoration.none,
  );

  static TextStyle labelGold() => label().copyWith(color: AppColors.gold);
  static TextStyle labelWhite() => label().copyWith(color: AppColors.textPrimary);
  static TextStyle labelSecondary() => label().copyWith(color: AppColors.textSecondary);

  // ── Mono ──────────────────────────────────────────────────────────────────
  static TextStyle monoLarge() => GoogleFonts.jetBrainsMono(
    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );

  static TextStyle monoMed() => GoogleFonts.jetBrainsMono(
    fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.gold,
  );

  static TextStyle monoSmall() => GoogleFonts.jetBrainsMono(
    fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
  );

  static TextStyle monoTimer() => GoogleFonts.jetBrainsMono(
    fontSize: 52, fontWeight: FontWeight.w200, color: AppColors.textPrimary,
    letterSpacing: -1,
  );

  static TextStyle monoScore() => GoogleFonts.jetBrainsMono(
    fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );

  static TextStyle monoCode() => GoogleFonts.jetBrainsMono(
    fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
    height: 1.6,
  );
}
