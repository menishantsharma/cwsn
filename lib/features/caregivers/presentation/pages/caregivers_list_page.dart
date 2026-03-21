import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/core/widgets/error_state_widget.dart';
import 'package:cwsn/core/widgets/modern_refresh_indicator.dart';
import 'package:cwsn/features/caregivers/models/backend_caregiver_filter.dart' show BackendCaregiverSort;
import 'package:cwsn/features/caregivers/presentation/providers/caregiver_providers.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_card.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_card_skeleton.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_filter_sheet.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/backend_caregiver_filter_sheet.dart';
import 'package:cwsn/features/services/models/service_search_result.dart';
import 'package:cwsn/features/services/presentation/providers/services_provider.dart';
import 'package:cwsn/features/caregivers/models/caregiver_list_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CaregiversListPage extends ConsumerWidget {
  /// When set, caregivers are fetched from the backend filtered by this
  /// special need. When null, falls back to the mock list.
  final CaregiverListArgs? args;

  const CaregiversListPage({super.key, this.args});

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
    final specialNeed = args?.specialNeed;

    // If we have a special need context → fetch from backend.
    if (specialNeed != null) {
      return _BackendCaregiversPage(
        specialNeed: specialNeed,
        serviceTitle: args?.serviceTitle,
      );
    }

    // Fallback: mock-based list with filters.
    final caregiversAsync = ref.watch(caregiversListProvider);
    final filter = ref.watch(caregiverFilterProvider);
    final colors = Theme.of(context).colorScheme;
    final badgeCount = filter.activeCount;

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
                if (badgeCount > 0)
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

// ── Backend-powered caregivers page ───────────────────────────────────────────

class _BackendCaregiversPage extends ConsumerWidget {
  final String specialNeed;
  final String? serviceTitle;

  const _BackendCaregiversPage({
    required this.specialNeed,
    this.serviceTitle,
  });

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const BackendCaregiverFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterKey = serviceTitle ?? specialNeed;
    final resultsAsync = ref.watch(caregiversByCategoryProvider(filterKey));
    final filter = ref.watch(backendCaregiverFilterProvider);
    final badgeCount = filter.activeCount;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppTopBar(
        title: serviceTitle ?? specialNeed,
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
                if (badgeCount > 0)
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
      body: resultsAsync.when(
        loading: () => const CaregiverListSkeleton(),
        error: (error, _) => ErrorStateWidget(
          message: 'Failed to load caregivers',
          onRetry: () => ref.invalidate(caregiversByCategoryProvider(filterKey)),
        ),
        data: (results) {
          // Apply client-side sort (backend handles type/payment/gender filters)
          final sorted = _applySortLocally(results, filter.sort);
          return sorted.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.people_outline,
                  title: 'No caregivers found',
                  subtitle: 'Try adjusting your filters',
                )
              : ModernRefreshIndicatorList(
                  onRefresh: () => ref.refresh(
                    caregiversByCategoryProvider(filterKey).future,
                  ),
                  itemCount: sorted.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, index) =>
                      _BackendCaregiverCard(result: sorted[index]),
                );
        },
      ),
    );
  }

  List<ServiceSearchResult> _applySortLocally(
    List<ServiceSearchResult> results,
    BackendCaregiverSort sort,
  ) {
    final list = List<ServiceSearchResult>.from(results);
    switch (sort) {
      case BackendCaregiverSort.nameAsc:
        list.sort(
          (a, b) => (a.caregiverProfile?.name ?? '')
              .compareTo(b.caregiverProfile?.name ?? ''),
        );
      case BackendCaregiverSort.nameDesc:
        list.sort(
          (a, b) => (b.caregiverProfile?.name ?? '')
              .compareTo(a.caregiverProfile?.name ?? ''),
        );
      case BackendCaregiverSort.recommended:
        list.sort(
          (a, b) => (b.caregiverProfile?.upvoteCount ?? 0)
              .compareTo(a.caregiverProfile?.upvoteCount ?? 0),
        );
    }
    return list;
  }
}

// ── Caregiver card built from backend ServiceSearchResult ─────────────────────

class _BackendCaregiverCard extends StatelessWidget {
  final ServiceSearchResult result;
  const _BackendCaregiverCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final profile = result.caregiverProfile;
    final cs = context.colorScheme;
    final tt = context.textTheme;

    if (profile == null) return const SizedBox.shrink();

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                profile.name.isNotEmpty
                    ? profile.name[0].toUpperCase()
                    : '?',
                style: tt.headlineSmall?.copyWith(
                  color: cs.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Qualification
                  Text(
                    profile.qualifications,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Meta row
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (profile.regionName.isNotEmpty)
                        _MetaBadge(
                          icon: Icons.location_on_outlined,
                          label: profile.regionName,
                        ),
                      _MetaBadge(
                        icon: Icons.swap_horiz_rounded,
                        label: result.serviceType,
                      ),
                      _MetaBadge(
                        icon: Icons.payment_outlined,
                        label: result.paymentType,
                      ),
                      if (profile.upvoteCount > 0)
                        _MetaBadge(
                          icon: Icons.thumb_up_outlined,
                          label: '${profile.upvoteCount}',
                          color: const Color(0xFFFF9800),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black12,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _MetaBadge({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.grey.shade500;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: c),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: c,
          ),
        ),
      ],
    );
  }
}
