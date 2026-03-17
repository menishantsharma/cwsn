import 'dart:async';
import 'package:cwsn/features/requests/data/requests_repository.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Exposes the list of pending service requests with optimistic accept/reject.
final pendingRequestsProvider =
    AsyncNotifierProvider<PendingRequestsNotifier, List<CaregiverRequest>>(
      PendingRequestsNotifier.new,
    );

/// Filters requests to pending-only and handles accept/reject with rollback.
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
      // Refresh history so the accepted/rejected request appears there.
      ref.invalidate(requestHistoryProvider);
    } catch (e) {
      state = AsyncData(previousState);
      rethrow;
    }
  }

  Future<void> refresh() async {
    return ref.invalidateSelf();
  }
}

/// Exposes accepted and rejected requests (request history).
final requestHistoryProvider =
    AsyncNotifierProvider<RequestHistoryNotifier, List<CaregiverRequest>>(
      RequestHistoryNotifier.new,
    );

class RequestHistoryNotifier extends AsyncNotifier<List<CaregiverRequest>> {
  @override
  FutureOr<List<CaregiverRequest>> build() async {
    final repo = ref.watch(requestsRepositoryProvider);
    final allRequests = await repo.getRequests();
    final history = allRequests
        .where((r) =>
            r.status == RequestStatus.accepted ||
            r.status == RequestStatus.rejected)
        .toList()
      ..sort((a, b) {
        final aTime = a.resolvedAt ?? a.createdAt;
        final bTime = b.resolvedAt ?? b.createdAt;
        return bTime.compareTo(aTime); // most recent first
      });
    return history;
  }

  Future<void> refresh() async => ref.invalidateSelf();
}

/// Derived count of pending requests for badge display.
final pendingRequestCountProvider = Provider<int>((ref) {
  final requests = ref.watch(pendingRequestsProvider).value ?? [];
  return requests.length;
});
