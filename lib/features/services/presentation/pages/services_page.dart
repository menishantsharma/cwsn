import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/features/services/data/services_repository.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:cwsn/features/services/presentation/widgets/horizontal_service_row.dart';
import 'package:cwsn/features/services/presentation/widgets/horizontal_service_row_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final servicesListProvider = FutureProvider.autoDispose<List<ServiceSection>>((
  ref,
) async {
  final repository = ref.read(serviceRepositoryProvider);
  return await repository.getServicesList();
});

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesListProvider);

    return Scaffold(
      appBar: AppTopBar(title: 'Services', showBackButton: false),
      body: servicesAsync.when(
        loading: () => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 24),
          itemCount: 3,
          itemBuilder: (_, _) => const HorizontalServiceRowSkeleton()
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                duration: 1200.ms,
                color: Colors.white.withValues(alpha: 0.5),
              ),
        ),

        error: (error, stackTrace) => Center(
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
                'Failed to load services',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => ref.invalidate(servicesListProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Retry"),
              ),
            ],
          ),
        ),

        data: (sections) {
          if (sections.isEmpty) {
            return Center(
              child: Text(
                'No services available right now.',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(servicesListProvider.future);
            },
            color: Theme.of(context).primaryColor,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24),
              itemCount: sections.length,
              itemBuilder: (_, index) {
                final section = sections[index];

                return HorizontalServiceRow(section: section)
                    .animate()
                    .fade(
                      duration: 600.ms,
                      delay: (100 * index).ms,
                      curve: Curves.easeOutQuad,
                    )
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      duration: 500.ms,
                      delay: (100 * index).ms,
                      curve: Curves.easeOutQuad,
                    );
              },
            ),
          );
        },
      ),
    );
  }
}
