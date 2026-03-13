import 'package:cwsn/features/requests/data/requests_data.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the active [RequestsRepository] implementation.
final requestsRepositoryProvider = Provider((ref) => FakeRequestsRepository());

/// Contract for fetching and mutating caregiver service requests.
abstract class RequestsRepository {
  Future<List<CaregiverRequest>> getRequests();
  Future<void> acceptRequest(String requestId);
  Future<void> rejectRequest(String requestId);
}

class FakeRequestsRepository implements RequestsRepository {
  List<CaregiverRequest>? _db;

  @override
  Future<List<CaregiverRequest>> getRequests() async {
    await Future.delayed(const Duration(seconds: 1));
    _db ??= List.from(mockRequests);
    return _db!;
  }

  @override
  Future<void> acceptRequest(String requestId) async {
    await Future.delayed(const Duration(seconds: 1));
    _updateStatus(requestId, RequestStatus.accepted);
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    await Future.delayed(const Duration(seconds: 1));
    _updateStatus(requestId, RequestStatus.rejected);
  }

  void _updateStatus(String id, RequestStatus newStatus) {
    if (_db == null) return;
    final index = _db!.indexWhere((r) => r.id == id);
    if (index != -1) {
      _db![index] = _db![index].copyWith(status: newStatus);
    }
  }
}
