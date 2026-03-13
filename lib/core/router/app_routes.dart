/// Centralized route names and path constants for the app's navigation.
///
/// Tab routes (home, notifications, profile) are defined in [NavConfig].
/// This class holds non-tab routes and shared constants only.
class AppRoutes {
  // Route Names — Auth
  static const String login = 'login';
  static const String roleSelection = 'role-selection';
  static const String switching = 'switching';

  // Route Names — Feature Pages (outside shell)
  static const String specialNeeds = 'special-needs';
  static const String caregiversList = 'caregivers';
  static const String caregiverProfile = 'caregiver-profile';
  static const String parentEditProfile = 'edit-profile';
  static const String addChild = 'add-child';
  static const String caregiverServices = 'caregiver-services';

  // Route Paths — Auth
  static const String loginPath = '/login';
  static const String roleSelectionPath = '/role-selection';
  static const String switchingPath = '/switching';

  // Route Paths — Feature Pages (outside shell)
  static const String specialNeedsPath = '/special-needs';
  static const String caregiversListPath = '/caregivers';
  static const String caregiverProfilePath = '/caregiver-profile';
  static const String parentEditProfilePath = '/edit-profile';
  static const String addChildPath = '/add-child';
  static const String caregiverServicesPath = '/caregiver-services';

  /// Paths accessible to unauthenticated guest users.
  static const Set<String> guestWhitelist = {
    '/', // parent home
    '/caregiver-home',
    '/notifications',
    '/profile',
    specialNeedsPath,
    caregiversListPath,
    caregiverProfilePath,
  };

  AppRoutes._();
}
