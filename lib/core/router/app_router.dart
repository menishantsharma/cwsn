import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// --- Feature Imports ---
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

/// Global key for showing SnackBars (Alerts) without needing BuildContext
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class HomeWrapperPage extends ConsumerWidget {
  const HomeWrapperPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. We use ref.WATCH here so this widget rebuilds whenever the user state changes
    final user = ref.watch(currentUserProvider).value;

    // 2. Dynamically return the correct page
    if (user?.activeRole == UserRole.caregiver) {
      return const RequestsPage();
    } else {
      return const ServicesPage();
    }
  }
}

/// Centralized Routing Constants
class AppRoutes {
  // --- Route Names ---
  static const String login = 'login';
  static const String roleSelection = 'role-selection';
  static const String switching = 'switching';
  static const String home = 'home';
  static const String notifications = 'notifications';
  static const String profile = 'profile';
  static const String specialNeeds = 'special-needs';
  static const String caregiversList = 'caregivers';
  static const String caregiverProfile = 'caregiver-profile';
  static const String parentEditProfile = 'edit-profile';
  static const String addChild = 'add-child';

  // --- Route Paths ---
  static const String loginPath = '/login';
  static const String roleSelectionPath = '/role-selection';
  static const String switchingPath = '/switching';
  static const String homePath = '/';
  static const String notificationsPath = '/notifications';
  static const String profilePath = '/profile';
  static const String specialNeedsPath = '/special-needs';
  static const String caregiversListPath = '/caregivers';
  static const String caregiverProfilePath = '/caregiver-profile';
  static const String parentEditProfilePath = '/edit-profile';
  static const String addChildPath = '/add-child';

  AppRoutes._();
}

/// 1. OPTIMIZED: Smarter Notifier for AsyncValue
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen(currentUserProvider, (previous, next) {
      // Only refresh the router if the Auth Notifier has finished loading data.
      // This prevents UI flickering during the login API calls.
      if (!next.isLoading) {
        notifyListeners();
      }
    });
  }
}

// 2. OPTIMIZED: Unique Navigator Keys for memory safety & tab persistence
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

    // ==========================================
    // REDIRECTION LOGIC
    // ==========================================
    redirect: (context, state) {
      // 3. OPTIMIZED: Extract from AsyncValue safely
      final authState = ref.read(currentUserProvider);

      // Do not interrupt the user with redirects if the Auth state is still fetching/loading
      if (authState.isLoading) return null;

      final user = authState.value;
      final isLoggedIn = user != null;
      final isGuest = user?.isGuest ?? false;

      final bool onLoginPage = state.matchedLocation == AppRoutes.loginPath;
      final bool onRolePage =
          state.matchedLocation == AppRoutes.roleSelectionPath;

      // Unauthenticated -> Go to Login
      if (!isLoggedIn) return onLoginPage ? null : AppRoutes.loginPath;

      // Guest -> Go Home (Skip Role selection)
      if (isGuest) {
        if (onLoginPage || onRolePage) return AppRoutes.homePath;
        return null;
      }

      // Logged In but no Role chosen -> Go to Role Selection
      if (user.activeRole == null) {
        return onRolePage ? null : AppRoutes.roleSelectionPath;
      }

      // Role exists -> Prevent going back to Login/Role Selection
      if (onLoginPage || onRolePage) {
        return AppRoutes.homePath;
      }

      return null;
    },

    // ==========================================
    // ROUTE CONFIGURATION
    // ==========================================
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

      // Main Navigation Shell (Tabs)
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => CustomTransitionPage(
          key: state.pageKey,
          child: ScaffoldWithNavbar(navigationShell: navigationShell),
          transitionsBuilder: (context, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
        branches: [
          // BRANCH 1: Home
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
        builder: (_, _) => const ParentEditProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.addChildPath,
        name: AppRoutes.addChild,
        builder: (_, _) => const AddChildPage(),
      ),
    ],
  );
});
