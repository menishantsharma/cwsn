import 'package:flutter_riverpod/flutter_riverpod.dart';

final caregiverRepositoryProvider = Provider<CaregiverRepository>(
  (ref) => FakeCaregiverRepository(),
);

abstract class CaregiverRepository {
  Future<String> addService({
    required String caregiverId,
    required String service,
  });

  Future<String> updateService({
    required String caregiverId,
    required String oldService,
    required String newService,
  });

  Future<void> deleteService({
    required String caregiverId,
    required String service,
  });
}

class FakeCaregiverRepository implements CaregiverRepository {
  @override
  Future<String> addService({
    required String caregiverId,
    required String service,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return service;
  }

  @override
  Future<String> updateService({
    required String caregiverId,
    required String oldService,
    required String newService,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return newService;
  }

  @override
  Future<void> deleteService({
    required String caregiverId,
    required String service,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
