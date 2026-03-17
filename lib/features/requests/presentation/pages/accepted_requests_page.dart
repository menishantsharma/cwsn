import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/core/widgets/error_state_widget.dart';
import 'package:cwsn/features/requests/presentation/providers/requests_provider.dart';
import 'package:cwsn/features/requests/presentation/widgets/accepted_request_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcceptedRequestsPage extends ConsumerWidget {
  const AcceptedRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(requestHistoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const AppTopBar(title: 'Request History'),
      body: requestsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => ErrorStateWidget(
          message: 'Failed to load request history',
          onRetry: () =>
              ref.read(requestHistoryProvider.notifier).refresh(),
        ),
        data: (requests) {
          return RefreshIndicator.adaptive(
            onRefresh: () =>
                ref.read(requestHistoryProvider.notifier).refresh(),
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
                      return AcceptedRequestTile(
                        key: ValueKey(request.id),
                        request: request,
                      );
                    },
                  ),
          );
        },
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
          icon: Icons.history_rounded,
          iconSize: 64,
          title: 'No Request History',
          subtitle: 'Accepted and declined requests will appear here.',
        ),
      ],
    );
  }
}
