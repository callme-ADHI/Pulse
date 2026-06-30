import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// AEVORAX typography.
/// - Inter for all UI chrome
/// - JetBrains Mono for numbers, timers, YAML, and any precision data
abstract final class PulseTypography {
  // ── Display ───────────────────────────────────────────────────────────────
  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: PulseColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle displayMedium = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: PulseColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.25,
  );

  // ── Title ─────────────────────────────────────────────────────────────────
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: PulseColors.textPrimary,
    letterSpacing: -0.2,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: PulseColors.textPrimary,
    letterSpacing: -0.1,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: PulseColors.textPrimary,
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: PulseColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: PulseColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: PulseColors.textSecondary,
    height: 1.4,
  );

  // ── Label ─────────────────────────────────────────────────────────────────
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: PulseColors.textSecondary,
    letterSpacing: 0.4,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: PulseColors.textSecondary,
    letterSpacing: 0.6,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: PulseColors.textSecondary,
    letterSpacing: 0.8,
  );

  // ── Mono — for numbers, timers, scores, YAML ──────────────────────────────
  static TextStyle monoDisplay = GoogleFonts.jetBrainsMono(
    fontSize: 48,
    fontWeight: FontWeight.w300,
    color: PulseColors.textPrimary,
    letterSpacing: -1.0,
    height: 1.0,
  );

  static TextStyle monoLarge = GoogleFonts.jetBrainsMono(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: PulseColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle monoMedium = GoogleFonts.jetBrainsMono(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: PulseColors.textPrimary,
  );

  static TextStyle monoSmall = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: PulseColors.textSecondary,
  );

  static TextStyle monoCode = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: PulseColors.textPrimary,
    height: 1.6,
  );

  // ── Convenience: score badge number ───────────────────────────────────────
  static TextStyle scoreLarge = GoogleFonts.jetBrainsMono(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: PulseColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle scoreSmall = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: PulseColors.textPrimary,
  );
}
