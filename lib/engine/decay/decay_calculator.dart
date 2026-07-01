/// Pure Dart decay calculator — zero Flutter or Drift imports.
/// Testable without a widget tree or database.
/// Spec §4: dead-time-aware formula with weight factor.
library;

/// A dead-time period (from §4.1) — plain Dart, no Drift dependencies.
class DeadPeriod {
  const DeadPeriod({required this.fromDate, required this.toDate});
  final DateTime fromDate;
  final DateTime toDate;
}

/// Inputs to the decay formula.
class DecayInput {
  const DecayInput({
    required this.lastSessionAt,
    required this.projectCreatedAt,
    required this.avgGapDays,
    required this.weight,
    this.deadPeriods = const [],
  });

  /// When the last session ended. Null if no sessions yet.
  final DateTime? lastSessionAt;

  /// Project creation date (fallback when no sessions).
  final DateTime projectCreatedAt;

  /// Rolling EMA gap between sessions. Seeded at 3.0.
  final double avgGapDays;

  /// User-set urgency weight (0.1–5.0). Default 1.0.
  final double weight;

  /// Dead-time periods logged against this project.
  final List<DeadPeriod> deadPeriods;
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
  // ── Zone thresholds ────────────────────────────────────────────────────────
  static const double _thresholdDrifting = 30.0;
  static const double _thresholdCold     = 55.0;
  static const double _thresholdCritical = 80.0;

  /// Compute effective days since last session, subtracting dead time (§4.1).
  static double effectiveDaysSince(
    DateTime? lastSession,
    DateTime projectCreatedAt,
    List<DeadPeriod> deadPeriods,
  ) {
    final now = DateTime.now();
    final since = lastSession ?? projectCreatedAt;
    double total = now.difference(since).inMinutes / 1440.0;

    for (final dt in deadPeriods) {
      final overlapStart = dt.fromDate.isAfter(since) ? dt.fromDate : since;
      final overlapEnd   = dt.toDate.isBefore(now) ? dt.toDate : now;
      if (overlapEnd.isAfter(overlapStart)) {
        total -= overlapEnd.difference(overlapStart).inMinutes / 1440.0;
      }
    }
    return total.clamp(0.0, double.infinity);
  }

  /// Normalise weight (0.1–5.0) to a 0.6–1.5 multiplier (§4.2).
  static double weightFactor(double weight) => 0.6 + (weight / 5.0) * 0.9;

  /// Full decay formula (§4.3):
  ///   recencyFactor    = daysSinceLast / 14
  ///   cadenceDeviation = daysSinceLast / avgGapDays
  ///   wf               = weightFactor(weight)
  ///   score            = clamp(recencyFactor*35 + cadenceDeviation*45 + wf*20, 0, 100)
  static DecayResult compute(DecayInput input) {
    final days      = effectiveDaysSince(
      input.lastSessionAt,
      input.projectCreatedAt,
      input.deadPeriods,
    );
    final safeAvg   = input.avgGapDays.clamp(0.5, double.infinity);
    final wf        = weightFactor(input.weight.clamp(0.1, 5.0));

    final recency   = days / 14.0;
    final cadence   = days / safeAvg;

    final raw   = (recency * 35) + (cadence * 45) + (wf * 20);
    final score = raw.clamp(0.0, 100.0);

    return DecayResult(score: score, zone: zoneFor(score));
  }

  /// EMA update after each session (§4.4):
  ///   avgGap = (current * 0.7) + (newGap * 0.3)
  static double updateAvgGap(double currentAvg, double newGapDays) {
    return (currentAvg * 0.7) + (newGapDays * 0.3);
  }

  /// Map score → zone label.
  static String zoneFor(double score) {
    if (score >= _thresholdCritical) return 'critical';
    if (score >= _thresholdCold)     return 'cold';
    if (score >= _thresholdDrifting) return 'drifting';
    return 'active';
  }
}
