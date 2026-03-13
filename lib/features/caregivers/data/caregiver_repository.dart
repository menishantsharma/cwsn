import 'package:cwsn/core/data/user_data.dart';
import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the active [CaregiverRepository] implementation.
final caregiverRepositoryProvider = Provider<CaregiverRepository>(
  (ref) => FakeCaregiverRepository(),
);

/// Contract for caregiver listing, detail fetching, and service requests.
abstract class CaregiverRepository {
  Future<List<User>> getCaregiversList();
  Future<User> getCaregiverDetails(String id);
  Future<void> sendRequest({
    required String parentId,
    required String caregiverId,
    required String childId,
  });
}

class FakeCaregiverRepository implements CaregiverRepository {
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<List<User>> getCaregiversList() async {
    await _simulateNetworkDelay();
    return caregivers;
  }

  @override
  Future<User> getCaregiverDetails(String id) async {
    await _simulateNetworkDelay();
    final user = caregivers.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Caregiver not found'),
    );
    return user;
  }

  @override
  Future<void> sendRequest({
    required String parentId,
    required String caregiverId,
    required String childId,
  }) async {
    await _simulateNetworkDelay();
  }
}
