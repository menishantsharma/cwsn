import 'dart:async'; // Required for FutureOr
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/requests/data/requests_repository.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:cwsn/features/requests/presentation/widgets/request_tile.dart';
import 'package:cwsn/features/requests/presentation/widgets/request_tile_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// 1. LOCAL PROVIDERS & CONTROLLERS
// ==========================================

// FIXED: Removed .autoDispose to fix compiler bounds error.
// Using PendingRequestsNotifier.new is the modern, preferred Riverpod syntax.
final pendingRequestsProvider =
    AsyncNotifierProvider<PendingRequestsNotifier, List<CaregiverRequest>>(
      PendingRequestsNotifier.new,
    );

// FIXED: Extended standard AsyncNotifier
class PendingRequestsNotifier extends AsyncNotifier<List<CaregiverRequest>> {
  @override
  // FIXED: Changed Future to FutureOr to strictly match Riverpod's expected signature
  FutureOr<List<CaregiverRequest>> build() async {
    final repo = ref.read(requestsRepositoryProvider);
    final allRequests = await repo.getRequests();
    return allRequests.where((r) => r.status == RequestStatus.pending).toList();
  }

  /// Handles accepting or rejecting a request with Optimistic UI updates
  Future<void> handleAction(String requestId, bool isAccepted) async {
    final previousState = state;
    final currentList = state.value ?? [];

    final requestIndex = currentList.indexWhere((r) => r.id == requestId);
    if (requestIndex == -1) return;

    // Optimistic Update: Instantly remove the item from the UI state
    // final removedItem = currentList[requestIndex];
    final newList = List<CaregiverRequest>.from(currentList)
      ..removeAt(requestIndex);
    state = AsyncData(newList);

    try {
      // Call Backend API
      final repo = ref.read(requestsRepositoryProvider);
      if (isAccepted) {
        await repo.acceptRequest(requestId);
      } else {
        await repo.rejectRequest(requestId);
      }
    } catch (e) {
      // Rollback if API fails
      state = previousState;
      throw Exception("Action failed. Please try again.");
    }
  }
}

// ==========================================
// 2. THE UI WIDGET
// ==========================================

class RequestsPage extends ConsumerWidget {
  const RequestsPage({super.key});

  // Moves the Snackbar logic out of the build method to keep it clean
  void _onAction(
    BuildContext context,
    WidgetRef ref,
    String requestId,
    bool isAccepted,
  ) async {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.clearSnackBars();

    // Show Optimistic Success Snackbar immediately
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
      // Tell the Notifier to handle the API and state logic
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
    // Watch the AsyncNotifier state
    final requestsAsync = ref.watch(pendingRequestsProvider);

    return PillScaffold(
      title: 'Requests',
      actionIcon: Icons.history_rounded,
      onActionPressed: () {
        // Handle history navigation
      },
      body: (context, padding) => requestsAsync.when(
        // --- LOADING STATE ---
        loading: () => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: padding.copyWith(left: 20, right: 20),
          itemCount: 4,
          itemBuilder: (_, _) => const RequestTileSkeleton()
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
                duration: 1200.ms,
                color: Colors.white.withValues(alpha: 0.5),
              ),
        ),

        // --- ERROR STATE ---
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

        // --- SUCCESS DATA STATE ---
        data: (requests) {
          if (requests.isEmpty) {
            // OPTIMIZED: Wrap empty state in RefreshIndicator so users can pull-to-refresh even when empty
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

          // OPTIMIZED: Pull to refresh logic baked right in
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(pendingRequestsProvider.future),
            color: Theme.of(context).primaryColor,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: padding.copyWith(left: 20, right: 20, bottom: 80),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                return RequestTile(
                      key: ValueKey(
                        request.id,
                      ), // CRITICAL: Locks animation state when items are removed
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
