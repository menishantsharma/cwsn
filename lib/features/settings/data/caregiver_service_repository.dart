import 'package:cwsn/core/models/caregiver_service_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the active [CaregiverServiceRepository] implementation.
final caregiverServiceRepositoryProvider = Provider<CaregiverServiceRepository>(
  (ref) => FakeCaregiverServiceRepository(),
);

/// Contract for managing a caregiver's offered services.
abstract class CaregiverServiceRepository {
  Future<CaregiverService> addService({
    required String caregiverId,
    required CaregiverService service,
  });
  Future<CaregiverService> updateService({
    required String caregiverId,
    required CaregiverService service,
  });
  Future<void> deleteService({
    required String caregiverId,
    required String serviceId,
  });
  Future<CaregiverService> toggleServiceActive({
    required String caregiverId,
    required String serviceId,
    required bool isActive,
  });
}

class FakeCaregiverServiceRepository implements CaregiverServiceRepository {
  @override
  Future<CaregiverService> addService({
    required String caregiverId,
    required CaregiverService service,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return service.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  @override
  Future<CaregiverService> updateService({
    required String caregiverId,
    required CaregiverService service,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return service;
  }

  @override
  Future<void> deleteService({
    required String caregiverId,
    required String serviceId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<CaregiverService> toggleServiceActive({
    required String caregiverId,
    required String serviceId,
    required bool isActive,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return CaregiverService(id: serviceId, name: '', isActive: isActive);
  }
}
