import 'dart:async';
import 'package:cwsn/features/requests/data/requests_repository.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pendingRequestsProvider =
    AsyncNotifierProvider<PendingRequestsNotifier, List<CaregiverRequest>>(
      PendingRequestsNotifier.new,
    );

class PendingRequestsNotifier extends AsyncNotifier<List<CaregiverRequest>> {
  @override
  FutureOr<List<CaregiverRequest>> build() async {
    final repo = ref.watch(requestsRepositoryProvider);
    final allRequests = await repo.getRequests();

    return allRequests.where((r) => r.status == RequestStatus.pending).toList();
  }

  Future<void> handleAction(String requestId, bool isAccepted) async {
    final previousState = state.value ?? [];
    state = AsyncData(previousState.where((r) => r.id != requestId).toList());

    try {
      final repo = ref.read(requestsRepositoryProvider);
      if (isAccepted) {
        await repo.acceptRequest(requestId);
      } else {
        await repo.rejectRequest(requestId);
      }
    } catch (e) {
      state = AsyncData(previousState);
      rethrow;
    }
  }

  Future<void> refresh() async {
    return ref.invalidateSelf();
  }
}
