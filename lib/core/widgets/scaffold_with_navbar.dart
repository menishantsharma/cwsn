import 'package:cwsn/core/widgets/pill_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavbar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavbar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: PillNavbar(
              selectedIndex: navigationShell.currentIndex,
              onTap: (index) => _onTap(context, index),
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
