import 'package:flutter/material.dart';

/// A single tab destination in the bottom navigation bar.
///
/// Each [NavItem] defines everything needed to register a shell route
/// branch and render its corresponding bottom nav entry.
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
