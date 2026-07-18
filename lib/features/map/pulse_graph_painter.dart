import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'pulse_graph_node.dart';
import 'pulse_graph_edge.dart';

/// Custom painter — renders edges then glows then nodes then labels.
class PulseGraphPainter extends CustomPainter {
  final List<PulseGraphNode> nodes;
  final List<PulseGraphEdge> edges;
  final Offset panOffset;
  final double zoomLevel;
  final double rotationAngle;

  const PulseGraphPainter({
    required this.nodes,
    required this.edges,
    required this.panOffset,
    required this.zoomLevel,
    required this.rotationAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(panOffset.dx, panOffset.dy);
    canvas.scale(zoomLevel);

    final nodeMap = {for (var n in nodes) n.id: n};

    _drawAllEdges(canvas, nodeMap);
    for (var n in nodes) _drawGlow(canvas, n);
    for (var n in nodes) _drawCore(canvas, n);
    for (var n in nodes) _drawLabel(canvas, n);

    canvas.restore();
  }

  // ── Edges ─────────────────────────────────────────────────────────────────

  void _drawAllEdges(Canvas canvas, Map<String, PulseGraphNode> nodeMap) {
    final dimmed = edges.where((e) => e.isDimmed).toList();
    final normal = edges.where((e) => !e.isDimmed && !e.isHighlighted).toList();
    final highlighted = edges.where((e) => e.isHighlighted).toList();

    for (var e in dimmed) _drawEdge(canvas, e, nodeMap, dimmed: true);
    for (var e in normal) _drawEdge(canvas, e, nodeMap);
    for (var e in highlighted) _drawEdge(canvas, e, nodeMap, highlighted: true);
  }

  void _drawEdge(Canvas canvas, PulseGraphEdge edge, Map<String, PulseGraphNode> nodeMap,
      {bool dimmed = false, bool highlighted = false}) {
    final src = nodeMap[edge.sourceId];
    final tgt = nodeMap[edge.targetId];
    if (src == null || tgt == null) return;

    final isProjProj = src.type == 'project' && tgt.type == 'project';
    final isIdeaProj  = (src.type == 'idea'    && tgt.type == 'project') ||
                        (src.type == 'project'  && tgt.type == 'idea');

    final Color color;
    if (isIdeaProj) {
      color = AppColors.gold; // gold dashed line for idea↔project links
    } else if (isProjProj) {
      color = src.zoneColor;  // zone-tinted solid/dashed for project↔project
    } else {
      color = const Color(0xFF8E8E93);
    }

    double alpha = isIdeaProj ? 0.65 : (isProjProj ? 0.55 : 0.35);
    if (dimmed)       alpha = 0.06;
    if (highlighted)  alpha = 0.90;

    double strokeW = highlighted
        ? (isProjProj ? 2.2 : (isIdeaProj ? 1.8 : 1.5))
        : (isProjProj ? 1.2 : (isIdeaProj ? 1.0 : 0.7));
    if (dimmed) strokeW = 0.5;

    final result = _buildPath(src, tgt);
    final path = result.path;
    final arrowDir = result.arrowDir;
    final arrowTip = result.arrowTip;

    if (highlighted) {
      canvas.drawPath(path, Paint()
        ..color = color.withValues(alpha: 0.20)
        ..strokeWidth = strokeW + 4
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
    }

    final p = Paint()
      ..color = color.withValues(alpha: alpha)
      ..strokeWidth = strokeW
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (!isProjProj || isIdeaProj || edge.type == PulseEdgeType.relatedTo || edge.type == PulseEdgeType.inspiredBy) {
      _drawDashed(canvas, path, p);
    } else {
      canvas.drawPath(path, p);
    }

    if (edge.type != PulseEdgeType.relatedTo) {
      _drawArrow(canvas, arrowTip, arrowDir, color.withValues(alpha: alpha), highlighted ? 9.0 : 6.5);
    }
  }

  ({Path path, Offset arrowDir, Offset arrowTip}) _buildPath(PulseGraphNode src, PulseGraphNode tgt) {
    final p0 = src.position, p1 = tgt.position;
    final delta = p1 - p0;
    final dist = delta.distance;
    if (dist < 1) return (path: Path(), arrowDir: const Offset(1, 0), arrowTip: p1);

    final dir = delta / dist;
    final startPt = p0 + dir * (src.finalRadius + 2);
    final endPt   = p1 - dir * (tgt.finalRadius + 2);

    bool needsCurve = false;
    for (var node in nodes) {
      if (node.id == src.id || node.id == tgt.id) continue;
      if (_distToSeg(node.position, startPt, endPt) < node.finalRadius + 5) {
        needsCurve = true;
        break;
      }
    }

    if (!needsCurve) {
      return (
        path: Path()..moveTo(startPt.dx, startPt.dy)..lineTo(endPt.dx, endPt.dy),
        arrowDir: dir,
        arrowTip: endPt,
      );
    }

    final perp = Offset(-dir.dy, dir.dx);
    final mid  = (startPt + endPt) / 2;
    final ctrl = mid + perp * (dist * 0.20);
    final path = Path()..moveTo(startPt.dx, startPt.dy)..quadraticBezierTo(ctrl.dx, ctrl.dy, endPt.dx, endPt.dy);
    final tangent = (endPt - ctrl);
    final adir = tangent / tangent.distance;
    return (path: path, arrowDir: adir, arrowTip: endPt);
  }

  static double _distToSeg(Offset p, Offset a, Offset b) {
    final ab = b - a, ap = p - a;
    final len2 = ab.dx * ab.dx + ab.dy * ab.dy;
    if (len2 == 0) return (p - a).distance;
    final t = ((ap.dx * ab.dx + ap.dy * ab.dy) / len2).clamp(0.0, 1.0);
    return (p - Offset(a.dx + ab.dx * t, a.dy + ab.dy * t)).distance;
  }

  void _drawArrow(Canvas canvas, Offset tip, Offset dir, Color color, double size) {
    final perp = Offset(-dir.dy, dir.dx);
    final base = tip - dir * size;
    canvas.drawPath(
      Path()..moveTo(tip.dx, tip.dy)..lineTo((base + perp * (size * 0.45)).dx, (base + perp * (size * 0.45)).dy)..lineTo((base - perp * (size * 0.45)).dx, (base - perp * (size * 0.45)).dy)..close(),
      Paint()..color = color..style = PaintingStyle.fill,
    );
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      double d = 0;
      bool drawing = true;
      while (d < metric.length) {
        final segLen = drawing ? 5.0 : 4.0;
        final end = math.min(d + segLen, metric.length);
        if (drawing) canvas.drawPath(metric.extractPath(d, end), paint);
        d = end;
        drawing = !drawing;
      }
    }
  }

  // ── Nodes ─────────────────────────────────────────────────────────────────

  void _drawGlow(Canvas canvas, PulseGraphNode node) {
    if (node.isDimmed) return;
    final color = node.zoneColor;
    final glowAlpha = node.isHovered ? 0.35 : 0.14;
    final radius = node.finalRadius * 2.8;
    canvas.drawCircle(node.position, radius, Paint()
      ..shader = RadialGradient(colors: [color.withValues(alpha: glowAlpha), color.withValues(alpha: 0)])
          .createShader(Rect.fromCircle(center: node.position, radius: radius)));
  }

  void _drawCore(Canvas canvas, PulseGraphNode node) {
    final color = node.zoneColor;
    final r = node.finalRadius;
    final dimAlpha = node.isDimmed ? 0.15 : 1.0;

    // Fill
    canvas.drawCircle(node.position, r, Paint()
      ..color = color.withValues(alpha: node.isDimmed ? 0.04 : 0.12)
      ..style = PaintingStyle.fill);

    // Border
    canvas.drawCircle(node.position, r, Paint()
      ..color = color.withValues(alpha: node.isDimmed ? 0.25 : 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = node.isHovered ? 2.2 : 1.5);

    // Rotating outer ring for projects
    if (node.type == 'project') {
      canvas.save();
      canvas.translate(node.position.dx, node.position.dy);
      canvas.rotate(rotationAngle);
      canvas.drawCircle(Offset.zero, r + 5, Paint()
        ..color = color.withValues(alpha: node.isDimmed ? 0.07 : 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8);
      final mp = Paint()..color = color.withValues(alpha: dimAlpha * 0.7)..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(r + 5, 0), 1.5, mp);
      canvas.drawCircle(Offset(-(r + 5), 0), 1.5, mp);
      canvas.restore();
    }

    // Idea diamond marker
    if (node.type == 'idea') {
      final path = Path()
        ..moveTo(node.position.dx, node.position.dy - r * 0.5)
        ..lineTo(node.position.dx + r * 0.35, node.position.dy)
        ..lineTo(node.position.dx, node.position.dy + r * 0.5)
        ..lineTo(node.position.dx - r * 0.35, node.position.dy)
        ..close();
      canvas.drawPath(path, Paint()
        ..color = color.withValues(alpha: dimAlpha * 0.5)
        ..style = PaintingStyle.fill);
    }
  }

  void _drawLabel(Canvas canvas, PulseGraphNode node) {
    final alpha = node.isHovered ? 1.0 : (node.isDimmed ? 0.20 : 0.78);
    final style = TextStyle(
      color: Colors.white.withValues(alpha: alpha),
      fontSize: node.type == 'project' ? 11.5 : 10.0,
      fontWeight: node.type == 'project' ? FontWeight.w600 : FontWeight.w400,
      fontFamily: 'Inter',
    );
    final tp = TextPainter(
      text: TextSpan(text: node.label, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: 120);

    final lx = node.position.dx - tp.width / 2;
    final ly = node.position.dy + node.finalRadius + 7;

    if (node.isHovered) {
      final bg = Rect.fromLTWH(lx - 6, ly - 3, tp.width + 12, tp.height + 6);
      canvas.drawRRect(RRect.fromRectAndRadius(bg, const Radius.circular(4)),
          Paint()..color = const Color(0xF0050505));
      canvas.drawRRect(RRect.fromRectAndRadius(bg, const Radius.circular(4)),
          Paint()..color = Colors.white.withValues(alpha: 0.08)..style = PaintingStyle.stroke..strokeWidth = 0.5);
    }
    tp.paint(canvas, Offset(lx, ly));
  }

  @override
  bool shouldRepaint(covariant PulseGraphPainter old) =>
      old.panOffset != panOffset || old.zoomLevel != zoomLevel ||
      old.rotationAngle != rotationAngle || old.nodes != nodes || old.edges != edges;
}
