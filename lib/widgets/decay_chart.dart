import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../db/database.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../providers.dart';

/// 30-day decay history line chart for Project Detail.
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
            color: AppColors.gold,
          ),
        ),
      ),
      error: (e, _) => SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'Chart unavailable',
            style: AppText.body().copyWith(color: AppColors.textMuted),
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
                style: AppText.body().copyWith(color: AppColors.textMuted),
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

    final lineColor = AppColors.zoneFg(logs.last.zone);

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
              color: AppColors.borderDefault,
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
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
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
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 30,
                color: AppColors.zoneDriftingFg.withValues(alpha: 0.2),
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
              HorizontalLine(
                y: 55,
                color: AppColors.zoneColdFg.withValues(alpha: 0.2),
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
              HorizontalLine(
                y: 80,
                color: AppColors.zoneCriticalFg.withValues(alpha: 0.2),
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
                    lineColor.withValues(alpha: 0.15),
                    lineColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.surface3,
              getTooltipItems: (spots) => spots.map((s) {
                return LineTooltipItem(
                  s.y.toStringAsFixed(1),
                  GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
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
