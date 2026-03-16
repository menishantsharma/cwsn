import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:cwsn/features/caregivers/models/caregiver_filter.dart';
import 'package:cwsn/features/caregivers/models/caregiver_sort.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the current filter state. UI writes to it; list provider watches it.
/// Auto-disposes when the caregivers list page is no longer visible,
/// so filters reset on back-navigation and logout.
final caregiverFilterProvider =
    NotifierProvider.autoDispose<CaregiverFilterNotifier, CaregiverFilter>(
  CaregiverFilterNotifier.new,
);

class CaregiverFilterNotifier extends Notifier<CaregiverFilter> {
  @override
  CaregiverFilter build() => const CaregiverFilter();

  void update(CaregiverFilter filter) => state = filter;

  void reset() => state = const CaregiverFilter();
}

/// Holds the current sort option. UI writes to it; list provider watches it.
/// Auto-disposes alongside the filter when the list page is removed.
final caregiverSortProvider =
    NotifierProvider.autoDispose<CaregiverSortNotifier, CaregiverSortOption>(
  CaregiverSortNotifier.new,
);

class CaregiverSortNotifier extends Notifier<CaregiverSortOption> {
  @override
  CaregiverSortOption build() => CaregiverSortOption.recommended;

  void update(CaregiverSortOption option) => state = option;
}

/// Fetches/refetches the caregiver list whenever filter or sort changes.
final caregiversListProvider =
    FutureProvider.autoDispose<List<User>>((ref) async {
  final filter = ref.watch(caregiverFilterProvider);
  final sort = ref.watch(caregiverSortProvider);
  return ref
      .watch(caregiverRepositoryProvider)
      .getCaregiversList(filter: filter, sort: sort);
});

/// Fetches a single caregiver's profile by ID.
final caregiverProfileProvider =
    FutureProvider.autoDispose.family<User, String>((ref, caregiverId) async {
  return ref
      .watch(caregiverRepositoryProvider)
      .getCaregiverDetails(caregiverId);
});
