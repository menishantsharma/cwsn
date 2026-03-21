import 'package:cwsn/features/caregivers/models/backend_caregiver_filter.dart';
import 'package:cwsn/features/services/data/services_repository.dart';
import 'package:cwsn/features/services/models/caregiver_profile_model.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:cwsn/features/services/models/service_search_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches the full service catalog organized by section (auto-disposed).
final servicesListProvider =
    FutureProvider.autoDispose<List<ServiceSection>>((ref) async {
  return ref.watch(serviceRepositoryProvider).getServicesList();
});

/// Cached master service list -- NOT auto-disposed. Fetched once, reused.
final masterServiceListProvider =
    FutureProvider<List<ServiceSection>>((ref) async {
  return ref.watch(serviceRepositoryProvider).getServicesList();
});

/// Items for a single category, keyed by section title (auto-disposed).
final categoryServicesProvider = FutureProvider.autoDispose
    .family<List<ServiceItem>, String>((ref, sectionTitle) {
  return ref
      .watch(serviceRepositoryProvider)
      .getServicesByCategory(sectionTitle);
});

// ── Global search ──────────────────────────────────────────────────────────────

final serviceSearchQueryProvider =
    NotifierProvider.autoDispose<ServiceSearchQueryNotifier, String>(
  ServiceSearchQueryNotifier.new,
);

class ServiceSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void submit(String query) => state = query.trim();
  void clear() => state = '';
}

/// Fetches caregiver-backed search results. Auto-disposed when screen pops.
final serviceSearchResultsProvider =
    FutureProvider.autoDispose<List<ServiceSearchResult>>((ref) {
  final query = ref.watch(serviceSearchQueryProvider);
  if (query.isEmpty) return Future.value([]);
  return ref.watch(serviceRepositoryProvider).searchServices(query);
});

// ── Backend caregivers filter state ───────────────────────────────────────────

/// Holds the active filter for the backend caregivers list page.
/// Auto-disposes when the page is removed from the stack.
final backendCaregiverFilterProvider = NotifierProvider.autoDispose<
    BackendCaregiverFilterNotifier, BackendCaregiverFilter>(
  BackendCaregiverFilterNotifier.new,
);

class BackendCaregiverFilterNotifier
    extends Notifier<BackendCaregiverFilter> {
  @override
  BackendCaregiverFilter build() => const BackendCaregiverFilter();

  void update(BackendCaregiverFilter filter) => state = filter;
  void reset() => state = const BackendCaregiverFilter();
}

/// Caregivers filtered by category + optional backend filter params.
/// Family key: categoryName (String).
final caregiversByCategoryProvider = FutureProvider.autoDispose
    .family<List<ServiceSearchResult>, String>((ref, categoryName) {
  final filter = ref.watch(backendCaregiverFilterProvider);
  return ref
      .watch(serviceRepositoryProvider)
      .getCaregiversByCategory(categoryName, filter: filter);
});

/// Fetches a single caregiver profile by ID from the backend.
final caregiverProfileByIdProvider =
    FutureProvider.autoDispose.family<CaregiverProfile, int>((ref, id) {
  return ref.watch(serviceRepositoryProvider).getCaregiverProfileById(id);
});

/// Flat list of all unique service names from the master catalog.
final masterServiceNamesProvider = FutureProvider<List<String>>((ref) async {
  final sections = await ref.watch(masterServiceListProvider.future);
  return sections
      .expand((section) => section.items)
      .map((item) => item.title)
      .toSet()
      .toList()
    ..sort();
});
