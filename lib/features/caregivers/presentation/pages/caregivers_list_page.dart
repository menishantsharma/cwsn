import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/core/widgets/error_state_widget.dart';
import 'package:cwsn/core/widgets/modern_refresh_indicator.dart';
import 'package:cwsn/features/caregivers/presentation/providers/caregiver_providers.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_card.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_card_skeleton.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CaregiversListPage extends ConsumerWidget {
  const CaregiversListPage({super.key});

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CaregiverFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caregiversAsync = ref.watch(caregiversListProvider);
    final filter = ref.watch(caregiverFilterProvider);
    final colors = Theme.of(context).colorScheme;

    final badgeCount = filter.activeCount;
    final hasActive = badgeCount > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppTopBar(
        title: 'Caregivers',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Sort & Filter',
                  onPressed: () => _openFilterSheet(context),
                ),
                if (hasActive)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$badgeCount',
                          style: TextStyle(
                            fontSize: 10,
                            color: colors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: caregiversAsync.when(
        loading: () => const CaregiverListSkeleton(),
        error: (error, _) => ErrorStateWidget(
          message: 'Failed to load caregivers',
          onRetry: () => ref.invalidate(caregiversListProvider),
        ),
        data: (users) => users.isEmpty
            ? const EmptyStateWidget(
                icon: Icons.people_outline,
                title: 'No caregivers found',
                subtitle: 'Try adjusting your filters',
              )
            : ModernRefreshIndicatorList(
                onRefresh: () => ref.refresh(caregiversListProvider.future),
                itemCount: users.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, index) => CaregiverCard(
                  user: users[index],
                  onCardTap: () => context.pushNamed(
                    AppRoutes.caregiverProfile,
                    extra: users[index].id,
                  ),
                ),
              ),
      ),
    );
  }
}
