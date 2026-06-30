import 'package:flutter/material.dart';

/// AEVORAX house-style palette.
/// Dark-first. Desaturated zone colors — instrument panel, not alarm system.
abstract final class PulseColors {
  // ── Base ──────────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0B0C0E);
  static const Color surface = Color(0xFF16181C);
  static const Color surfaceElevated = Color(0xFF1E2127);
  static const Color border = Color(0xFF2A2D34);
  static const Color borderSubtle = Color(0xFF1F2228);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFE8E9EB);
  static const Color textSecondary = Color(0xFF7A7D85);
  static const Color textTertiary = Color(0xFF4A4D55);
  static const Color textInverse = Color(0xFF0B0C0E);

  // ── Accent ────────────────────────────────────────────────────────────────
  static const Color accent = Color(0xFF3D8B8B);    // muted teal — primary CTA
  static const Color accentDim = Color(0xFF2A6060);

  // ── Zone colors (desaturated — calm, not alarming) ────────────────────────
  static const Color zoneActive = Color(0xFF3D8B8B);    // muted teal
  static const Color zoneDrifting = Color(0xFFC8940A);  // amber
  static const Color zoneCold = Color(0xFFC4622D);      // burnt orange
  static const Color zoneCritical = Color(0xFFB53B3B);  // deep red

  // ── Zone background tints (for badges, node fills) ────────────────────────
  static const Color zoneActiveBg = Color(0xFF0E2222);
  static const Color zoneDriftingBg = Color(0xFF241A00);
  static const Color zoneColdBg = Color(0xFF241200);
  static const Color zoneCriticalBg = Color(0xFF220A0A);

  // ── Status ────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF3A7D5A);
  static const Color warning = Color(0xFFC8940A);
  static const Color error = Color(0xFFB53B3B);
  static const Color info = Color(0xFF2F6B9A);

  // ── Graph edge colors ─────────────────────────────────────────────────────
  static const Color edgeDependsOn = Color(0xFF5A6A85);
  static const Color edgeBlocks = Color(0xFFB53B3B);
  static const Color edgeInspiredBy = Color(0xFF3D6B8B);
  static const Color edgePartOf = Color(0xFF5A7A5A);
  static const Color edgeRelatedTo = Color(0xFF4A4D55);

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
