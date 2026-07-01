/// AEVORAX Pulse — spacing and shape constants (spec §1.3)
abstract final class AppDim {
  // ── Border radii ──────────────────────────────────────────────────────────
  static const double radiusCard  = 14.0;
  static const double radiusBtn   = 8.0;
  static const double radiusPill  = 100.0;
  static const double radiusInput = 10.0;

  // ── Spacing units (multiples of 4) ───────────────────────────────────────
  static const double pad4  = 4.0;
  static const double pad8  = 8.0;
  static const double pad12 = 12.0;
  static const double pad16 = 16.0;
  static const double pad20 = 20.0;
  static const double pad24 = 24.0;
  static const double pad28 = 28.0;

  // ── Component sizes ───────────────────────────────────────────────────────
  static const double fabSize     = 52.0;
  static const double fabRise     = 20.0; // how far FAB breaks above nav bar
  static const double navBarH     = 60.0;
  static const double cardPad     = 18.0;
}
