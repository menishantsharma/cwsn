import 'package:cwsn/core/router/nav_config.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/notifications/presentation/providers/notification_provider.dart';
import 'package:cwsn/features/requests/presentation/providers/requests_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The root shell widget for tabbed navigation.
///
/// Reads the current user's role and delegates tab rendering
/// via [NavConfig]. No role-specific conditionals live here.
class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentUserProvider).value?.activeRole;
    final tabs = NavConfig.tabsForRole(role);
    final visibleIndex = NavConfig.visibleIndexForBranch(
      navigationShell.currentIndex,
      tabs,
    );
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: visibleIndex.clamp(0, tabs.length - 1),
          onDestinationSelected: (visibleIdx) {
            final branchIndex = NavConfig.branchIndexOf(tabs[visibleIdx]);
            navigationShell.goBranch(
              branchIndex,
              initialLocation: branchIndex == navigationShell.currentIndex,
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: primary.withValues(alpha: 0.1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations:
              tabs.map((tab) => _buildDestination(context, ref, tab)).toList(),
        ),
      ),
    );
  }

  NavigationDestination _buildDestination(
    BuildContext context,
    WidgetRef ref,
    NavItem tab,
  ) {
    final badgeCount = _badgeCountFor(ref, tab);

    Widget iconWidget(IconData iconData) {
      if (badgeCount > 0) {
        return Badge(
          label: Text(
            badgeCount > 99 ? '99+' : '$badgeCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Icon(iconData),
        );
      }
      return Icon(iconData);
    }

    return NavigationDestination(
      icon: iconWidget(tab.icon),
      selectedIcon: iconWidget(tab.activeIcon),
      label: tab.label,
    );
  }

  int _badgeCountFor(WidgetRef ref, NavItem tab) {
    if (identical(tab, NavConfig.notifications)) {
      return ref.watch(unreadNotificationCountProvider);
    }
    if (identical(tab, NavConfig.caregiverHome)) {
      return ref.watch(pendingRequestCountProvider);
    }
    return 0;
  }
}
