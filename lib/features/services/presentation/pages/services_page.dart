import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/features/services/data/services_repository.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:cwsn/features/services/presentation/widgets/horizontal_service_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final servicesListProvider = FutureProvider.autoDispose<List<ServiceSection>>((
  ref,
) async {
  return ref.watch(serviceRepositoryProvider).getServicesList();
});

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const AppTopBar(title: 'Services', showBackButton: false),
      body: servicesAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),

        error: (error, _) =>
            _ErrorState(onRetry: () => ref.invalidate(servicesListProvider)),

        data: (sections) {
          if (sections.isEmpty) return const _EmptyState();

          return RefreshIndicator.adaptive(
            onRefresh: () => ref.refresh(servicesListProvider.future),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24),
              itemCount: sections.length,
              itemBuilder: (_, index) =>
                  HorizontalServiceRow(section: sections[index]),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.grey.shade300, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Failed to load services',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.category_outlined, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No services available',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check back later.',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
