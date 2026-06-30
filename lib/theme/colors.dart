import 'package:flutter/material.dart';

/// AEVORAX house-style palette: Pitch Black Luxury.
/// True pitch black, elegant gold accent, and muted zone indicators.
abstract final class PulseColors {
  // ── Base ──────────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF0A0A0A);        // L1
  static const Color surfaceElevated = Color(0xFF111111); // L2
  static const Color surfaceOverlay = Color(0xFF1A1A1A);  // L3
  static const Color border = Color(0xFF1E1E1E);          // Border default
  static const Color borderStrong = Color(0xFF2A2A2A);    // Border strong

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color textMuted = Color(0xFF3A3A3A);
  static const Color textTertiary = textMuted;

  // ── Accent (Gold) ─────────────────────────────────────────────────────────
  static const Color accent = Color(0xFFC9A84C);          // Gold primary
  static const Color accentDim = Color(0xFFB89030);       // Gold pressed/hover

  // ── Zone text/dot colors ──────────────────────────────────────────────────
  static const Color zoneActive = Color(0xFF1DB87B);
  static const Color zoneDrifting = Color(0xFFC9911D);
  static const Color zoneCold = Color(0xFFC9601D);
  static const Color zoneCritical = Color(0xFFC93030);

  // ── Zone background pill fills ────────────────────────────────────────────
  static const Color zoneActiveBg = Color(0xFF0D2B1F);
  static const Color zoneDriftingBg = Color(0xFF2B2208);
  static const Color zoneColdBg = Color(0xFF2B1508);
  static const Color zoneCriticalBg = Color(0xFF2B0808);

  // ── Semantic aliases (for backward compat) ────────────────────────────────
  static const Color warning = zoneDrifting;  // amber — use sparingly
  static const Color error = zoneCritical;    // deep red

  // ── Graph edge colors ─────────────────────────────────────────────────────
  static const Color edgeDependsOn = Color(0xFF5A6A85);
  static const Color edgeBlocks = Color(0xFFC93030);
  static const Color edgeInspiredBy = Color(0xFFC9A84C);
  static const Color edgePartOf = Color(0xFF1DB87B);
  static const Color edgeRelatedTo = Color(0xFF3A3A3A);

  // ── Helpers ───────────────────────────────────────────────────────────────
  static Color forZone(String zone) {
    switch (zone) {
      case 'active':
        return zoneActive;
      case 'drifting':
        return zoneDrifting;
      case 'cold':
        return zoneCold;
      case 'critical':
        return zoneCritical;
      default:
        return textSecondary;
    }
  }

  static Color bgForZone(String zone) {
    switch (zone) {
      case 'active':
        return zoneActiveBg;
      case 'drifting':
        return zoneDriftingBg;
      case 'cold':
        return zoneColdBg;
      case 'critical':
        return zoneCriticalBg;
      default:
        return surface;
    }
  }

  static Color forRelationType(String type) {
    switch (type) {
      case 'depends_on':
        return edgeDependsOn;
      case 'blocks':
        return edgeBlocks;
      case 'inspired_by':
        return edgeInspiredBy;
      case 'part_of':
        return edgePartOf;
      case 'related_to':
        return edgeRelatedTo;
      default:
        return edgeRelatedTo;
    }
  }
}
