import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
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
    final caregiversAsync = ref.watch(caregiversListProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: 'Caregivers',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => const CaregiverFilterSheet(),
              );
            },
          ),
        ],
      ),

      body: caregiversAsync.when(
        loading: () => ListView.builder(
          physics:
              const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          itemCount: 6,
          itemBuilder: (_, _) => const CaregiverSkeletonCard()
              .animate(onPlay: (loop) => loop.repeat())
              .shimmer(
                duration: 1200.ms,
                color: const Color(0xFFEBEBF4),
                angle: 0.5,
              ),
        ),

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
                onPressed: () => ref.invalidate(caregiversListProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Retry"),
              ),
            ],
          ),
        ),

        data: (users) {
          if (users.isEmpty) {
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

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(caregiversListProvider.future),
            color: Theme.of(context).primaryColor,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
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
                    .animate()
                    .fade(duration: 400.ms, delay: (50 * index).ms)
                    .slideY(
                      begin: 0.1,
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
