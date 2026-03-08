import 'dart:async'; // Required for FutureOr
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/features/requests/data/requests_repository.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:cwsn/features/requests/presentation/widgets/request_tile.dart';
import 'package:cwsn/features/requests/presentation/widgets/request_tile_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final previousState = state;
    final currentList = state.value ?? [];

    final requestIndex = currentList.indexWhere((r) => r.id == requestId);
    if (requestIndex == -1) return;

    final newList = List<CaregiverRequest>.from(currentList)
      ..removeAt(requestIndex);
    state = AsyncData(newList);

    try {
      final repo = ref.read(requestsRepositoryProvider);
      if (isAccepted) {
        await repo.acceptRequest(requestId);
      } else {
        await repo.rejectRequest(requestId);
      }
    } catch (e) {
      state = previousState;
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
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.clearSnackBars();

    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isAccepted ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              isAccepted ? "Accepted" : "Declined",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: isAccepted ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 70, left: 16, right: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      await ref
          .read(pendingRequestsProvider.notifier)
          .handleAction(requestId, isAccepted);
    } catch (e) {
      if (context.mounted) {
        scaffold.clearSnackBars();
        scaffold.showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 70, left: 16, right: 16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(pendingRequestsProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: 'Requests',
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              // Handle history navigation
            },
          ),
        ],
      ),
      body: requestsAsync.when(
        loading: () => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: 4,
          itemBuilder: (_, _) => const RequestTileSkeleton()
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
                duration: 1200.ms,
                color: Colors.white.withValues(alpha: 0.5),
              ),
        ),

        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                color: Colors.grey.shade400,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load requests',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => ref.invalidate(pendingRequestsProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Retry"),
              ),
            ],
          ),
        ),

        data: (requests) {
          if (requests.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async =>
                  ref.refresh(pendingRequestsProvider.future),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F7FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.inbox_rounded,
                            size: 40,
                            color: Color(0xFF535CE8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Pending Requests',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'New bookings will appear here.',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ).animate().fade().scale(),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(pendingRequestsProvider.future),
            color: Theme.of(context).primaryColor,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                return RequestTile(
                      key: ValueKey(request.id),
                      request: request,
                      onAccept: () => _onAction(context, ref, request.id, true),
                      onReject: () =>
                          _onAction(context, ref, request.id, false),
                    )
                    // Staggered waterfall entrance animation
                    .animate()
                    .fade(duration: 400.ms, delay: (100 * index).ms)
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      delay: (100 * index).ms,
                      curve: Curves.easeOutQuad,
                    );
              },
            ),
          );
        },
      ),
    );
  }
}
