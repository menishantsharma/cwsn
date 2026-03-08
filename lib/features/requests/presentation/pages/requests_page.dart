import 'dart:async';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/features/requests/data/requests_repository.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:cwsn/features/requests/presentation/widgets/request_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// 1. DATA PROVIDER (OPTIMISTIC UI)
// ==========================================

final pendingRequestsProvider =
    AsyncNotifierProvider<PendingRequestsNotifier, List<CaregiverRequest>>(
      PendingRequestsNotifier.new,
    );

class PendingRequestsNotifier extends AsyncNotifier<List<CaregiverRequest>> {
  @override
  FutureOr<List<CaregiverRequest>> build() async {
    final repo = ref.read(requestsRepositoryProvider);
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
      throw Exception("Action failed. Please try again.");
    }
  }
}

class RequestsPage extends ConsumerWidget {
  const RequestsPage({super.key});

  void _onAction(
    BuildContext context,
    WidgetRef ref,
    String requestId,
    bool isAccepted,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          isAccepted ? "Request Accepted" : "Request Declined",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isAccepted
            ? Colors.green.shade700
            : Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );

    try {
      await ref
          .read(pendingRequestsProvider.notifier)
          .handleAction(requestId, isAccepted);
    } catch (e) {
      if (context.mounted) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          const SnackBar(
            content: Text("Action failed. Please check your connection."),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(pendingRequestsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppTopBar(
        title: 'Requests',
        actions: [
          IconButton(icon: const Icon(Icons.history_rounded), onPressed: () {}),
        ],
      ),
      body: requestsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),

        error: (error, _) =>
            _ErrorState(onRetry: () => ref.invalidate(pendingRequestsProvider)),

        data: (requests) {
          if (requests.isEmpty) {
            return RefreshIndicator.adaptive(
              onRefresh: () async =>
                  ref.refresh(pendingRequestsProvider.future),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  const _EmptyState(),
                ],
              ),
            );
          }

          return RefreshIndicator.adaptive(
            onRefresh: () async => ref.refresh(pendingRequestsProvider.future),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: requests.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final request = requests[index];
                return RequestTile(
                  key: ValueKey(request.id),
                  request: request,
                  onAccept: () => _onAction(context, ref, request.id, true),
                  onReject: () => _onAction(context, ref, request.id, false),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No Pending Requests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'New bookings will appear here.',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.grey.shade300, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Failed to load requests',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
