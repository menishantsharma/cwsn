import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/core/widgets/error_state_widget.dart';
import 'package:cwsn/features/requests/presentation/providers/requests_provider.dart';
import 'package:cwsn/features/requests/presentation/widgets/request_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestsPage extends ConsumerWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(pendingRequestsProvider);

    ref.listen(pendingRequestsProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        _showFeedback(
          context,
          "Action failed. The request has been restored.",
          isError: true,
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppTopBar(
        title: 'Service Requests',
        actions: [
          IconButton(
            tooltip: 'Request History',
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              // Navigation to History Page goes here
            },
          ),
        ],
      ),
      body: requestsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),

        error: (error, _) => ErrorStateWidget(
          message: 'Failed to load requests',
          onRetry: () => ref.read(pendingRequestsProvider.notifier).refresh(),
        ),

        data: (requests) {
          return RefreshIndicator.adaptive(
            onRefresh: () =>
                ref.read(pendingRequestsProvider.notifier).refresh(),
            child: requests.isEmpty
                ? _buildEmptyScrollable(context)
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    itemCount: requests.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return RequestTile(
                        key: ValueKey(request.id),
                        request: request,
                        onAccept: () =>
                            _handleAction(context, ref, request.id, true),
                        onReject: () =>
                            _handleAction(context, ref, request.id, false),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  void _handleAction(
    BuildContext context,
    WidgetRef ref,
    String id,
    bool accepted,
  ) {
    HapticFeedback.mediumImpact();

    _showFeedback(context, accepted ? "Request Accepted" : "Request Declined", accepted: accepted);

    ref.read(pendingRequestsProvider.notifier).handleAction(id, accepted);
  }

  void _showFeedback(
    BuildContext context,
    String message, {
    bool isError = false,
    bool accepted = false,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isError
            ? Colors.black87
            : (accepted ? Colors.green.shade700 : Colors.red.shade700),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildEmptyScrollable(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        const EmptyStateWidget(
          icon: Icons.inbox_outlined,
          iconSize: 64,
          title: 'No Pending Requests',
          subtitle: 'New bookings will appear here.',
        ),
      ],
    );
  }
}
