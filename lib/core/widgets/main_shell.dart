import 'package:cwsn/core/router/nav_config.dart';
import 'package:cwsn/core/widgets/app_bottom_nav_bar.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The root shell widget for tabbed navigation.
///
/// Reads the current user's role and delegates tab rendering
/// to [AppBottomNavBar] via [NavConfig]. No role-specific
/// conditionals live here — the config drives everything.
class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentUserProvider).value?.activeRole;
    final tabs = NavConfig.tabsForRole(role);

    // Map the shell's absolute branch index → visible tab index.
    final visibleIndex = NavConfig.visibleIndexForBranch(
      navigationShell.currentIndex,
      tabs,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F8),
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        tabs: tabs,
        currentIndex: visibleIndex.clamp(0, tabs.length - 1),
        onTap: (visibleIdx) {
          // Map visible tab index → absolute branch index in the shell.
          final branchIndex = NavConfig.branchIndexOf(tabs[visibleIdx]);
          navigationShell.goBranch(
            branchIndex,
            initialLocation: branchIndex == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
