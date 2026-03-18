import 'package:cwsn/features/services/data/services_data.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>(
  (ref) => FakeServiceRepository(),
);

abstract class ServiceRepository {
  Future<List<ServiceSection>> getServicesList();

  /// Returns all [ServiceItem]s for a single category identified by [sectionTitle].
  ///
  /// Throws a [StateError] if no section with that title exists.
  Future<List<ServiceItem>> getServicesByCategory(String sectionTitle);

  /// Searches across all categories and returns items whose title contains
  /// [query] (case-insensitive).
  ///
  /// Callers should guard against an empty [query] before calling, but it
  /// is safe to call regardless — returns `[]` immediately.
  ///
  /// ## Replacing with a real API
  /// Swap the in-memory filter for a network call (e.g. `GET /services?q=query`).
  /// The providers and UI that call this method stay completely untouched.
  Future<List<ServiceItem>> searchServices(String query);
}

class FakeServiceRepository implements ServiceRepository {
  Future<void> _delay() => Future.delayed(const Duration(seconds: 2));

  @override
  Future<List<ServiceSection>> getServicesList() async {
    await _delay();
    return mockServiceSections;
  }

  @override
  Future<List<ServiceItem>> getServicesByCategory(String sectionTitle) async {
    await _delay();
    return mockServiceSections
        .firstWhere(
          (s) => s.title == sectionTitle,
          orElse: () => throw StateError(
            'No section found for title: $sectionTitle',
          ),
        )
        .items;
  }

  @override
  Future<List<ServiceItem>> searchServices(String query) async {
    if (query.trim().isEmpty) return [];
    await _delay();
    final q = query.trim().toLowerCase();
    // Flatten all sections, then filter by title substring match.
    return mockServiceSections
        .expand((section) => section.items)
        .where((item) => item.title.toLowerCase().contains(q))
        .toList();
  }
}
