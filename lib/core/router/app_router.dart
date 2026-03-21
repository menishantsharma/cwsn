import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/router/nav_config.dart';
import 'package:cwsn/features/caregivers/models/caregiver_list_args.dart';
import 'package:cwsn/core/widgets/main_shell.dart';
import 'package:cwsn/core/widgets/switching_screen.dart';
import 'package:cwsn/features/auth/presentation/pages/login_page.dart';
import 'package:cwsn/features/auth/presentation/pages/role_selection_page.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/caregivers/presentation/pages/caregiver_profile_page.dart';
import 'package:cwsn/features/caregivers/presentation/pages/caregivers_list_page.dart';
import 'package:cwsn/features/requests/presentation/pages/accepted_requests_page.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:cwsn/features/services/presentation/pages/category_services_page.dart';
import 'package:cwsn/features/services/presentation/pages/service_search_screen.dart';
import 'package:cwsn/features/settings/presentation/pages/add_child_page.dart';
import 'package:cwsn/features/settings/presentation/pages/add_service_page.dart';
import 'package:cwsn/features/special_needs/presentation/pages/special_needs_page.dart';
import 'package:cwsn/features/user/presentation/pages/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Triggers GoRouter refresh when authentication state changes.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen(currentUserProvider, (previous, next) {
      if (!next.isLoading) {
        notifyListeners();
      }
    });
  }
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// One navigator key per shell branch, generated from [NavConfig.allItems].
final _branchNavigatorKeys = {
  for (final item in NavConfig.allItems)
    item.routeName: GlobalKey<NavigatorState>(
      debugLabel: 'shell-${item.routeName}',
    ),
};

/// The application's top-level router configuration.
///
/// Shell branches are generated from [NavConfig.allItems].
/// No role-specific conditionals — the config drives everything.
final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: NavConfig.parentHome.routePath,
    refreshListenable: notifier,

    redirect: (context, state) {
      final authState = ref.read(currentUserProvider);

      if (authState.isLoading) return null;

      final user = authState.value;
      final isLoggedIn = user != null;
      final isGuest = user?.isGuest ?? false;

      final currentPath = state.matchedLocation;
      final bool onLoginPage = currentPath == AppRoutes.loginPath;
      final bool onRolePage = currentPath == AppRoutes.roleSelectionPath;

      if (!isLoggedIn) return onLoginPage ? null : AppRoutes.loginPath;

      if (isGuest) {
        if (onLoginPage || onRolePage) {
          return NavConfig.homePathForRole(user.activeRole);
        }

        final isAllowed = AppRoutes.guestWhitelist.any(
          (route) => currentPath == route || currentPath.startsWith('$route/'),
        );

        if (!isAllowed) return AppRoutes.loginPath;
        return null;
      }

      if (user.activeRole == null) {
        return onRolePage ? null : AppRoutes.roleSelectionPath;
      }

      if (onLoginPage || onRolePage) {
        return NavConfig.homePathForRole(user.activeRole);
      }

      // Guard: redirect if user landed on the wrong role's home.
      if (NavConfig.isWrongHomeForRole(currentPath, user.activeRole!)) {
        return NavConfig.homePathForRole(user.activeRole);
      }

      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (_, _) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.roleSelectionPath,
        name: AppRoutes.roleSelection,
        builder: (_, _) => const RoleSelectionPage(),
      ),
      GoRoute(
        path: AppRoutes.switchingPath,
        name: AppRoutes.switching,
        pageBuilder: (_, _) => CustomTransitionPage(
          child: const SwitchingScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Scale up + fade in — feels like an overlay/mode switch,
            // not a regular page navigation.
            final scale = Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: scale, child: child),
            );
          },
        ),
      ),

      // ── Tabbed shell — branches generated from NavConfig ──────────
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          // Key on the active role so the entire shell (and its
          // IndexedStack state) is destroyed and rebuilt on role switch.
          final role = ref.read(currentUserProvider).value?.activeRole;
          return CustomTransitionPage(
            key: ValueKey('shell-$role'),
            child: MainShell(navigationShell: navigationShell),
            transitionDuration: const Duration(milliseconds: 350),
            reverseTransitionDuration: const Duration(milliseconds: 350),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final scale = Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: scale, child: child),
              );
            },
          );
        },
        branches: NavConfig.allItems
            .map(
              (item) => StatefulShellBranch(
                navigatorKey: _branchNavigatorKeys[item.routeName],
                routes: [
                  GoRoute(
                    path: item.routePath,
                    name: item.routeName,
                    builder: (_, _) => item.pageBuilder(),
                  ),
                ],
              ),
            )
            .toList(),
      ),

      // ── Feature pages (outside shell) ─────────────────────────────
      GoRoute(
        path: AppRoutes.specialNeedsPath,
        name: AppRoutes.specialNeeds,
        builder: (_, state) => SpecialNeedsPage(
          serviceTitle: state.extra as String?,
        ),
      ),
      GoRoute(
        path: AppRoutes.caregiversListPath,
        name: AppRoutes.caregiversList,
        builder: (_, state) => CaregiversListPage(
          args: state.extra as CaregiverListArgs?,
        ),
      ),
      GoRoute(
        path: AppRoutes.caregiverProfilePath,
        name: AppRoutes.caregiverProfile,
        builder: (context, state) =>
            CaregiverProfilePage(caregiverId: state.extra as String? ?? ''),
      ),
      GoRoute(
        path: AppRoutes.parentEditProfilePath,
        name: AppRoutes.parentEditProfile,
        builder: (_, _) => const EditProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.addChildPath,
        name: AppRoutes.addChild,
        builder: (_, _) => const AddChildPage(),
      ),
      GoRoute(
        path: AppRoutes.caregiverServicesPath,
        name: AppRoutes.caregiverServices,
        builder: (_, _) => const AddServicePage(),
      ),
      GoRoute(
        path: AppRoutes.acceptedRequestsPath,
        name: AppRoutes.acceptedRequests,
        builder: (_, _) => const AcceptedRequestsPage(),
      ),
      GoRoute(
        path: AppRoutes.categoryServicesPath,
        name: AppRoutes.categoryServices,
        builder: (_, state) => CategoryServicesPage(
          section: state.extra! as ServiceSection,
        ),
      ),
      GoRoute(
        path: AppRoutes.serviceSearchPath,
        name: AppRoutes.serviceSearch,
        builder: (_, _) => const ServiceSearchScreen(),
      ),
    ],
  );
});
