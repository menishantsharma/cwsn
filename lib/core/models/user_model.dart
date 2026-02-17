enum Gender { male, female, other }

enum UserRole { parent, caregiver }

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
  final String? token;

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
    this.token,
  });

  bool get isParentSetup => parentProfile != null;
  bool get isCaregiverSetup => caregiverProfile != null;
  String get fullName => lastName != null && lastName!.isNotEmpty
      ? '$firstName $lastName'
      : firstName;

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
    String? token,
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
      token: token ?? this.token,
    );
  }
}

class ChildModel {
  final String id;
  final String name;
  final Gender gender;
  final DateTime dateOfBirth;

  ChildModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  ChildModel copyWith({
    String? id,
    String? name,
    Gender? gender,
    DateTime? dateOfBirth,
  }) {
    return ChildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
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
  final List<String> services;
  final bool isVerified;
  final bool isAvailable;
  final List<String> languages;
  final DateTime joinedDate;
  final int yearsOfExperience;
  final int totalRecommendations;

  CaregiverProfile({
    this.about = '',
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
