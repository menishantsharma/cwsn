import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cwsn/core/models/user_model.dart';
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
import 'package:cwsn/features/user/presentation/pages/edit_profile_page.dart';
import 'package:cwsn/features/settings/presentation/pages/settings_page.dart';
import 'package:cwsn/features/special_needs/presentation/pages/special_needs_page.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class HomeWrapperPage extends ConsumerWidget {
  const HomeWrapperPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;

    if (user?.activeRole == UserRole.caregiver) {
      return const RequestsPage();
    } else {
      return const ServicesPage();
    }
  }
}

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
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellHome',
);
final _shellNavigatorNotificationsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellNotifications',
);
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellProfile',
);

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.homePath,
    refreshListenable: notifier,

    redirect: (context, state) {
      final authState = ref.read(currentUserProvider);

      if (authState.isLoading) return null;

      final user = authState.value;
      final isLoggedIn = user != null;
      final isGuest = user?.isGuest ?? false;

      final bool onLoginPage = state.matchedLocation == AppRoutes.loginPath;
      final bool onRolePage =
          state.matchedLocation == AppRoutes.roleSelectionPath;

      if (!isLoggedIn) return onLoginPage ? null : AppRoutes.loginPath;

      if (isGuest) {
        if (onLoginPage || onRolePage) return AppRoutes.homePath;
        return null;
      }

      if (user.activeRole == null) {
        return onRolePage ? null : AppRoutes.roleSelectionPath;
      }

      if (onLoginPage || onRolePage) {
        return AppRoutes.homePath;
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
        builder: (_, _) => const SwitchingScreen(),
      ),

      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => CustomTransitionPage(
          key: state.pageKey,
          child: MainShell(navigationShell: navigationShell),
          transitionsBuilder: (context, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey, // Attached Key
            routes: [
              GoRoute(
                path: AppRoutes.homePath,
                name: AppRoutes.home,
                builder: (context, _) => const HomeWrapperPage(),
              ),
            ],
          ),

          // BRANCH 2: Notifications
          StatefulShellBranch(
            navigatorKey: _shellNavigatorNotificationsKey, // Attached Key
            routes: [
              GoRoute(
                path: AppRoutes.notificationsPath,
                name: AppRoutes.notifications,
                builder: (_, _) => const NotificationsPage(),
              ),
            ],
          ),

          // BRANCH 3: Profile
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey, // Attached Key
            routes: [
              GoRoute(
                path: AppRoutes.profilePath,
                name: AppRoutes.profile,
                builder: (_, _) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),

      // Sub-Pages
      GoRoute(
        path: AppRoutes.specialNeedsPath,
        name: AppRoutes.specialNeeds,
        builder: (_, _) => const SpecialNeedsPage(),
      ),
      GoRoute(
        path: AppRoutes.caregiversListPath,
        name: AppRoutes.caregiversList,
        builder: (_, _) => const CaregiversListPage(),
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
    ],
  );
});
