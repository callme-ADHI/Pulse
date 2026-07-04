import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/app_dimensions.dart';
import '../../db/database.dart';

/// Analytics section — spec §7
/// Time comparison, stop reason chart, session pattern.
class AnalyticsSection extends ConsumerWidget {
  const AnalyticsSection({super.key, required this.project});
  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(projectSessionsProvider(project.id));

    return sessionsAsync.when(
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
      data: (sessions) {
        final completed = sessions.where((s) => s.endedAt != null).toList();
        final totalSeconds = completed.fold<int>(0, (s, e) => s + (e.durationSeconds ?? 0));
        final estMin = project.estimatedMinutes;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TimeComparison(totalSeconds: totalSeconds, estimatedMinutes: estMin),
            const SizedBox(height: AppDim.pad20),
            if (completed.length >= 2) ...[
              _SessionPattern(sessions: completed),
              const SizedBox(height: AppDim.pad20),
            ],
            if (completed.any((s) => s.stopReason != null))
              _StopReasonChart(sessions: completed),
          ],
        );
      },
    );
  }
}

class _TimeComparison extends StatelessWidget {
  const _TimeComparison({required this.totalSeconds, required this.estimatedMinutes});
  final int totalSeconds;
  final int? estimatedMinutes;

  String _fmt(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m.toString().padLeft(2, '0')}m';
    return '${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final estMin = estimatedMinutes;
    final remSeconds = estMin != null ? (estMin * 60) - totalSeconds : null;
    final progress = estMin != null && estMin > 0
        ? (totalSeconds / (estMin * 60) * 100).clamp(0, 100)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MetricLine('Actual so far', _fmt(totalSeconds), AppColors.textPrimary),
        if (estMin != null) ...[
          _MetricLine('Estimated', _fmt(estMin * 60), AppColors.textSecondary),
          _MetricLine(
            'Remaining est.',
            remSeconds != null && remSeconds > 0 ? _fmt(remSeconds) : '—',
            AppColors.textSecondary,
          ),
          _MetricLine(
            'Progress',
            progress != null ? '${progress.toStringAsFixed(1)}%' : '—',
            AppColors.gold,
          ),
        ] else
          _MetricLine('Estimated', '—', AppColors.textMuted),
      ],
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine(this.label, this.value, this.valueColor);
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: AppText.body()),
          ),
          Text(value, style: AppText.monoMed().copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

class _SessionPattern extends StatelessWidget {
  const _SessionPattern({required this.sessions});
  final List<Session> sessions;

  @override
  Widget build(BuildContext context) {
    final totalSeconds = sessions.fold<int>(0, (s, e) => s + (e.durationSeconds ?? 0));
    final avgSession = totalSeconds ~/ sessions.length;

    // Compute avg gap from consecutive sessions
    double totalGap = 0;
    int gapCount = 0;
    for (var i = 1; i < sessions.length; i++) {
      final prev = sessions[i - 1].endedAt;
      if (prev != null) {
        totalGap += sessions[i].startedAt.difference(prev).inMinutes / 1440.0;
        gapCount++;
      }
    }
    final avgGap = gapCount > 0 ? totalGap / gapCount : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PATTERN', style: AppText.label()),
        const SizedBox(height: AppDim.pad8),
        _MetricLine('Sessions', '${sessions.length}', AppColors.textPrimary),
        _MetricLine('Avg session', _fmtSeconds(avgSession), AppColors.textPrimary),
        _MetricLine('Avg gap', '${avgGap.toStringAsFixed(1)} days', AppColors.textPrimary),
      ],
    );
  }

  String _fmtSeconds(int s) {
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }
}

class _StopReasonChart extends StatelessWidget {
  const _StopReasonChart({required this.sessions});
  final List<Session> sessions;

  static const _labels = {
    'completed_goal':     'Completed goal',
    'ran_out_of_time':    'Ran out of time',
    'got_blocked':        'Got blocked',
    'lost_focus':         'Lost focus',
    'external_interrupt': 'External interrupt',
    'other':              'Other',
  };

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final s in sessions) {
      if (s.stopReason != null) {
        counts[s.stopReason!] = (counts[s.stopReason!] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return const SizedBox();

    final total = counts.values.fold(0, (a, b) => a + b);
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('STOP REASONS', style: AppText.label()),
        const SizedBox(height: AppDim.pad12),
        ...sorted.map((e) {
          final pct = e.value / total;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 130,
                  child: Text(
                    _labels[e.key] ?? e.key,
                    style: AppText.body().copyWith(fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.surface3,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: pct,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDim.pad8),
                Text(
                  '${(pct * 100).toStringAsFixed(0)}%',
                  style: AppText.monoSmall().copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
