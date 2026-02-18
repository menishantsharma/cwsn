import 'package:cwsn/core/data/user_data.dart';
import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final caregiverRepositoryProvider = Provider<CaregiverRepository>(
  (ref) => FakeCaregiverRepository(),
);

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
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Future<List<User>> getCaregiversList() async {
    await _simulateNetworkDelay();
    return caregivers;
    // return mockCaregivers;
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
