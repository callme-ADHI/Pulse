/// Pulse graph edge model.
enum PulseEdgeType { dependsOn, blocks, inspiredBy, partOf, relatedTo }

extension PulseEdgeTypeX on PulseEdgeType {
  static PulseEdgeType fromString(String s) {
    switch (s) {
      case 'depends_on':  return PulseEdgeType.dependsOn;
      case 'blocks':      return PulseEdgeType.blocks;
      case 'inspired_by': return PulseEdgeType.inspiredBy;
      case 'part_of':     return PulseEdgeType.partOf;
      default:            return PulseEdgeType.relatedTo;
    }
  }
}

class PulseGraphEdge {
  final String sourceId;
  final String targetId;
  final PulseEdgeType type;
  bool isHighlighted;
  bool isDimmed;

  PulseGraphEdge({
    required this.sourceId,
    required this.targetId,
    required this.type,
    this.isHighlighted = false,
    this.isDimmed = false,
  });
}
