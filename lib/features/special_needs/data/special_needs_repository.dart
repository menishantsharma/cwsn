import 'package:cwsn/core/network/api_client.dart';
import 'package:cwsn/features/special_needs/data/special_needs_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final specialNeedsRepositoryProvider = Provider<SpecialNeedsRepository>(
  (ref) => RealSpecialNeedsRepository(ref.watch(apiClientProvider)),
);

/// Contract for fetching special needs data.
abstract class SpecialNeedsRepository {
  /// Fetch the complete master list of special needs (for browsing).
  Future<List<String>> getAll();

  /// Fetch special needs applicable to [serviceName].
  Future<List<String>> getByService(String serviceName);
}

/// Live implementation backed by `GET /api/common/disabilities/`.
class RealSpecialNeedsRepository implements SpecialNeedsRepository {
  final ApiClient _client;
  const RealSpecialNeedsRepository(this._client);

  @override
  Future<List<String>> getAll() async {
    final data = await _client.get('/api/common/disabilities/');
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map((e) => e['name'] as String)
        .toList();
  }

  /// No backend endpoint for per-service filtering yet — filters locally
  /// from the mock map. When the backend adds this, swap the body here;
  /// providers and UI stay untouched.
  @override
  Future<List<String>> getByService(String serviceName) async {
    return mockSpecialNeedsByService[serviceName] ?? [];
  }
}

/// Fallback fake implementation — used in tests or when backend is unavailable.
class FakeSpecialNeedsRepository implements SpecialNeedsRepository {
  @override
  Future<List<String>> getAll() async {
    await Future.delayed(const Duration(seconds: 1));
    return mockSpecialNeeds;
  }

  @override
  Future<List<String>> getByService(String serviceName) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return mockSpecialNeedsByService[serviceName] ?? [];
  }
}
