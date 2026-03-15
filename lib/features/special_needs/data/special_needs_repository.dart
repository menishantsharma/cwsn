import 'package:cwsn/features/special_needs/data/special_needs_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final specialNeedsRepositoryProvider =
    Provider<SpecialNeedsRepository>((_) => FakeSpecialNeedsRepository());

abstract class SpecialNeedsRepository {
  Future<List<String>> getAll();
  Future<List<String>> getByService(String serviceName);
}

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
