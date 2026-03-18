import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/core/widgets/error_state_widget.dart';
import 'package:cwsn/core/widgets/modern_refresh_indicator.dart';
import 'package:cwsn/features/requests/presentation/providers/requests_provider.dart';
import 'package:cwsn/features/requests/presentation/widgets/request_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RequestsPage extends ConsumerWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(pendingRequestsProvider);

    ref.listen(pendingRequestsProvider, (_, next) {
      if (next.hasError && !next.isLoading) {
        _feedback(context, 'Action failed. Request restored.', isError: true);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppTopBar(
        title: 'Requests',
        actions: [
          IconButton(
            tooltip: 'History',
            icon: const Icon(Icons.history_rounded, size: 22),
            onPressed: () => context.pushNamed(AppRoutes.acceptedRequests),
          ),
        ],
      ),
      body: requestsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (_, _) => ErrorStateWidget(
          message: 'Failed to load requests',
          onRetry: () => ref.read(pendingRequestsProvider.notifier).refresh(),
        ),
        data: (requests) => ModernRefreshIndicatorList(
          onRefresh: () =>
              ref.read(pendingRequestsProvider.notifier).refresh(),
          itemCount: requests.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          emptyWidget: Column(
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.25),
              const EmptyStateWidget(
                icon: Icons.inbox_outlined,
                iconSize: 56,
                title: 'No Pending Requests',
                subtitle: 'New bookings will appear here.',
              ),
            ],
          ),
          itemBuilder: (_, index) {
            final r = requests[index];
            return RequestTile(
              key: ValueKey(r.id),
              request: r,
              onAccept: () => _act(context, ref, r.id, true),
              onReject: () => _act(context, ref, r.id, false),
            );
          },
        ),
      ),
    );
  }

  void _act(BuildContext context, WidgetRef ref, String id, bool accepted) {
    HapticFeedback.mediumImpact();
    _feedback(
      context,
      accepted ? 'Request accepted' : 'Request declined',
      accepted: accepted,
    );
    ref.read(pendingRequestsProvider.notifier).handleAction(id, accepted);
  }

  void _feedback(
    BuildContext context,
    String message, {
    bool isError = false,
    bool accepted = false,
  }) {
    final m = ScaffoldMessenger.of(context)..clearSnackBars();
    m.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: isError
            ? Colors.black87
            : (accepted ? Colors.green.shade600 : Colors.redAccent),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
