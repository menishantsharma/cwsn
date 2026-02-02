import 'package:cwsn/features/services/data/services_data.dart';
import 'package:cwsn/features/services/models/service_model.dart';

class ServiceRepository {
  Future<void> simulateNetworkDelay() async {
    await Future.delayed(Duration(seconds: 2));
  }

  Future<List<ServiceSection>> getServicesList() async {
    await simulateNetworkDelay();
    return mockServiceSections;
  }
}