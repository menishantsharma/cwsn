import 'package:cwsn/core/network/api_client.dart';
import 'package:cwsn/features/caregivers/models/backend_caregiver_filter.dart';
import 'package:cwsn/features/services/data/services_data.dart';
import 'package:cwsn/features/services/models/caregiver_profile_model.dart';
import 'package:cwsn/features/services/models/remote_service_model.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:cwsn/features/services/models/service_search_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>(
  (ref) => RealServiceRepository(ref.watch(apiClientProvider)),
);

abstract class ServiceRepository {
  Future<List<ServiceSection>> getServicesList();
  Future<List<ServiceItem>> getServicesByCategory(String sectionTitle);
  Future<List<ServiceSearchResult>> searchServices(String query);

  /// Returns caregivers offering services under [categoryName].
  /// Resolves the name to a category ID via `/api/common/categories/`,
  /// then calls `?category=<id>` — exact match, no false positives.
  /// Optional [filter] adds extra query params (service_type, payment_type, etc).
  Future<List<ServiceSearchResult>> getCaregiversByCategory(
    String categoryName, {
    BackendCaregiverFilter? filter,
  });

  /// Fetches a single caregiver profile by ID from `/api/users/caregiver-profiles/<id>/`.
  Future<CaregiverProfile> getCaregiverProfileById(int id);
}

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
  Future<List<ServiceItem>> getServicesByCategory(String sectionTitle) async {
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
  Future<List<ServiceSearchResult>> searchServices(String query) async {
    if (query.trim().isEmpty) return [];
    final data = await _client.get('/api/services/services/');
    if (data is! List) return [];
    final q = query.trim().toLowerCase();
    return data
        .whereType<Map<String, dynamic>>()
        .map(ServiceSearchResult.fromJson)
        .where(
          (s) =>
              s.caregiverProfile != null &&
              (s.title.toLowerCase().contains(q) ||
                  (s.categoryName?.toLowerCase().contains(q) ?? false) ||
                  (s.caregiverProfile?.qualifications
                          .toLowerCase()
                          .contains(q) ??
                      false)),
        )
        .toList();
  }

  @override
  Future<List<ServiceSearchResult>> getCaregiversByCategory(
    String categoryName, {
    BackendCaregiverFilter? filter,
  }) async {
    if (categoryName.trim().isEmpty) return [];

    // Step 1 — resolve category name → ID
    final catData = await _client.get('/api/common/categories/');
    int? categoryId;
    if (catData is List) {
      for (final c in catData.whereType<Map<String, dynamic>>()) {
        if ((c['name'] as String?)?.toLowerCase() ==
            categoryName.trim().toLowerCase()) {
          categoryId = c['id'] as int?;
          break;
        }
      }
    }

    // Step 2 — fetch services filtered by category ID + optional filter params
    final queryParams = <String, String>{
      if (categoryId != null) 'category': categoryId.toString(),
      ...?filter?.toQueryParams(),
    };

    final data = await _client.get(
      '/api/services/services/',
      queryParameters: queryParams,
    );
    if (data is! List) return [];

    // Deduplicate: one card per caregiver
    final seen = <int>{};
    return data
        .whereType<Map<String, dynamic>>()
        .map(ServiceSearchResult.fromJson)
        .where((s) {
          final cid = s.caregiverProfile?.id;
          if (cid == null) return false;
          return seen.add(cid);
        })
        .toList();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

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

  @override
  Future<CaregiverProfile> getCaregiverProfileById(int id) async {
    final data = await _client.get('/api/users/caregiver-profiles/$id/');
    if (data is! Map<String, dynamic>) {
      throw StateError('Unexpected response for caregiver profile $id');
    }
    return CaregiverProfile.fromJson(data);
  }

  ServiceItem _toServiceItem(RemoteService s) =>
      ServiceItem(id: s.id.toString(), title: s.title, imgUrl: s.image ?? '');
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
  Future<List<ServiceSearchResult>> searchServices(String query) async {
    if (query.trim().isEmpty) return [];
    await _delay();
    return [];
  }

  @override
  Future<List<ServiceSearchResult>> getCaregiversByCategory(
    String categoryName, {
    BackendCaregiverFilter? filter,
  }) async {
    await _delay();
    return [];
  }

  @override
  Future<CaregiverProfile> getCaregiverProfileById(int id) async {
    await _delay();
    throw UnimplementedError('FakeServiceRepository: no mock profile for $id');
  }
}
