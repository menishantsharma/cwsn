enum Gender { male, female, other }

enum UserRole { parent, caregiver }

class ChildModel {
  final String id;
  final int age;
  final String name;
  final Gender gender;

  ChildModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
  });

  ChildModel copyWith({String? id, int? age, String? name, Gender? gender}) {
    return ChildModel(
      id: id ?? this.id,
      age: age ?? this.age,
      name: name ?? this.name,
      gender: gender ?? this.gender,
    );
  }
}

class ParentModel {
  final List<ChildModel> children;
  final DateTime joinedDate;

  ParentModel({this.children = const [], DateTime? joinedDate})
    : joinedDate = joinedDate ?? DateTime.now();

  ParentModel copyWith({List<ChildModel>? children, DateTime? joinedDate}) {
    return ParentModel(
      children: children ?? this.children,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}

class CaregiverProfile {
  final String about;
  final int rating;
  final List<String> services;
  final bool isVerified;
  final bool isAvailable;
  final List<String> languages;
  final DateTime joinedDate;
  final int yearsOfExperience;
  final int totalRecommendations;

  CaregiverProfile({
    this.about = '',
    this.rating = 0,
    this.services = const [],
    this.isVerified = false,
    this.isAvailable = true,
    this.languages = const [],
    DateTime? joinedDate,
    this.yearsOfExperience = 0,
    this.totalRecommendations = 0,
  }) : joinedDate = joinedDate ?? DateTime.now();

  CaregiverProfile copyWith({
    String? about,
    int? rating,
    List<String>? services,
    bool? isVerified,
    bool? isAvailable,
    List<String>? languages,
    DateTime? joinedDate,
    int? yearsOfExperience,
    int? totalRecommendations,
  }) {
    return CaregiverProfile(
      about: about ?? this.about,
      rating: rating ?? this.rating,
      services: services ?? this.services,
      isVerified: isVerified ?? this.isVerified,
      isAvailable: isAvailable ?? this.isAvailable,
      languages: languages ?? this.languages,
      joinedDate: joinedDate ?? this.joinedDate,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      totalRecommendations: totalRecommendations ?? this.totalRecommendations,
    );
  }
}

class User {
  final String id;
  final String firstName;
  final String? lastName;
  final String imageUrl;
  final String? location;
  final String email;
  final bool isGuest;
  final String? phoneNumber;
  final Gender? gender;
  final UserRole? activeRole;

  final CaregiverProfile? caregiverProfile;
  final ParentModel? parentProfile;

  User({
    required this.id,
    required this.firstName,
    this.lastName,
    this.imageUrl = 'https://randomuser.me/api/portraits/lego/1.jpg',
    this.location,
    this.caregiverProfile,
    this.parentProfile,
    this.email = 'abc@example.com',
    this.isGuest = false,
    this.phoneNumber,
    this.gender,
    this.activeRole,
  });

  bool get isParentSetup => parentProfile != null;
  bool get isCaregiverSetup => caregiverProfile != null;

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? imageUrl,
    String? location,
    String? email,
    bool? isGuest,
    String? phoneNumber,
    Gender? gender,
    CaregiverProfile? caregiverProfile,
    ParentModel? parentProfile,
    UserRole? activeRole,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      caregiverProfile: caregiverProfile ?? this.caregiverProfile,
      parentProfile: parentProfile ?? this.parentProfile,
      activeRole: activeRole ?? this.activeRole,
    );
  }
}
