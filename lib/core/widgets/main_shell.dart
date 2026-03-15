import 'package:cwsn/core/router/nav_config.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/notifications/presentation/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final unreadCount = ref.watch(unreadCountProvider);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: visibleIndex.clamp(0, tabs.length - 1),
        onDestinationSelected: (visibleIdx) {
          final branchIndex = NavConfig.branchIndexOf(tabs[visibleIdx]);
          navigationShell.goBranch(
            branchIndex,
            initialLocation: branchIndex == navigationShell.currentIndex,
          );
        },
        destinations: tabs.map((tab) {
          final isNotifications = tab == NavConfig.notifications;
          final icon = Icon(tab.icon);
          final activeIcon = Icon(tab.activeIcon);

          return NavigationDestination(
            icon: isNotifications && unreadCount > 0
                ? Badge.count(count: unreadCount, child: icon)
                : icon,
            selectedIcon: isNotifications && unreadCount > 0
                ? Badge.count(count: unreadCount, child: activeIcon)
                : activeIcon,
            label: tab.label,
          );
        }).toList(),
      ),
    );
  }
}
