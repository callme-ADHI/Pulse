import 'package:flutter/material.dart';

/// AEVORAX Pulse — canonical colour system (spec §1.1)
/// All new code uses AppColors. Legacy code uses PulseColors aliases below.
abstract final class AppColors {
  // ── Surfaces ──────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF000000);
  static const Color surface1   = Color(0xFF0A0A0A); // cards
  static const Color surface2   = Color(0xFF111111); // modals, sheets
  static const Color surface3   = Color(0xFF1A1A1A); // elevated overlays

  // ── Borders ───────────────────────────────────────────────────────────────
  static const Color borderDefault = Color(0xFF1E1E1E);
  static const Color borderStrong  = Color(0xFF2A2A2A);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color textMuted     = Color(0xFF3A3A3A);

  // ── Accent — use sparingly ─────────────────────────────────────────────────
  static const Color gold     = Color(0xFFC9A84C); // active nav, FAB, confirm, AEVORAX mark
  static const Color goldDeep = Color(0xFFB89030); // hover/pressed gold

  // ── Decay zone pill pairs ─────────────────────────────────────────────────
  static const Color zoneActiveBg   = Color(0xFF0D2B1F);
  static const Color zoneActiveFg   = Color(0xFF1DB87B);
  static const Color zoneDriftingBg = Color(0xFF2B2208);
  static const Color zoneDriftingFg = Color(0xFFC9911D);
  static const Color zoneColdBg     = Color(0xFF2B1508);
  static const Color zoneColdFg     = Color(0xFFC9601D);
  static const Color zoneCriticalBg = Color(0xFF2B0808);
  static const Color zoneCriticalFg = Color(0xFFC93030);

  // ── Project status colours (lifecycle — not zones) ────────────────────────
  static const Color statusActive    = Color(0xFF1DB87B);
  static const Color statusPaused    = Color(0xFFC9911D);
  static const Color statusCompleted = Color(0xFF6666CC);
  static const Color statusArchived  = Color(0xFF3A3A3A);

  // ── Helpers ───────────────────────────────────────────────────────────────
  static Color zoneFg(String zone) => switch (zone) {
    'active'   => zoneActiveFg,
    'drifting' => zoneDriftingFg,
    'cold'     => zoneColdFg,
    'critical' => zoneCriticalFg,
    _          => textSecondary,
  };

  static Color zoneBg(String zone) => switch (zone) {
    'active'   => zoneActiveBg,
    'drifting' => zoneDriftingBg,
    'cold'     => zoneColdBg,
    'critical' => zoneCriticalBg,
    _          => surface1,
  };

  static Color statusColor(String status) => switch (status) {
    'active'    => statusActive,
    'paused'    => statusPaused,
    'completed' => statusCompleted,
    'archived'  => statusArchived,
    'dropped'   => zoneCriticalFg,
    _           => textMuted,
  };

  static Color edgeColor(String type) => switch (type) {
    'depends_on'  => const Color(0xFF5A6A85),
    'blocks'      => zoneCriticalFg,
    'inspired_by' => gold,
    'part_of'     => zoneActiveFg,
    'related_to'  => textMuted,
    _             => textMuted,
  };
}
