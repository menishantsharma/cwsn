import 'package:cwsn/features/special_needs/data/special_needs_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final specialNeedsRepositoryProvider = Provider<SpecialNeedsRepository>(
  (_) => FakeSpecialNeedsRepository(),
);

/// Contract for fetching special needs data.
abstract class SpecialNeedsRepository {
  /// Fetch the complete master list of special needs (for browsing).
  Future<List<String>> getAll();

  /// Fetch special needs applicable to [serviceName].
  Future<List<String>> getByService(String serviceName);
}

/// Fake implementation backed by in-memory mock data.
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
