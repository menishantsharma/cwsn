import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/widgets/scaffold_with_navbar.dart';
import 'package:cwsn/core/widgets/switching_screen.dart';
import 'package:cwsn/features/auth/presentation/pages/login_page.dart';
import 'package:cwsn/features/auth/presentation/pages/role_selection_page.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/caregivers/presentation/pages/caregiver_profile_page.dart';
import 'package:cwsn/features/caregivers/presentation/pages/caregivers_list_page.dart';
import 'package:cwsn/features/notifications/presentation/pages/notifications_page.dart';
import 'package:cwsn/features/requests/presentation/pages/requests_page.dart';
import 'package:cwsn/features/services/presentation/pages/services_page.dart';
import 'package:cwsn/features/settings/presentation/pages/add_child_page.dart';
import 'package:cwsn/features/settings/presentation/pages/parent_edit_profile_page.dart';
import 'package:cwsn/features/settings/presentation/pages/settings_page.dart';
import 'package:cwsn/features/special_needs/pages/special_needs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  // Route names
  static const String home = '/';
  static const String specialNeeds = 'special-needs';
  static const String caregiversList = 'caregivers';
  static const String caregiverProfile = 'caregiver-profile';
  static const String notifications = 'notifications';
  static const String profile = 'profile';
  static const String requests = 'requests';
  static const String switching = 'switching';
  static const String caregiverNotifications = 'caregiver-notifications';
  static const String caregiverSettings = 'caregiver-settings';
  static const String parentEditProfile = 'parent-edit-profile';
  static const String addChild = 'add-child';
  static const String login = 'login';
  static const String roleSelection = 'role-selection';

  // Route paths
  static const String specialNeedsPath = '/special-needs';
  static const String caregiversListPath = '/caregivers';
  static const String caregiverProfilePath = '/caregiver-profile';
  static const String requestsPath = '/requests';
  static const String switchingPath = '/switching';
  static const String notificationsPath = '/notifications';
  static const String caregiverNotificationsPath = '/caregiver-notifications';
  static const String caregiverSettingsPath = '/caregiver-settings';
  static const String parentEditProfilePath = '/parent-edit-profile';
  static const String addChildPath = '/add-child';
  static const String loginPath = '/login';
  static const String roleSelectionPath = '/role-selection';

  AppRoutes._();
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final routerNotifier = ValueNotifier<User?>(ref.read(currentUserProvider));
  ref.listen<User?>(currentUserProvider, (previous, next) {
    routerNotifier.value = next;
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final user = ref.read(currentUserProvider);
      final isLoggedIn = user != null;
      final goingToLogin = state.matchedLocation == AppRoutes.loginPath;
      final goingToRoleSelection =
          state.matchedLocation == AppRoutes.roleSelectionPath;

      if (!isLoggedIn) {
        return goingToLogin ? null : AppRoutes.loginPath;
      }

      if (user.isGuest) {
        if (goingToLogin || goingToRoleSelection) return AppRoutes.home;
        return null;
      }

      if (user.activeRole == null) {
        return goingToRoleSelection ? null : AppRoutes.roleSelectionPath;
      }

      if (goingToLogin || goingToRoleSelection) {
        if (user.activeRole == UserRole.caregiver) {
          return AppRoutes.requestsPath;
        } else {
          return AppRoutes.home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.roleSelectionPath,
        name: AppRoutes.roleSelection,
        builder: (context, state) => const RoleSelectionPage(),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ScaffoldWithNavbar(navigationShell: navigationShell),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(
                      curve: Curves.easeInOut,
                    ).animate(animation),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 600),
          );
        },
        branches: [
          // BRANCH 1: HOME (The main flow)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: AppRoutes.home,
                builder: (context, state) => const ServicesPage(),
              ),
            ],
          ),

          // BRANCH 2: Notifications
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.notificationsPath,
                name: AppRoutes.notifications,
                builder: (context, state) {
                  return Scaffold(body: const NotificationsPage());
                },
              ),
            ],
          ),

          // BRANCH 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRoutes.profile,
                builder: (context, state) {
                  return SettingsPage();
                },
              ),
            ],
          ),
        ],
      ),

      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ScaffoldWithNavbar(navigationShell: navigationShell),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(
                      curve: Curves.easeInOut,
                    ).animate(animation),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 600),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.requestsPath,
                name: AppRoutes.requests,
                builder: (context, state) => const RequestsPage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.caregiverNotificationsPath,
                name: AppRoutes.caregiverNotifications,
                builder: (context, state) => const NotificationsPage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.caregiverSettingsPath,
                name: AppRoutes.caregiverSettings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),

      // Additional routes outside the bottom navigation
      GoRoute(
        name: AppRoutes.specialNeeds,
        path: AppRoutes.specialNeedsPath,
        // Page displaying special needs categories
        builder: (context, state) => const SpecialNeedsPage(),
      ),
      GoRoute(
        name: AppRoutes.caregiversList,
        path: AppRoutes.caregiversListPath,
        // Page displaying list of caregivers
        builder: (context, state) => const CaregiversListPage(),
      ),
      GoRoute(
        name: AppRoutes.caregiverProfile,
        path: AppRoutes.caregiverProfilePath,
        // Page displaying caregiver profile details
        builder: (context, state) {
          final caregiverId = state.extra as String? ?? '';
          return CaregiverProfilePage(caregiverId: caregiverId);
        },
      ),

      GoRoute(
        name: AppRoutes.switching,
        path: AppRoutes.switchingPath,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SwitchingScreen(),
          key: state.pageKey,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      ),

      GoRoute(
        name: AppRoutes.parentEditProfile,
        path: AppRoutes.parentEditProfilePath,
        builder: (context, state) => const ParentEditProfilePage(),
      ),

      GoRoute(
        name: AppRoutes.addChild,
        path: AppRoutes.addChildPath,
        builder: (context, state) => const AddChildPage(),
      ),
    ],
  );
});
