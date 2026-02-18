import 'dart:math';

import 'package:cwsn/features/requests/data/requests_data.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestsRepositoryProvider = Provider((ref) => FakeRequestsRepository());

abstract class RequestsRepository {
  Future<List<CaregiverRequest>> getRequests();
  Future<void> acceptRequest(String requestId);
  Future<void> rejectRequest(String requestId);
}

class FakeRequestsRepository implements RequestsRepository {
  @override
  Future<List<CaregiverRequest>> getRequests() async {
    await Future.delayed(Duration(seconds: 1));
    return mockRequests;
  }

  @override
  Future<void> acceptRequest(String requestId) async {
    await Future.delayed(Duration(seconds: 1));

    if (Random().nextDouble() < 0.5) {
      throw Exception("Simulated Backend Error: Could not accept request.");
    }
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    await Future.delayed(Duration(seconds: 1));

    if (Random().nextDouble() < 0.5) {
      throw Exception("Simulated Backend Error: Could not reject request.");
    }
  }
}
