/// Centralized route names and path constants for the app's navigation.
class AppRoutes {
  // Route Names
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
  static const String caregiverServices = 'caregiver-services';

  // Route Paths
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
  static const String caregiverServicesPath = '/caregiver-services';

  /// Paths accessible to unauthenticated guest users.
  static const Set<String> guestWhitelist = {
    homePath,
    notificationsPath,
    profilePath,
    specialNeedsPath,
    caregiversListPath,
    caregiverProfilePath,
  };

  AppRoutes._();
}
