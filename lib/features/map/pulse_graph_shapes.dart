import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_graph_view/flutter_graph_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// Custom circular node: sized by weight, coloured by zone, score in mono text.
///
/// Extends [VertexCircleShape] so we inherit getPaint / width / height from the
/// package default.  We only override [render] to inject zone-aware colours and
/// the decay-score label.
class PulseVertexShape extends VertexCircleShape {
  PulseVertexShape() : super();

  @override
  void render(
      Vertex vertex, ui.Canvas canvas, ui.Paint paint, List<ui.Paint> paintLayers) {
    final data   = vertex.data as Map? ?? const {};
    final zone   = data['zone']   as String? ?? 'active';
    final weight = (data['weight'] as double? ?? 1.0).clamp(0.1, 5.0);
    final score  = data['score']  as double? ?? 0.0;
    final radius = (18.0 + weight * 6.0) / vertex.zoom.clamp(0.3, 3.0);

    // Glow ring for cold / critical zones
    if (zone == 'cold' || zone == 'critical') {
      canvas.drawCircle(
        Offset.zero,
        radius + 5,
        Paint()
          ..color = _fg(zone).withValues(alpha: 0.15)
          ..style = PaintingStyle.fill,
      );
    }

    // Zone fill
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = _bg(zone)
        ..style = PaintingStyle.fill,
    );

    // Zone border
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = _fg(zone).withValues(alpha: 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Decay score label
    final labelText = zone == 'idea' ? 'I' : score.toInt().toString();
    final tp = TextPainter(
      text: TextSpan(
        text: labelText,
        style: GoogleFonts.jetBrainsMono(
          fontSize: (radius * 0.55).clamp(9.0, 18.0),
          fontWeight: FontWeight.w700,
          color: _fg(zone),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
  }

  @override
  double width(Vertex vertex) {
    final weight = ((vertex.data as Map?)?['weight'] as double? ?? 1.0).clamp(0.1, 5.0);
    final radius = (18.0 + weight * 6.0) / vertex.zoom.clamp(0.3, 3.0);
    return radius * 2;
  }

  @override
  double height(Vertex vertex) => width(vertex);

  @override
  Paint getPaint(Vertex vertex) {
    // Solid fill — actual colours are drawn inside render(); just return a
    // transparent placeholder so the framework doesn't draw anything extra.
    return Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Color _bg(String z) => switch (z) {
        'active'   => AppColors.zoneActiveBg,
        'drifting' => AppColors.zoneDriftingBg,
        'cold'     => AppColors.zoneColdBg,
        'critical' => AppColors.zoneCriticalBg,
        'idea'     => const Color(0xFF0F0F15),
        _          => AppColors.surface2,
      };

  Color _fg(String z) => switch (z) {
        'active'   => AppColors.zoneActiveFg,
        'drifting' => AppColors.zoneDriftingFg,
        'cold'     => AppColors.zoneColdFg,
        'critical' => AppColors.zoneCriticalFg,
        'idea'     => AppColors.gold,
        _          => AppColors.textSecondary,
      };
}

/// Custom edge shape: typed lines with arrows / dashes per relation type.
///
/// Extends [EdgeLineShape] so we inherit render loop, hit-testing, etc.
/// We override only [getPaint] and [render] for the custom styling.
class PulseEdgeShape extends EdgeLineShape {
  PulseEdgeShape() : super();

  @override
  Paint getPaint(Edge edge) {
    final type = edge.edgeName ?? 'related_to';
    return Paint()
      ..color = switch (type) {
        'blocks'      => AppColors.zoneCriticalFg.withValues(alpha: 0.7),
        'depends_on'  => AppColors.textSecondary.withValues(alpha: 0.6),
        'inspired_by' => AppColors.gold.withValues(alpha: 0.55),
        'part_of'     => AppColors.textMuted.withValues(alpha: 0.45),
        _             => AppColors.borderStrong,
      }
      ..strokeWidth = switch (type) {
        'blocks'     => 1.8,
        'depends_on' => 1.4,
        _            => 1.0,
      } / (edge.g?.zoom ?? 1.0)
      ..style = PaintingStyle.stroke;
  }

  @override
  void render(Edge edge, ui.Canvas canvas, ui.Paint paint, List<ui.Paint> paintLayers) {
    if (edge.isLoop) {
      // Loop edges fall back to the default circle rendering
      super.render(edge, canvas, paint, paintLayers);
      return;
    }

    final type   = edge.edgeName ?? 'related_to';
    final length = len(edge);
    final end    = Offset(length.clamp(1.0, double.infinity), 0);

    switch (type) {
      case 'inspired_by':
      case 'part_of':
        _drawDashed(canvas, Offset.zero, end, paint);
      default:
        canvas.drawLine(Offset.zero, end, paint);
    }

    // Arrow for directional relations
    if (type == 'blocks' || type == 'depends_on' || type == 'inspired_by') {
      _drawArrow(canvas, Offset.zero, end, paint);
    }

    // Save path for hit-testing
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(end.dx, end.dy);
    edge.path = path;
  }

  // ── Private draw helpers ──────────────────────────────────────────────────

  void _drawArrow(ui.Canvas canvas, Offset s, Offset e, ui.Paint p) {
    const sz  = 8.0;
    const ang = 0.4; // radians
    final dx  = e.dx - s.dx;
    final dy  = e.dy - s.dy;
    final angle = atan2(dy, dx);
    final p1 = e.translate(-sz * cos(angle - ang), -sz * sin(angle - ang));
    final p2 = e.translate(-sz * cos(angle + ang), -sz * sin(angle + ang));
    canvas.drawPath(
      Path()
        ..moveTo(e.dx, e.dy)
        ..lineTo(p1.dx, p1.dy)
        ..moveTo(e.dx, e.dy)
        ..lineTo(p2.dx, p2.dy),
      p,
    );
  }

  void _drawDashed(ui.Canvas canvas, Offset s, Offset e, ui.Paint p) {
    const dashLen = 6.0, gap = 4.0;
    final total = (e - s).distance;
    if (total == 0) return;
    final dir = (e - s) / total;
    double d = 0;
    while (d < total) {
      final a = s + dir * d;
      final b = s + dir * min(d + dashLen, total);
      canvas.drawLine(a, b, p);
      d += dashLen + gap;
    }
  }
}
