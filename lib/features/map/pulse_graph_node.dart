import 'package:flutter/material.dart';

/// Pulse graph node model — mirrors Nexus GraphNode adapted for project data.
class PulseGraphNode {
  final String id;
  final String label;
  final String zone;   // active|drifting|cold|critical|idea
  final double score;
  final double weight;
  final String type;   // project|idea
  final bool isConnected; // has at least one relation

  // Physics state
  Offset position;
  Offset velocity;
  Offset force;
  bool isPinned;
  bool isHovered;
  bool isDimmed;

  PulseGraphNode({
    required this.id,
    required this.label,
    required this.zone,
    this.score = 0,
    this.weight = 1.0,
    this.type = 'project',
    this.isConnected = true,
    this.position = Offset.zero,
    this.velocity = Offset.zero,
    this.force = Offset.zero,
    this.isPinned = false,
    this.isHovered = false,
    this.isDimmed = false,
  });

  double get baseRadius {
    if (type == 'idea') return 10.0;
    return 12.0 + (weight.clamp(0.1, 5.0) * 2.5).clamp(0, 16);
  }

  double finalRadius = 14.0;

  Color get zoneColor {
    switch (zone) {
      case 'critical': return const Color(0xFFC93030);
      case 'cold':     return const Color(0xFFC9601D);
      case 'drifting': return const Color(0xFFC9911D);
      case 'idea':     return const Color(0xFFC9A84C);
      default:         return const Color(0xFF1DB87B); // active
    }
  }
}
