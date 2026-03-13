import 'package:cwsn/core/models/caregiver_service_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum Gender { male, female, other }

enum UserRole { parent, caregiver }

@freezed
class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String firstName,
    String? lastName,
    String? imageUrl,
    String? location,
    @Default('abc@example.com') String email,
    @Default(false) bool isGuest,
    String? phoneNumber,
    Gender? gender,

    UserRole? activeRole,
    String? token,

    CaregiverProfile? caregiverProfile,
    ParentModel? parentProfile,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.guest() =>
      const User(id: 'guest', firstName: 'Guest', isGuest: true);

  bool get isParentSetup => parentProfile != null;
  bool get isCaregiverSetup => caregiverProfile != null;
  String get fullName => '$firstName ${lastName ?? ''}'.trim();
}

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

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;

    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }
}

@freezed
class ParentModel with _$ParentModel {
  const factory ParentModel({
    @Default([]) List<ChildModel> children,
    DateTime? joinedDate,
  }) = _ParentModel;

  factory ParentModel.fromJson(Map<String, dynamic> json) =>
      _$ParentModelFromJson(json);
}

@freezed
class CaregiverProfile with _$CaregiverProfile {
  const factory CaregiverProfile({
    @Default('') String about,
    @Default([]) List<CaregiverService> services,
    @Default(false) bool isVerified,
    @Default(true) bool isAvailable,
    @Default([]) List<String> languages,
    DateTime? joinedDate,
    @Default(0) int yearsOfExperience,
    @Default(0) int totalRecommendations,
  }) = _CaregiverProfile;

  factory CaregiverProfile.fromJson(Map<String, dynamic> json) =>
      _$CaregiverProfileFromJson(json);
}
