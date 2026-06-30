import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';

/// The full AEVORAX dark theme for Pulse.
/// Dark is the primary design target. Light mode is a Phase 5 secondary pass.
ThemeData buildPulseTheme() {
  const scheme = ColorScheme.dark(
    surface: PulseColors.surface,
    primary: PulseColors.accent,
    primaryContainer: PulseColors.accentDim,
    secondary: PulseColors.textSecondary,
    error: PulseColors.error,
    onSurface: PulseColors.textPrimary,
    onPrimary: PulseColors.textPrimary,
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
    // ── Card ────────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: PulseColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
    // ── Input ───────────────────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: PulseColors.surfaceElevated,
      hintStyle: PulseTypography.bodyMedium.copyWith(
        color: PulseColors.textTertiary,
      ),
      labelStyle: PulseTypography.labelLarge,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: PulseColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: PulseColors.accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: PulseColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: PulseColors.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    // ── Text Button ─────────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: PulseColors.accent,
        textStyle: PulseTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    // ── Elevated Button ──────────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: PulseColors.accent,
        foregroundColor: PulseColors.textPrimary,
        textStyle: PulseTypography.titleSmall,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    // ── Outlined Button ──────────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: PulseColors.textPrimary,
        side: const BorderSide(color: PulseColors.border),
        textStyle: PulseTypography.bodyMedium,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    // ── BottomSheet ──────────────────────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: PulseColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    // ── SnackBar ─────────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: PulseColors.surfaceElevated,
      contentTextStyle: PulseTypography.bodyMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
    ),
    // ── Chip ─────────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: PulseColors.surfaceElevated,
      labelStyle: PulseTypography.labelMedium,
      side: const BorderSide(color: PulseColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    // ── ListTile ─────────────────────────────────────────────────────────────
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      textColor: PulseColors.textPrimary,
      iconColor: PulseColors.textSecondary,
      tileColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            : PulseColors.textTertiary,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? PulseColors.accentDim
            : PulseColors.surface,
      ),
    ),
    // ── Dialog ───────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: PulseColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    // ── Bottom Nav ───────────────────────────────────────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: PulseColors.surface,
      indicatorColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? PulseTypography.labelMedium.copyWith(color: PulseColors.accent)
            : PulseTypography.labelMedium.copyWith(
                color: PulseColors.textTertiary,
              ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? const IconThemeData(color: PulseColors.accent, size: 22)
            : const IconThemeData(color: PulseColors.textTertiary, size: 22),
      ),
    ),
    // ── Scrollbar ────────────────────────────────────────────────────────────
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(PulseColors.border),
    ),
  );
}
