/// Centralized app-wide constants.
class AppConstants {
  AppConstants._();

  /// Base URL for the backend API.
  /// Change this to your production URL when deploying.
  static const String baseUrl = 'http://127.0.0.1:8000';

  /// All languages supported by the application.
  static const List<String> supportedLanguages = [
    'Hindi',
    'English',
    'Marathi',
    'Tamil',
    'Telugu',
    'Kannada',
    'Malayalam',
    'Bengali',
    'Gujarati',
    'Punjabi',
  ];
}
