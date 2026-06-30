import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/database.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../providers.dart';

/// 30-day decay history line chart for Project Detail.
/// Uses fl_chart. Decay score is NOT shown as progress bar (§8) — it's
/// rendered as a number tick, and this chart shows the historical line.
class DecayChart extends ConsumerWidget {
  const DecayChart({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(decayLogsProvider(projectId));

    return logsAsync.when(
      loading: () => const SizedBox(
        height: 120,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: PulseColors.accent,
          ),
        ),
      ),
      error: (e, _) => SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'Chart unavailable',
            style: PulseTypography.bodySmall,
          ),
        ),
      ),
      data: (logs) {
        if (logs.isEmpty) {
          return SizedBox(
            height: 120,
            child: Center(
              child: Text(
                'No decay history yet',
                style: PulseTypography.bodySmall,
              ),
            ),
          );
        }
        return _Chart(logs: logs);
      },
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.logs});
  final List<DecayLog> logs;

  @override
  Widget build(BuildContext context) {
    final spots = logs.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.score);
    }).toList();

    // Color gradient based on current score
    final lineColor = PulseColors.forZone(logs.last.zone);

    return SizedBox(
      height: 120,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          clipData: const FlClipData.all(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (_) => const FlLine(
              color: PulseColors.border,
              strokeWidth: 0.5,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 25,
                reservedSize: 28,
                getTitlesWidget: (value, _) => Text(
                  value.toInt().toString(),
                  style: PulseTypography.monoSmall.copyWith(fontSize: 10),
                ),
              ),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          // Zone threshold reference lines
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 30,
                color: PulseColors.zoneDrifting.withOpacity(0.3),
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
              HorizontalLine(
                y: 55,
                color: PulseColors.zoneCold.withOpacity(0.3),
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
              HorizontalLine(
                y: 80,
                color: PulseColors.zoneCritical.withOpacity(0.3),
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
            ],
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: lineColor,
              barWidth: 2,
              dotData: FlDotData(
                show: spots.length <= 7,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 3,
                  color: lineColor,
                  strokeWidth: 0,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    lineColor.withOpacity(0.15),
                    lineColor.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => PulseColors.surfaceElevated,
              getTooltipItems: (spots) => spots.map((s) {
                return LineTooltipItem(
                  s.y.toStringAsFixed(1),
                  PulseTypography.monoSmall.copyWith(
                    color: lineColor,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
    );
  }
}
