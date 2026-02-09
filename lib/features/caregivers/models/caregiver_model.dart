class Caregiver {
  final String id;
  final String name;
  final String imageUrl;
  final bool isOnline;
  final int rating;
  final String location;
  final String about;
  final String joinedDate;
  final List<String> services;
  final List<String> languages;
  final bool isVerified;
  final bool isAvailable;

  const Caregiver({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.isOnline = false,
    this.rating = 0,
    this.location = 'Mumbai, India',
    this.about = 'Experienced caregiver with a passion for helping others.',
    this.joinedDate = 'January 2020',
    this.services = const ['Elderly Care', 'Child Care', 'Disability Support'],
    this.languages = const ['English', 'Hindi'],
    this.isVerified = false,
    this.isAvailable = true,
  });
}
