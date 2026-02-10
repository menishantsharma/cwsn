import 'package:cwsn/core/data/user_data.dart';
import 'package:cwsn/core/models/user_model.dart';

class CaregiverRepository {
  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(seconds: 2));
  }

  Future<List<User>> getCaregiversList() async {
    await _simulateNetworkDelay();
    return caregivers;
    // return mockCaregivers;
  }

  Future<User> getCaregiverDetails(String id) async {
    await _simulateNetworkDelay();
    final user = caregivers.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Caregiver not found'),
    );
    return user;
  }
}
