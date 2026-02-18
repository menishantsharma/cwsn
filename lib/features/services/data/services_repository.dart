import 'package:cwsn/features/services/data/services_data.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>(
  (ref) => FakeServiceRepository(),
);

abstract class ServiceRepository {
  Future<List<ServiceSection>> getServicesList();
}

class FakeServiceRepository implements ServiceRepository {
  Future<void> simulateNetworkDelay() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Future<List<ServiceSection>> getServicesList() async {
    await simulateNetworkDelay();
    return mockServiceSections;
  }
}
