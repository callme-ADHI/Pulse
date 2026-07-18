import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'pulse_graph_node.dart';
import 'pulse_graph_edge.dart';

/// Force-directed physics engine adapted from Nexus GraphPhysicsEngine.
class PulsePhysicsEngine {
  static const double repulsionStrength  = 7000.0;
  static const double attractionStrength = 200.0;
  static const double restLength         = 140.0;
  static const double gravityStrength    = 0.010;
  static const double damping            = 0.76;
  static const double maxSpeed           = 8.0;
  static const double margin             = 80.0;

  static void applyForces({
    required List<PulseGraphNode> nodes,
    required List<PulseGraphEdge> edges,
    required Size canvasSize,
  }) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);

    for (var node in nodes) node.force = Offset.zero;

    // Repulsion — all pairs
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final a = nodes[i];
        final b = nodes[j];
        final delta = a.position - b.position;
        final dist = delta.distance;
        if (dist > 500) continue;
        final safeDist = math.max(dist, 1.0);
        final strength = repulsionStrength * (a.weight + b.weight) * 0.5;
        final forceMag = strength / (safeDist * safeDist);
        final dir = delta / safeDist;
        a.force += dir * forceMag;
        b.force -= dir * forceMag;
      }
    }

    // Attraction — connected pairs
    final nodeMap = {for (var n in nodes) n.id: n};
    for (var edge in edges) {
      final a = nodeMap[edge.sourceId];
      final b = nodeMap[edge.targetId];
      if (a == null || b == null) continue;
      final delta = b.position - a.position;
      final dist = delta.distance;
      final rest = edge.type == PulseEdgeType.partOf ? 80.0 : restLength;
      if (dist > rest) {
        final forceMag = (dist - rest) / attractionStrength;
        final dir = delta / math.max(dist, 1.0);
        a.force += dir * forceMag;
        b.force -= dir * forceMag;
      }
    }

    // Center gravity + boundary
    for (var node in nodes) {
      final toCenter = center - node.position;
      node.force += toCenter * gravityStrength;

      if (node.position.dx < margin)
        node.force = Offset(node.force.dx + (margin - node.position.dx) * 0.5, node.force.dy);
      else if (node.position.dx > canvasSize.width - margin)
        node.force = Offset(node.force.dx - (node.position.dx - (canvasSize.width - margin)) * 0.5, node.force.dy);

      if (node.position.dy < margin)
        node.force = Offset(node.force.dx, node.force.dy + (margin - node.position.dy) * 0.5);
      else if (node.position.dy > canvasSize.height - margin)
        node.force = Offset(node.force.dx, node.force.dy - (node.position.dy - (canvasSize.height - margin)) * 0.5);
    }

    // Integrate
    for (var node in nodes) {
      if (node.isPinned) continue;
      node.velocity = (node.velocity + node.force) * damping;
      if (node.velocity.distance > maxSpeed) {
        node.velocity = node.velocity / node.velocity.distance * maxSpeed;
      }
      node.position += node.velocity;
    }
  }

  static void initializePositions(List<PulseGraphNode> nodes, Size canvasSize) {
    if (nodes.isEmpty) return;
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final baseRadius = math.min(canvasSize.width, canvasSize.height) * 0.32;
    final rand = math.Random();

    for (int i = 0; i < nodes.length; i++) {
      final angle = (i / nodes.length) * 2 * math.pi;
      final jx = (rand.nextDouble() - 0.5) * 50;
      final jy = (rand.nextDouble() - 0.5) * 50;
      nodes[i].position = center + Offset(math.cos(angle), math.sin(angle)) * baseRadius + Offset(jx, jy);
      nodes[i].velocity = Offset.zero;
    }
  }
}
