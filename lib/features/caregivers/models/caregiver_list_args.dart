/// Carries context from [SpecialNeedsPage] to [CaregiversListPage].
class CaregiverListArgs {
  final String specialNeed;
  final String? serviceTitle;
  const CaregiverListArgs({required this.specialNeed, this.serviceTitle});
}
