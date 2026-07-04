import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Zone pill badge — used on project cards, node panels, detail header.
/// Spec §1.1 decay zone colours.
class ZoneBadge extends StatelessWidget {
  const ZoneBadge({required this.zone, super.key});
  final String zone;

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.zoneBg(zone);
    final fg = AppColors.zoneFg(zone);
    final label = zone.isEmpty ? 'active'
        : zone[0].toUpperCase() + zone.substring(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5, height: 5,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: fg,
            )),
        ],
      ),
    );
  }
}
