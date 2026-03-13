import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/core/widgets/error_state_widget.dart';
import 'package:cwsn/features/caregivers/presentation/providers/caregiver_providers.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_card.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CaregiversListPage extends ConsumerWidget {
  const CaregiversListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caregiversAsync = ref.watch(caregiversListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppTopBar(
        title: 'Caregivers',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const CaregiverFilterSheet(),
            ),
          ),
        ],
      ),
      body: caregiversAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),

        error: (error, _) => ErrorStateWidget(
          message: 'Failed to load caregivers',
          onRetry: () => ref.invalidate(caregiversListProvider),
        ),

        data: (users) {
          if (users.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.people_outline,
              title: 'No caregivers found',
              subtitle: 'Try adjusting your filters',
            );
          }

          return RefreshIndicator.adaptive(
            onRefresh: () => ref.refresh(caregiversListProvider.future),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: users.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return CaregiverCard(
                  user: users[index],
                  onCardTap: () => context.pushNamed(
                    AppRoutes.caregiverProfile,
                    extra: users[index].id,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
