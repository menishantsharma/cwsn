import 'package:cwsn/core/router/nav_config.dart';

/// Centralized route names and path constants for the app's navigation.
///
/// Tab routes are defined in [NavConfig].
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
  static const String acceptedRequests = 'accepted-requests';
  static const String categoryServices = 'category-services';
  static const String serviceSearch = 'service-search';

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
  static const String acceptedRequestsPath = '/accepted-requests';
  static const String categoryServicesPath = '/category-services';
  static const String serviceSearchPath = '/service-search';

  /// Paths accessible to unauthenticated guest users.
  /// Tab paths are sourced from [NavConfig] — no hardcoded duplicates.
  static final Set<String> guestWhitelist = {
    ...NavConfig.allTabPaths,
    specialNeedsPath,
    caregiversListPath,
    caregiverProfilePath,
    categoryServicesPath,
    serviceSearchPath,
  };

  AppRoutes._();
}
