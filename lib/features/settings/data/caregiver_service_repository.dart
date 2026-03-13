import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the active [CaregiverServiceRepository] implementation.
final caregiverServiceRepositoryProvider = Provider<CaregiverServiceRepository>(
  (ref) => FakeCaregiverServiceRepository(),
);

/// Contract for managing a caregiver's offered services.
abstract class CaregiverServiceRepository {
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

class FakeCaregiverServiceRepository implements CaregiverServiceRepository {
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
