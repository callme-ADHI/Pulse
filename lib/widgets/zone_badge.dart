import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Zone badge — colored dot + label showing decay status.
class ZoneBadge extends StatelessWidget {
  const ZoneBadge({
    super.key,
    required this.zone,
    this.showLabel = true,
    this.size = 8.0,
  });

  final String zone;
  final bool showLabel;
  final double size;

  String get _label => switch (zone) {
        'active' => 'Active',
        'drifting' => 'Drifting',
        'cold' => 'Cold',
        'critical' => 'Critical',
        _ => zone,
      };

  @override
  Widget build(BuildContext context) {
    final color = PulseColors.forZone(zone);
    final bgColor = PulseColors.bgForZone(zone);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 5),
            Text(
              _label,
              style: PulseTypography.labelSmall.copyWith(
                color: color,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Just the colored dot, no container.
class ZoneDot extends StatelessWidget {
  const ZoneDot({super.key, required this.zone, this.size = 8.0});
  final String zone;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: PulseColors.forZone(zone),
        shape: BoxShape.circle,
      ),
    );
  }
}
