import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

// --- ENUMS: Simple labels for fixed choices ---

enum Gender { male, female, other }

enum UserRole { parent, caregiver }

// --- THE MAIN USER MODEL ---

@freezed
class User with _$User {
  const User._(); // This allows us to add custom getters like 'fullName'

  const factory User({
    required String id,
    required String firstName,
    String? lastName,

    // Default image if the user hasn't uploaded one
    @Default('https://randomuser.me/api/portraits/lego/1.jpg') String imageUrl,

    String? location,
    @Default('abc@example.com') String email,
    @Default(false) bool isGuest,
    String? phoneNumber,
    Gender? gender,

    // This tells the app if we are currently looking at the "Parent" or "Caregiver" side
    UserRole? activeRole,

    // Security token for API calls
    String? token,

    // Detailed profiles (Optional: a user could be one or both)
    CaregiverProfile? caregiverProfile,
    ParentModel? parentProfile,
  }) = _User;

  // Helper to create a User from a Map (usually from Firebase or API)
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // Quick helper to create a Guest user instantly
  factory User.guest() =>
      const User(id: 'guest', firstName: 'Guest', isGuest: true);

  // --- GETTERS: Easy ways to access combined data ---

  /// Returns true if the user has filled out their parent details
  bool get isParentSetup => parentProfile != null;

  /// Returns true if the user has filled out their caregiver details
  bool get isCaregiverSetup => caregiverProfile != null;

  /// Combines first and last name nicely
  String get fullName => '$firstName ${lastName ?? ''}'.trim();
}

// --- CHILD MODEL: Specific to the Parent side ---

@freezed
class ChildModel with _$ChildModel {
  const ChildModel._();

  const factory ChildModel({
    required String id,
    required String name,
    required Gender gender,
    required DateTime dateOfBirth,
  }) = _ChildModel;

  factory ChildModel.fromJson(Map<String, dynamic> json) =>
      _$ChildModelFromJson(json);

  /// Logic to calculate age based on the birthday
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;

    // Check if the birthday has actually happened yet this year
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }
}

// --- PARENT MODEL: Holds the list of children ---

@freezed
class ParentModel with _$ParentModel {
  const factory ParentModel({
    @Default([]) List<ChildModel> children,
    DateTime? joinedDate,
  }) = _ParentModel;

  factory ParentModel.fromJson(Map<String, dynamic> json) =>
      _$ParentModelFromJson(json);
}

// --- CAREGIVER PROFILE: Holds work-related info ---

@freezed
class CaregiverProfile with _$CaregiverProfile {
  const factory CaregiverProfile({
    @Default('') String about, // A short bio
    @Default([]) List<String> services, // Skills like 'Shadow Teacher'
    @Default(false) bool isVerified, // Blue checkmark status
    @Default(true) bool isAvailable, // Ready for work?
    @Default([]) List<String> languages, // Languages spoken
    DateTime? joinedDate,
    @Default(0) int yearsOfExperience,
    @Default(0) int totalRecommendations, // Like 'likes' from other parents
  }) = _CaregiverProfile;

  factory CaregiverProfile.fromJson(Map<String, dynamic> json) =>
      _$CaregiverProfileFromJson(json);
}
