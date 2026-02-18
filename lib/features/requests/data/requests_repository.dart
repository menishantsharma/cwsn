import 'dart:math';

import 'package:cwsn/features/requests/data/requests_data.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestRepositoryProvider = Provider((ref) => RequestsRepository());

class RequestsRepository {
  Future<List<CaregiverRequest>> getRequests() async {
    await Future.delayed(Duration(seconds: 1));
    return mockRequests;
  }

  Future<void> acceptRequest(String requestId) async {
    await Future.delayed(Duration(seconds: 1));

    if (Random().nextDouble() < 0.5) {
      throw Exception("Simulated Backend Error: Could not accept request.");
    }
  }

  Future<void> rejectRequest(String requestId) async {
    await Future.delayed(Duration(seconds: 1));

    if (Random().nextDouble() < 0.5) {
      throw Exception("Simulated Backend Error: Could not reject request.");
    }
  }
}
