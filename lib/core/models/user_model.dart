enum Gender { male, female, other }

class ChildModel {
  final String name;
  final int age;
  final Gender gender;

  ChildModel({required this.name, required this.age, required this.gender});
}

class ParentModel {
  final List<ChildModel> children;
  final DateTime joinedDate;

  ParentModel({this.children = const [], DateTime? joinedDate})
    : joinedDate = joinedDate ?? DateTime.now();
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
}

class User {
  final String id;
  final String firstName;
  final String? lastName;
  final String imageUrl;
  final String? location;
  final String email;
  final bool isGuest;

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
  });

  bool get isParentSetup => parentProfile != null;
  bool get isCaregiverSetup => caregiverProfile != null;
}
