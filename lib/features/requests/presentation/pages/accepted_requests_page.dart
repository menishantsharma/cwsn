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
      appBar: const AppTopBar(title: 'History'),
      body: requestsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (_, _) => ErrorStateWidget(
          message: 'Failed to load history',
          onRetry: () =>
              ref.read(requestHistoryProvider.notifier).refresh(),
        ),
        data: (requests) => RefreshIndicator.adaptive(
          onRefresh: () =>
              ref.read(requestHistoryProvider.notifier).refresh(),
          child: requests.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  children: [
                    SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.25),
                    const EmptyStateWidget(
                      icon: Icons.history_rounded,
                      iconSize: 56,
                      title: 'No History Yet',
                      subtitle:
                          'Accepted and declined requests will appear here.',
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  itemCount: requests.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, index) => AcceptedRequestTile(
                    key: ValueKey(requests[index].id),
                    request: requests[index],
                  ),
                ),
        ),
      ),
    );
  }
}
