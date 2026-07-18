import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/capture/quick_capture_modal.dart';

// ════════════════════════════════════════════════════════════════════════════
// PULSE SHELL — holds child + radial nav
// ════════════════════════════════════════════════════════════════════════════

class PulseShell extends ConsumerWidget {
  const PulseShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Page content
          Positioned.fill(child: child),
          // Radial nav overlay on top of everything
          const _RadialNavOverlay(),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// RADIAL NAV OVERLAY
// ════════════════════════════════════════════════════════════════════════════

const _kTriggerZoneHeight = 80.0;  // bottom zone that activates the hold
const _kHoldDelay = Duration(milliseconds: 140);
const _kNavRadius  = 160.0;
const _kArcDeg     = 160.0;

class _NavTarget {
  final IconData icon;
  final String label;
  final String route;
  const _NavTarget({required this.icon, required this.label, required this.route});
}

const _targets = [
  _NavTarget(icon: Icons.home_rounded,           label: 'HOME',     route: '/home'),
  _NavTarget(icon: Icons.dashboard_rounded,      label: 'PROJECTS', route: '/projects'),
  _NavTarget(icon: Icons.lightbulb_outline_rounded, label: 'IDEAS', route: '/ideas'),
  _NavTarget(icon: Icons.hub_rounded,            label: 'MAP',      route: '/map'),
  _NavTarget(icon: Icons.inbox_rounded,          label: 'INBOX',    route: '/inbox'),
  _NavTarget(icon: Icons.bar_chart_rounded,      label: 'REPORT',   route: '/weekly-report'),
  _NavTarget(icon: Icons.settings_rounded,       label: 'SETTINGS', route: '/settings'),
];

class _RadialNavOverlay extends ConsumerStatefulWidget {
  const _RadialNavOverlay();
  @override
  ConsumerState<_RadialNavOverlay> createState() => _RadialNavOverlayState();
}

class _RadialNavOverlayState extends ConsumerState<_RadialNavOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  bool _active = false;
  Offset _center = Offset.zero;
  int _selectedIndex = -1;

  Offset? _initTouch;
  bool _timerActive = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _startTimer(Offset pos) {
    _initTouch = pos;
    _timerActive = true;
    Future.delayed(_kHoldDelay, () {
      if (_timerActive && _initTouch != null && !_active && mounted) {
        final size = MediaQuery.of(context).size;
        setState(() {
          _active = true;
          _center = Offset(size.width / 2, size.height - 40);
          _selectedIndex = -1;
        });
        _ctrl.forward();
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _cancelTimer() {
    _timerActive = false;
    _initTouch = null;
  }

  void _onPointerDown(PointerDownEvent e) {
    final size = MediaQuery.of(context).size;
    if (e.position.dy > size.height - _kTriggerZoneHeight) _startTimer(e.position);
  }

  void _onPointerMove(PointerMoveEvent e) {
    if (!_active) {
      if (_initTouch != null && (e.position - _initTouch!).distance > 20) _cancelTimer();
      return;
    }
    final delta = e.position - _center;
    final dist  = delta.distance;
    if (dist < 50) {
      if (_selectedIndex != -1) setState(() => _selectedIndex = -1);
      return;
    }

    double angle = math.atan2(delta.dy, delta.dx) * 180 / math.pi;
    angle = (angle + 360) % 360;
    const start = 270.0 - (_kArcDeg / 2);
    const end   = 270.0 + (_kArcDeg / 2);
    int newIdx = -1;
    if (angle >= start && angle <= end) {
      final rel = (angle - start) / _kArcDeg;
      newIdx = (rel * _targets.length).floor().clamp(0, _targets.length - 1);
    }
    if (newIdx != _selectedIndex) {
      setState(() => _selectedIndex = newIdx);
      HapticFeedback.selectionClick();
    }
  }

  void _onPointerUp(PointerUpEvent e) {
    _cancelTimer();
    if (!_active) return;

    if (_selectedIndex != -1) {
      context.go(_targets[_selectedIndex].route);
    }
    _ctrl.reverse().then((_) {
      if (mounted) setState(() { _active = false; _selectedIndex = -1; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // ── Capture FAB (always visible at bottom center) ───────────────
            Positioned(
              bottom: 28,
              left: 0, right: 0,
              child: Center(child: _CaptureButton()),
            ),

            // ── Radial overlay when active ──────────────────────────────────
            if (_active) ...[
              FadeTransition(
                opacity: _ctrl,
                child: GestureDetector(
                  onVerticalDragUpdate: (_) {},
                  child: Container(color: Colors.black.withValues(alpha: 0.78)),
                ),
              ),
              AnimatedBuilder(
                animation: _anim,
                builder: (_, __) {
                  return Stack(
                    children: List.generate(_targets.length, (i) {
                      const arcRad  = _kArcDeg * (math.pi / 180);
                      const startR  = (270.0 - _kArcDeg / 2) * (math.pi / 180);
                      final angle   = startR + (i + 0.5) * (arcRad / _targets.length);
                      final radius  = _kNavRadius * _anim.value;
                      final dx = radius * math.cos(angle);
                      final dy = radius * math.sin(angle);
                      return Positioned(
                        left: _center.dx + dx - 28,
                        top:  _center.dy + dy - 28,
                        child: _NavItem(
                          target: _targets[i],
                          isSelected: _selectedIndex == i,
                          expandValue: _anim.value,
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// NAV ITEM
// ════════════════════════════════════════════════════════════════════════════

class _NavItem extends StatelessWidget {
  final _NavTarget target;
  final bool isSelected;
  final double expandValue;

  const _NavItem({required this.target, required this.isSelected, required this.expandValue});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: isSelected ? 1.3 : 1.0,
      curve: Curves.easeOutBack,
      child: Opacity(
        opacity: expandValue * (isSelected ? 1.0 : 0.55),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48, height: 48,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Icon(target.icon,
                  color: Colors.white,
                  size: 22),
            ),
            const SizedBox(height: 5),
            if (isSelected)
              Text(target.label, style: const TextStyle(
                color: Colors.white,
                fontSize: 8, fontWeight: FontWeight.w800,
                letterSpacing: 1.2, fontFamily: 'Inter',
              )),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// CAPTURE FAB
// ════════════════════════════════════════════════════════════════════════════

class _CaptureButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
        builder: (_) => const QuickCaptureModal(),
      ),
      child: Container(
        width: 52, height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFC9A84C),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC9A84C).withValues(alpha: 0.25),
              blurRadius: 14,
              spreadRadius: 1,
            )
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.black, size: 26),
      ),
    );
  }
}
