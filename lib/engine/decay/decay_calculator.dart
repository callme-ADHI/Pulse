/// Pure Dart decay calculator — zero Flutter or Drift imports.
/// This file is deliberately isolated so the formula in §6 can be
/// unit-tested without spinning up a widget tree or a database.
library;

/// Represents the inputs needed to compute a decay score.
class DecayInput {
  const DecayInput({
    required this.daysSinceLastSession,
    required this.avgGapDays,
    required this.priority,
  });

  /// Days since the last completed session (or since creation if no sessions).
  final double daysSinceLastSession;

  /// Rolling per-project average gap between sessions. Seeded at 3.0.
  final double avgGapDays;

  /// Project priority: 'low' | 'medium' | 'high'.
  final String priority;
}

/// The result of a decay computation.
class DecayResult {
  const DecayResult({required this.score, required this.zone});

  /// Clamped 0–100. Higher = more decayed.
  final double score;

  /// 'active' | 'drifting' | 'cold' | 'critical'
  final String zone;
}

abstract final class DecayCalculator {
  // ── Priority weights ───────────────────────────────────────────────────────
  static const double _weightHigh = 1.5;
  static const double _weightMedium = 1.0;
  static const double _weightLow = 0.6;

  // ── Score component weights ────────────────────────────────────────────────
  // cadenceDeviation is intentionally dominant: the project's own rhythm
  // matters more than a flat day count. Priority shifts urgency without
  // ever single-handedly forcing "critical" on day one.
  static const double _recencyWeight = 35.0;
  static const double _cadenceWeight = 45.0;
  static const double _priorityComponentMax = 20.0;

  // ── Zone thresholds ────────────────────────────────────────────────────────
  static const double _thresholdDrifting = 30.0;
  static const double _thresholdCold = 55.0;
  static const double _thresholdCritical = 80.0;

  /// Compute the decay score for a single project.
  ///
  /// Formula from §6.2:
  ///   recencyFactor    = daysSinceLastSession / 14
  ///   cadenceDeviation = daysSinceLastSession / avgGapDays
  ///   decayScore       = clamp(
  ///     (recencyFactor * 35) + (cadenceDeviation * 45) + (priorityWeight * 20),
  ///     0, 100
  ///   )
  static DecayResult compute(DecayInput input) {
    final safeAvgGap = input.avgGapDays.clamp(0.5, double.infinity);
    final safeDays = input.daysSinceLastSession.clamp(0.0, double.infinity);

    final recencyFactor = safeDays / 14.0;
    final cadenceDeviation = safeDays / safeAvgGap;
    final priorityWeight = _priorityWeightFor(input.priority);

    final raw = (recencyFactor * _recencyWeight) +
        (cadenceDeviation * _cadenceWeight) +
        (priorityWeight * _priorityComponentMax);

    final score = raw.clamp(0.0, 100.0);
    final zone = zoneFor(score);

    return DecayResult(score: score, zone: zone);
  }

  /// EMA update when a session completes.
  ///
  /// Formula from §6.3:
  ///   avgGapDays = (avgGapDays * 0.7) + (newGap * 0.3)
  static double updateAvgGap(double currentAvg, double newGapDays) {
    return (currentAvg * 0.7) + (newGapDays * 0.3);
  }

  /// Map a score to its zone string.
  static String zoneFor(double score) {
    if (score >= _thresholdCritical) return 'critical';
    if (score >= _thresholdCold) return 'cold';
    if (score >= _thresholdDrifting) return 'drifting';
    return 'active';
  }

  static double _priorityWeightFor(String priority) {
    switch (priority) {
      case 'high':
        return _weightHigh;
      case 'low':
        return _weightLow;
      case 'medium':
      default:
        return _weightMedium;
    }
  }
}
