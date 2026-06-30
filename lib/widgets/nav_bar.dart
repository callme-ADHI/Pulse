import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../providers.dart';
import '../features/capture/quick_capture_modal.dart';

/// The bottom navigation shell — §7.10
/// Center Capture button breaks the bar's top edge.
/// Active tab: filled icon + label. Inactive: outline icon only.
class PulseShell extends ConsumerWidget {
  const PulseShell({super.key, required this.child});
  final Widget child;

  static const _tabs = [
    _NavTab(
      label: 'Home',
      route: '/home',
      selectedIcon: Icons.home_rounded,
      unselectedIcon: Icons.home_outlined,
    ),
    _NavTab(
      label: 'Inbox',
      route: '/inbox',
      selectedIcon: Icons.inbox_rounded,
      unselectedIcon: Icons.inbox_outlined,
    ),
    _NavTab(
      label: 'Settings',
      route: '/settings',
      selectedIcon: Icons.settings_rounded,
      unselectedIcon: Icons.settings_outlined,
    ),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/inbox')) return 1;
    if (location.startsWith('/settings')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = _currentIndex(context);
    final activeSession = ref.watch(activeSessionProvider).valueOrNull;

    return Scaffold(
      body: child,
      extendBody: true,
      floatingActionButton: _CaptureButton(hasActiveSession: activeSession != null),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _PulseNavBar(
        currentIndex: currentIndex,
        tabs: _tabs,
      ),
    );
  }
}

class _PulseNavBar extends StatelessWidget {
  const _PulseNavBar({
    required this.currentIndex,
    required this.tabs,
  });

  final int currentIndex;
  final List<_NavTab> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: PulseColors.surface,
        border: Border(
          top: BorderSide(color: PulseColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              // Left side tabs (Home, Inbox)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTab(context, 0, tabs[0]),
                    _buildTab(context, 1, tabs[1]),
                  ],
                ),
              ),
              // Space for the floating capture button
              const SizedBox(width: 80),
              // Right side tab (Settings)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTab(context, 2, tabs[2]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index, _NavTab tab) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => context.go(tab.route),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? tab.selectedIcon : tab.unselectedIcon,
              color: isSelected ? PulseColors.accent : PulseColors.textTertiary,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(height: 3),
              Text(
                tab.label,
                style: PulseTypography.labelSmall.copyWith(
                  color: PulseColors.accent,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.hasActiveSession});
  final bool hasActiveSession;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openCapture(context),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: PulseColors.accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: PulseColors.accent.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: PulseColors.textPrimary,
          size: 28,
        ),
      ),
    );
  }

  void _openCapture(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickCaptureModal(),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.label,
    required this.route,
    required this.selectedIcon,
    required this.unselectedIcon,
  });

  final String label;
  final String route;
  final IconData selectedIcon;
  final IconData unselectedIcon;
}
