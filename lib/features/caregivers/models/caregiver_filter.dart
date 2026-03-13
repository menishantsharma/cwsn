/// Type-safe filter parameters for the caregivers list.
class CaregiverFilter {
  final String? gender;
  final List<String> languages;

  const CaregiverFilter({
    this.gender,
    this.languages = const [],
  });

  bool get isEmpty => gender == null && languages.isEmpty;
}
