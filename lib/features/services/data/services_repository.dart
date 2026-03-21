import 'package:cwsn/core/network/api_client.dart';
import 'package:cwsn/features/services/data/services_data.dart';
import 'package:cwsn/features/services/models/remote_service_model.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>(
  (ref) => RealServiceRepository(ref.watch(apiClientProvider)),
);

abstract class ServiceRepository {
  Future<List<ServiceSection>> getServicesList();

  /// Returns all [ServiceItem]s for a single category identified by [sectionTitle].
  Future<List<ServiceItem>> getServicesByCategory(String sectionTitle);

  /// Searches across all categories and returns items whose title contains
  /// [query] (case-insensitive).
  Future<List<ServiceItem>> searchServices(String query);
}

/// Live implementation that fetches from `GET /api/services/services/`.
///
/// Groups the flat service list by [RemoteService.categoryName] so the UI
/// receives the same [List<ServiceSection>] shape it already expects.
class RealServiceRepository implements ServiceRepository {
  final ApiClient _client;
  const RealServiceRepository(this._client);

  @override
  Future<List<ServiceSection>> getServicesList() async {
    final data = await _client.get('/api/services/services/');

    if (data is! List) return [];

    final remoteServices = data
        .whereType<Map<String, dynamic>>()
        .map(RemoteService.fromJson)
        .where((s) => s.isActive)
        .toList();

    return _groupByCategory(remoteServices);
  }

  @override
  Future<List<ServiceItem>> getServicesByCategory(
    String sectionTitle,
  ) async {
    final sections = await getServicesList();
    return sections
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

    final data = await _client.get(
      '/api/services/services/',
      queryParameters: {'search': query.trim()},
    );

    if (data is! List) return [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(RemoteService.fromJson)
        .where((s) => s.isActive)
        .map(_toServiceItem)
        .toList();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  List<ServiceSection> _groupByCategory(List<RemoteService> services) {
    final Map<String, List<ServiceItem>> grouped = {};

    for (final service in services) {
      final category = service.categoryName ?? 'Other';
      grouped.putIfAbsent(category, () => []).add(_toServiceItem(service));
    }

    return grouped.entries
        .map((e) => ServiceSection(title: e.key, items: e.value))
        .toList();
  }

  ServiceItem _toServiceItem(RemoteService s) => ServiceItem(
        id: s.id.toString(),
        title: s.title,
        imgUrl: s.image ?? '',
      );
}

/// Fallback fake implementation — used in tests or when backend is unavailable.
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
    return mockServiceSections
        .expand((section) => section.items)
        .where((item) => item.title.toLowerCase().contains(q))
        .toList();
  }
}
