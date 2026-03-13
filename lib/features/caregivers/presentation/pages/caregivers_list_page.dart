import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/core/widgets/error_state_widget.dart';
import 'package:cwsn/features/caregivers/models/caregiver_sort.dart';
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
    final filter = ref.watch(caregiverFilterProvider);
    final sort = ref.watch(caregiverSortProvider);
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppTopBar(
        title: 'Caregivers',
        actions: [
          // Sort popup
          PopupMenuButton<CaregiverSortOption>(
            icon: const Icon(Icons.sort_rounded),
            initialValue: sort,
            onSelected: (option) {
              ref.read(caregiverSortProvider.notifier).update(option);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: CaregiverSortOption.recommended,
                child: Text('Most Recommended'),
              ),
              PopupMenuItem(
                value: CaregiverSortOption.experience,
                child: Text('Most Experienced'),
              ),
              PopupMenuItem(
                value: CaregiverSortOption.nameAsc,
                child: Text('Name (A-Z)'),
              ),
              PopupMenuItem(
                value: CaregiverSortOption.nameDesc,
                child: Text('Name (Z-A)'),
              ),
            ],
          ),
          // Filter icon with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list_rounded),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const CaregiverFilterSheet(),
                ),
              ),
              if (!filter.isEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${filter.activeCount}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
