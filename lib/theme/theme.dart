import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';

/// The full AEVORAX dark theme for Pulse.
/// Pitch Black Luxury styling.
ThemeData buildPulseTheme() {
  const scheme = ColorScheme.dark(
    surface: PulseColors.surface,
    primary: PulseColors.accent,
    primaryContainer: PulseColors.accentDim,
    secondary: PulseColors.textSecondary,
    error: PulseColors.zoneCritical,
    onSurface: PulseColors.textPrimary,
    onPrimary: Colors.black,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: PulseColors.background,
    // ── AppBar ──────────────────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: PulseColors.background,
      foregroundColor: PulseColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      titleTextStyle: PulseTypography.titleLarge,
      centerTitle: false,
    ),
    // ── Card (Surface L1, border default, 14px radius, no shadow) ───────────
    cardTheme: CardThemeData(
      color: PulseColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: PulseColors.border, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    // ── Divider ─────────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: PulseColors.border,
      thickness: 1,
      space: 1,
    ),
    // ── Input (Surface L2, border default, 8px radius) ──────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: PulseColors.surfaceElevated,
      hintStyle: PulseTypography.bodyMedium.copyWith(
        color: PulseColors.textMuted,
      ),
      labelStyle: PulseTypography.labelLarge,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: PulseColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: PulseColors.borderStrong, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: PulseColors.zoneCritical),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: PulseColors.zoneCritical, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    // ── Text Button ─────────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: PulseColors.textPrimary,
        textStyle: PulseTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    // ── Elevated Button (Primary: White fill, Black text, 8px radius) ───────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        textStyle: PulseTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    // ── Outlined Button (Ghost: transparent fill, white text, 1px solid #222222) ─
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: PulseColors.textPrimary,
        side: const BorderSide(color: Color(0xFF222222), width: 1),
        textStyle: PulseTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    // ── BottomSheet (Surface L2, 14px top radius) ───────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: PulseColors.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
    ),
    // ── SnackBar ─────────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: PulseColors.surfaceOverlay,
      contentTextStyle: PulseTypography.bodyMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),
    // ── Chip ─────────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: PulseColors.surfaceElevated,
      labelStyle: PulseTypography.labelMedium,
      side: const BorderSide(color: PulseColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    // ── ListTile ─────────────────────────────────────────────────────────────
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      textColor: PulseColors.textPrimary,
      iconColor: PulseColors.textSecondary,
      tileColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    // ── Icon ─────────────────────────────────────────────────────────────────
    iconTheme: const IconThemeData(
      color: PulseColors.textSecondary,
      size: 22,
    ),
    // ── Switch ───────────────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? PulseColors.accent
            : PulseColors.textMuted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? PulseColors.accentDim.withValues(alpha: 0.5)
            : PulseColors.surface,
      ),
    ),
    // ── Dialog ───────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: PulseColors.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    // ── Scrollbar ────────────────────────────────────────────────────────────
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(PulseColors.border),
    ),
  );
}
