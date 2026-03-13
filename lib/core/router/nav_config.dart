import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/notifications/presentation/pages/notifications_page.dart';
import 'package:cwsn/features/requests/presentation/pages/requests_page.dart';
import 'package:cwsn/features/services/presentation/pages/services_page.dart';
import 'package:cwsn/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';

/// A single tab destination in the bottom navigation bar.
class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String routePath;
  final String routeName;
  final Widget Function() pageBuilder;

  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.routePath,
    required this.routeName,
    required this.pageBuilder,
  });
}

/// Centralized navigation configuration for role-based tab structures.
///
/// [allItems] defines every possible tab branch (the superset).
/// [parentTabs] and [caregiverTabs] select which branches each role sees.
/// The router generates shell branches from [allItems]; the bottom nav
/// renders only the items from the active role's config.
class NavConfig {
  NavConfig._();

  // ── Tab Definitions ──────────────────────────────────────────────

  static final parentHome = NavItem(
    label: 'Home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    routePath: '/',
    routeName: 'parent-home',
    pageBuilder: () => const ServicesPage(),
  );

  static final caregiverHome = NavItem(
    label: 'Home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    routePath: '/caregiver-home',
    routeName: 'caregiver-home',
    pageBuilder: () => const RequestsPage(),
  );

  static final notifications = NavItem(
    label: 'Alerts',
    icon: Icons.notifications_outlined,
    activeIcon: Icons.notifications_rounded,
    routePath: '/notifications',
    routeName: 'notifications',
    pageBuilder: () => const NotificationsPage(),
  );

  static final profile = NavItem(
    label: 'Profile',
    icon: Icons.person_outline,
    activeIcon: Icons.person_rounded,
    routePath: '/profile',
    routeName: 'profile',
    pageBuilder: () => const SettingsPage(),
  );

  // ── Superset (all branches the router registers) ─────────────────

  /// Order here determines the branch index in StatefulShellRoute.
  static final List<NavItem> allItems = [
    parentHome, // branch 0
    caregiverHome, // branch 1
    notifications, // branch 2
    profile, // branch 3
  ];

  // ── Role Configs ─────────────────────────────────────────────────

  static final List<NavItem> parentTabs = [parentHome, notifications, profile];

  static final List<NavItem> caregiverTabs = [
    caregiverHome,
    notifications,
    profile,
  ];

  // ── Derived sets ─────────────────────────────────────────────────

  /// Every tab path registered in the shell. Used by the guest whitelist.
  static final Set<String> allTabPaths =
      allItems.map((item) => item.routePath).toSet();

  // ── Helpers ──────────────────────────────────────────────────────

  /// Returns the tab list for the given role. Defaults to parent.
  static List<NavItem> tabsForRole(UserRole? role) {
    return role == UserRole.caregiver ? caregiverTabs : parentTabs;
  }

  /// Maps a [NavItem] to its branch index in [allItems].
  static int branchIndexOf(NavItem item) => allItems.indexOf(item);

  /// Given the current shell branch index, returns the visible tab
  /// index within [tabs], or -1 if the branch isn't in the config.
  static int visibleIndexForBranch(int branchIndex, List<NavItem> tabs) {
    if (branchIndex < 0 || branchIndex >= allItems.length) return -1;
    return tabs.indexOf(allItems[branchIndex]);
  }

  /// Returns the home path for the given role.
  static String homePathForRole(UserRole? role) {
    return role == UserRole.caregiver
        ? caregiverHome.routePath
        : parentHome.routePath;
  }

  /// Returns true if [path] is a role-specific home that doesn't
  /// belong to [role]. Used by the redirect guard.
  static bool isWrongHomeForRole(String path, UserRole role) {
    if (role == UserRole.caregiver && path == parentHome.routePath) return true;
    if (role == UserRole.parent && path == caregiverHome.routePath) return true;
    return false;
  }
}
