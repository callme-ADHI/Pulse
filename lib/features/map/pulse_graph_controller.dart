import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pulse_graph_node.dart';
import 'pulse_graph_edge.dart';
import 'pulse_physics_engine.dart';

/// Graph controller — lifecycle, physics ticker, persistence.
class PulseGraphController extends ChangeNotifier {
  final List<PulseGraphNode> nodes = [];
  final List<PulseGraphEdge> edges = [];

  Offset panOffset = Offset.zero;
  double zoomLevel = 1.0;
  double rotationAngle = 0.0;
  bool isSimulationActive = false;

  Timer? _saveDebounce;
  Ticker? _ticker;
  late AnimationController _rotationCtrl;

  static const _posKey  = 'pulse_graph_positions_v1';
  static const _viewKey = 'pulse_graph_viewport_v1';

  PulseGraphController({required TickerProvider vsync}) {
    _ticker = vsync.createTicker(_onTick);
    _rotationCtrl = AnimationController(vsync: vsync, duration: const Duration(seconds: 10))..repeat();
    _rotationCtrl.addListener(() {
      rotationAngle = _rotationCtrl.value * 2 * math.pi;
      notifyListeners();
    });
  }

  // ── Persistence ────────────────────────────────────────────────────────────

  Future<Map<String, Offset>> loadPositions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_posKey);
      if (raw == null) return {};
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((id, val) {
        final c = val as Map<String, dynamic>;
        return MapEntry(id, Offset((c['x'] as num).toDouble(), (c['y'] as num).toDouble()));
      });
    } catch (_) { return {}; }
  }

  Future<void> savePositions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final map = {for (var n in nodes) n.id: {'x': n.position.dx, 'y': n.position.dy}};
      await prefs.setString(_posKey, jsonEncode(map));
    } catch (_) {}
  }

  Future<void> clearPositions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_posKey);
      await prefs.remove(_viewKey);
    } catch (_) {}
  }

  Future<void> saveViewport() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_viewKey, jsonEncode({'px': panOffset.dx, 'py': panOffset.dy, 'zoom': zoomLevel}));
    } catch (_) {}
  }

  Future<({Offset pan, double zoom})?> loadViewport() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_viewKey);
      if (raw == null) return null;
      final m = jsonDecode(raw) as Map<String, dynamic>;
      return (pan: Offset((m['px'] as num).toDouble(), (m['py'] as num).toDouble()), zoom: (m['zoom'] as num).toDouble());
    } catch (_) { return null; }
  }

  // ── Physics tick ───────────────────────────────────────────────────────────

  void _onTick(Duration _) {
    if (!isSimulationActive) return;
    PulsePhysicsEngine.applyForces(nodes: nodes, edges: edges, canvasSize: const Size(1200, 1200));
    double maxV = 0;
    for (var n in nodes) maxV = math.max(maxV, n.velocity.distance);
    if (maxV < 0.25) {
      stopSimulation();
      _scheduleSave();
    }
    notifyListeners();
  }

  void startSimulation() {
    isSimulationActive = true;
    if (!(_ticker?.isActive ?? false)) _ticker?.start();
    notifyListeners();
  }

  void stopSimulation() {
    isSimulationActive = false;
    _ticker?.stop();
    notifyListeners();
  }

  // ── Data sync ──────────────────────────────────────────────────────────────

  void updateData(
    List<PulseGraphNode> newNodes,
    List<PulseGraphEdge> newEdges, {
    required Map<String, Offset> savedPositions,
  }) {
    final inMemory = {for (var n in nodes) n.id: n.position};

    nodes.clear();
    nodes.addAll(newNodes);
    edges.clear();
    edges.addAll(newEdges);

    bool hasNewNodes = false;

    for (var n in nodes) {
      if (inMemory.containsKey(n.id)) {
        n.position = inMemory[n.id]!;
      } else if (savedPositions.containsKey(n.id)) {
        n.position = savedPositions[n.id]!;
      } else {
        // Brand new node: spawn near center of 1200x1200 canvas
        final rand = math.Random();
        n.position = Offset(
          600 + (rand.nextDouble() - 0.5) * 200,
          600 + (rand.nextDouble() - 0.5) * 200,
        );
        hasNewNodes = true;
      }
      // Update radius based on connections
      final conn = edges.where((e) => e.sourceId == n.id || e.targetId == n.id).length;
      n.finalRadius = n.baseRadius + math.min(conn * 1.5, 10.0);
    }

    if (hasNewNodes) {
      startSimulation();
    }

    notifyListeners();
  }

  // ── Node drag ──────────────────────────────────────────────────────────────

  void moveNode(PulseGraphNode node, Offset canvasPos) {
    node.position = canvasPos;
    node.velocity = Offset.zero;
    notifyListeners();
  }

  void onNodeDropped() => _scheduleSave();

  // ── Viewport ──────────────────────────────────────────────────────────────

  void pan(Offset delta) {
    panOffset += delta;
    notifyListeners();
    _scheduleViewportSave();
  }

  void zoomAt(double scaleDelta, Offset focalPoint) {
    final oldZoom = zoomLevel;
    zoomLevel = (zoomLevel * scaleDelta).clamp(0.1, 5.0);
    final focalCanvas = (focalPoint - panOffset) / oldZoom;
    panOffset = focalPoint - focalCanvas * zoomLevel;
    notifyListeners();
    _scheduleViewportSave();
  }

  void zoom(double factor, Size screenSize) {
    zoomAt(factor, Offset(screenSize.width / 2, screenSize.height / 2));
  }

  void fitAll(Size screenSize) {
    if (nodes.isEmpty) return;
    double minX = nodes.first.position.dx, maxX = minX;
    double minY = nodes.first.position.dy, maxY = minY;
    for (var n in nodes) {
      minX = math.min(minX, n.position.dx); maxX = math.max(maxX, n.position.dx);
      minY = math.min(minY, n.position.dy); maxY = math.max(maxY, n.position.dy);
    }
    final gW = maxX - minX + 240;
    final gH = maxY - minY + 240;
    zoomLevel = math.min(screenSize.width / gW, screenSize.height / gH).clamp(0.1, 5.0);
    panOffset = Offset(
      screenSize.width  / 2 - (minX + maxX) / 2 * zoomLevel,
      screenSize.height / 2 - (minY + maxY) / 2 * zoomLevel,
    );
    notifyListeners();
  }

  Future<void> reset(Size screenSize) async {
    stopSimulation();
    await clearPositions();
    PulsePhysicsEngine.initializePositions(nodes, const Size(1200, 1200));
    // Warm-up
    for (int i = 0; i < 120; i++) {
      PulsePhysicsEngine.applyForces(nodes: nodes, edges: edges, canvasSize: const Size(1200, 1200));
    }
    fitAll(screenSize);
    startSimulation();
  }

  // ── Hover ──────────────────────────────────────────────────────────────────

  void setHovered(PulseGraphNode? node) {
    for (var n in nodes) n.isHovered = (n.id == node?.id);
    notifyListeners();
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  void _scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 400), savePositions);
  }

  void _scheduleViewportSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 800), saveViewport);
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _ticker?.dispose();
    _rotationCtrl.dispose();
    super.dispose();
  }
}
