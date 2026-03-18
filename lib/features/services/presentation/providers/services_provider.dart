import 'package:cwsn/features/services/data/services_repository.dart';
import 'package:cwsn/features/services/models/service_model.dart';
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
///
/// Usage: `ref.watch(categoryServicesProvider('Therapy Services'))`
final categoryServicesProvider = FutureProvider.autoDispose
    .family<List<ServiceItem>, String>((ref, sectionTitle) {
  return ref
      .watch(serviceRepositoryProvider)
      .getServicesByCategory(sectionTitle);
});

// ── Global search ──────────────────────────────────────────────────────────────

/// Holds the query string that was last *submitted* on [ServiceSearchScreen].
///
/// **Only updated in `onSubmitted`** — never on every keystroke — so the
/// backend is not hammered while the user is still typing.
///
/// Auto-disposed when [ServiceSearchScreen] is popped, so re-opening the
/// screen always shows a blank slate.
///
/// Usage:
/// ```dart
/// // Submit a query (called from TextField.onSubmitted):
/// ref.read(serviceSearchQueryProvider.notifier).submit('yoga');
///
/// // Clear (called from the ✕ button):
/// ref.read(serviceSearchQueryProvider.notifier).clear();
/// ```
final serviceSearchQueryProvider =
    NotifierProvider.autoDispose<ServiceSearchQueryNotifier, String>(
  ServiceSearchQueryNotifier.new,
);

/// Notifier for [serviceSearchQueryProvider].
///
/// Extend this class to add query history persistence (e.g. SharedPreferences)
/// or debounce logic if the backend supports live search.
class ServiceSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  /// Trims and commits [query]. Called from `TextField.onSubmitted`.
  void submit(String query) => state = query.trim();

  /// Resets to empty — called from the clear button.
  void clear() => state = '';
}

/// Fetches search results for the current [serviceSearchQueryProvider] value.
///
/// - Empty query → returns `[]` immediately (no network call).
/// - Non-empty query → calls [ServiceRepository.searchServices].
///
/// Auto-disposed alongside [serviceSearchQueryProvider] when the screen pops.
///
/// ## How to extend
/// - Pagination: add a `page` parameter and use `.family<List<ServiceItem>, int>`.
/// - Caching: remove `.autoDispose` to keep results in memory between visits.
final serviceSearchResultsProvider =
    FutureProvider.autoDispose<List<ServiceItem>>((ref) {
  final query = ref.watch(serviceSearchQueryProvider);

  // Guard: skip the backend round-trip when the field is empty.
  if (query.isEmpty) return Future.value([]);

  return ref.watch(serviceRepositoryProvider).searchServices(query);
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
