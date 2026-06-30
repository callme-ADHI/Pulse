import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/engine/decay/decay_calculator.dart';

void main() {
  group('DecayCalculator — formula correctness', () {
    // §6.2 formula verification

    test('score is 0 when project was just touched (day 0)', () {
      final result = DecayCalculator.compute(DecayInput(
        daysSinceLastSession: 0,
        avgGapDays: 3.0,
        priority: 'medium',
      ));
      expect(result.score, closeTo(20.0, 0.1));
      expect(result.zone, 'active');
    });

    test('high priority decays faster than low priority at same cadence', () {
      final high = DecayCalculator.compute(DecayInput(
        daysSinceLastSession: 2,
        avgGapDays: 3.0,
        priority: 'high',
      ));
      final low = DecayCalculator.compute(DecayInput(
        daysSinceLastSession: 2,
        avgGapDays: 3.0,
        priority: 'low',
      ));
      expect(high.score, greaterThan(low.score));
    });

    test('score is clamped at 100 for very stale project', () {
      final result = DecayCalculator.compute(DecayInput(
        daysSinceLastSession: 100,
        avgGapDays: 1.0,
        priority: 'high',
      ));
      expect(result.score, equals(100.0));
      expect(result.zone, 'critical');
    });

    test('cadence-respecting project stays healthier than flat-day project', () {
      // Project A: 10 days since session, but avg gap is 12 days (on schedule)
      final onSchedule = DecayCalculator.compute(DecayInput(
        daysSinceLastSession: 10,
        avgGapDays: 12.0,
        priority: 'medium',
      ));
      // Project B: 10 days since session, avg gap is 2 days (very behind)
      final behind = DecayCalculator.compute(DecayInput(
        daysSinceLastSession: 10,
        avgGapDays: 2.0,
        priority: 'medium',
      ));
      expect(onSchedule.score, lessThan(behind.score));
    });

    group('Zone thresholds', () {
      test('score < 30 → active', () {
        expect(DecayCalculator.zoneFor(0), 'active');
        expect(DecayCalculator.zoneFor(29.9), 'active');
      });

      test('30 ≤ score < 55 → drifting', () {
        expect(DecayCalculator.zoneFor(30), 'drifting');
        expect(DecayCalculator.zoneFor(54.9), 'drifting');
      });

      test('55 ≤ score < 80 → cold', () {
        expect(DecayCalculator.zoneFor(55), 'cold');
        expect(DecayCalculator.zoneFor(79.9), 'cold');
      });

      test('score ≥ 80 → critical', () {
        expect(DecayCalculator.zoneFor(80), 'critical');
        expect(DecayCalculator.zoneFor(100), 'critical');
      });
    });

    group('EMA gap update — §6.3', () {
      test('EMA update moves toward new gap', () {
        final newAvg = DecayCalculator.updateAvgGap(3.0, 7.0);
        expect(newAvg, closeTo(3.0 * 0.7 + 7.0 * 0.3, 0.001));
        expect(newAvg, closeTo(4.2, 0.001));
      });

      test('EMA weight: old value dominates (0.7)', () {
        final newAvg = DecayCalculator.updateAvgGap(10.0, 1.0);
        expect(newAvg, closeTo(7.3, 0.001));
      });
    });

    group('Priority weights', () {
      test('high priority adds most urgency', () {
        final score = DecayCalculator.compute(DecayInput(
          daysSinceLastSession: 14,
          avgGapDays: 14.0,
          priority: 'high',
        ));
        // At exactly avgGapDays cadence: recency=1.0*35=35, cadence=1.0*45=45, priority=1.5*20=30 → 110 → clamped 100
        expect(score.score, equals(100.0));
      });

      test('low priority score with same cadence miss', () {
        final score = DecayCalculator.compute(DecayInput(
          daysSinceLastSession: 14,
          avgGapDays: 14.0,
          priority: 'low',
        ));
        // recency=35, cadence=45, priority=0.6*20=12 → 92 → clamped 92
        expect(score.score, closeTo(92.0, 0.5));
        expect(score.zone, 'critical');
      });
    });
  });
}
