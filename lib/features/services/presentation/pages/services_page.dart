import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/core/widgets/error_state_widget.dart';
import 'package:cwsn/core/widgets/modern_refresh_indicator.dart';
import 'package:cwsn/features/services/presentation/providers/services_provider.dart';
import 'package:cwsn/features/services/presentation/widgets/horizontal_service_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        error: (error, _) => ErrorStateWidget(
          message: 'Failed to load services',
          onRetry: () => ref.invalidate(servicesListProvider),
        ),
        data: (sections) => sections.isEmpty
            ? const EmptyStateWidget(
                icon: Icons.category_outlined,
                title: 'No services available',
                subtitle: 'Please check back later.',
              )
            : ModernRefreshIndicatorList(
                onRefresh: () => ref.refresh(servicesListProvider.future),
                itemCount: sections.length,
                padding: const EdgeInsets.symmetric(vertical: 24),
                itemBuilder: (_, index) =>
                    HorizontalServiceRow(section: sections[index]),
              ),
      ),
    );
  }
}
