import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/router/app_router.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_card.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_filter_sheet.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ==========================================
// 1. LOCAL PROVIDERS
// ==========================================

// Automatically fetches and caches the caregivers list.
final caregiversListProvider = FutureProvider.autoDispose<List<User>>((
  ref,
) async {
  final repo = ref.read(caregiverRepositoryProvider);
  return await repo.getCaregiversList();
});

// ==========================================
// 2. THE UI WIDGET
// ==========================================

class CaregiversListPage extends ConsumerWidget {
  const CaregiversListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // OPTIMIZED: Watch the cached FutureProvider
    final caregiversAsync = ref.watch(caregiversListProvider);

    return PillScaffold(
      title: 'Caregivers',
      actionIcon: Icons.filter_list_rounded,
      onActionPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => const CaregiverFilterSheet(),
        );
      },

      // OPTIMIZED: Clean .when() handles all 3 states perfectly
      body: (context, padding) => caregiversAsync.when(
        // --- LOADING STATE ---
        loading: () => ListView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // Prevent weird scrolling while loading
          padding: padding.copyWith(left: 20, right: 20, bottom: 20),
          itemCount: 6,
          itemBuilder: (_, _) => const CaregiverSkeletonCard()
              .animate(onPlay: (loop) => loop.repeat())
              .shimmer(
                duration: 1200.ms,
                color: const Color(0xFFEBEBF4),
                angle: 0.5,
              ),
        ),

        // --- ERROR STATE ---
        error: (error, stack) => Center(
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
                'Failed to load caregivers',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                // Allows the user to try fetching the data again
                onPressed: () => ref.invalidate(caregiversListProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Retry"),
              ),
            ],
          ),
        ),

        // --- SUCCESS DATA STATE ---
        data: (users) {
          if (users.isEmpty) {
            // OPTIMIZED: Wrapped in RefreshIndicator so you can pull-to-refresh even when empty
            return RefreshIndicator(
              onRefresh: () async => ref.refresh(caregiversListProvider.future),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2,
                ),
                children: const [_EmptyCaregiversState()],
              ),
            );
          }

          // OPTIMIZED: Pull-to-Refresh added natively
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(caregiversListProvider.future),
            color: Theme.of(context).primaryColor,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: padding.copyWith(left: 20, right: 20, bottom: 100),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return CaregiverCard(
                      key: ValueKey(
                        user.id,
                      ), // Keeps Flutter's rendering efficient
                      user: user,
                      onCardTap: () => context.pushNamed(
                        AppRoutes.caregiverProfile,
                        extra: user.id,
                      ),
                    )
                    // OPTIMIZED: Staggered waterfall entrance animation
                    .animate()
                    .fade(duration: 400.ms, delay: (50 * index).ms)
                    .slideY(
                      begin: 0.1, // Reduced for a smoother, less jarring slide
                      end: 0,
                      duration: 400.ms,
                      curve: Curves.easeOutQuad,
                      delay: (50 * index).ms,
                    );
              },
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// OPTIMIZED: EXTRACTED STATELESS WIDGETS
// ==========================================

// OPTIMIZED: Moved out of the main class so Flutter can cache it as a `const` widget
class _EmptyCaregiversState extends StatelessWidget {
  const _EmptyCaregiversState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No caregivers found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters to see more results.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    ).animate().fade().scale(
      begin: const Offset(0.9, 0.9),
      curve: Curves.easeOutBack,
    );
  }
}
