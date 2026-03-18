import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/core/widgets/error_state_widget.dart';
import 'package:cwsn/core/widgets/modern_refresh_indicator.dart';
import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/services/presentation/providers/services_provider.dart';
import 'package:cwsn/features/services/presentation/widgets/horizontal_service_row.dart';
import 'package:cwsn/features/services/presentation/widgets/horizontal_service_row_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The top-level Services page.
///
/// Watches [servicesListProvider] and delegates rendering to one of three
/// states: loading skeleton, error view, or the live section list.
///
/// ## Scaffold boundary
/// This widget owns the [Scaffold], [AppBar], and background colour.
/// The body content is handled by [_ServicesBody] below — keep those
/// two concerns separate so the body can be tested in isolation.
///
/// ## How to extend
/// - Add a search bar above the list: insert it as a `slivers` header inside
///   [ModernRefreshIndicatorList] (or switch to a [CustomScrollView]).
/// - Add category filter chips: pass a selected-category state down to
///   [_ServicesBody] and filter `sections` before building the list.
class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(
      // ignore: avoid_dynamic_calls
      currentUserProvider.select((s) => s.value?.activeRole),
    );
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppTopBar(
        title: 'Services',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search services',
            onPressed: () => context.pushNamed(AppRoutes.serviceSearch),
          ),
        ],
      ),
      body: _ServicesBody(key: ValueKey(role)),
    );
  }
}

/// Handles the three async states for the services catalog.
///
/// Extracted so [ServicesPage] stays lean and this widget can be
/// unit-tested / widget-tested independently.
class _ServicesBody extends ConsumerWidget {
  const _ServicesBody({super.key});

  // Number of skeleton rows shown during the initial load.
  static const int _skeletonRowCount = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesListProvider);

    // Dart 3 switch expression — maps each AsyncValue state to its widget.
    // To add a new state (e.g. a "stale" banner), add a case here.
    return switch (servicesAsync) {
      // ── Loading ──────────────────────────────────────────────────────────
      // Show a skeleton list that exactly mirrors the real layout so there
      // is zero layout shift when data arrives.
      AsyncLoading() => _buildSkeleton(),

      // ── Error ────────────────────────────────────────────────────────────
      AsyncError() => ErrorStateWidget(
        message: 'Failed to load services',
        onRetry: () => ref.invalidate(servicesListProvider),
      ),

      // ── Data ─────────────────────────────────────────────────────────────
      AsyncData(:final value) => value.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.category_outlined,
              title: 'No services available',
              subtitle: 'Check back later for new services.',
            )
          : ModernRefreshIndicatorList(
              onRefresh: () => ref.refresh(servicesListProvider.future),
              itemCount: value.length,
              padding: const EdgeInsets.symmetric(vertical: 24),
              itemBuilder: (_, index) =>
                  HorizontalServiceRow(section: value[index]),
            ),

    };
  }

  /// Builds a non-scrollable column of [HorizontalServiceRowSkeleton] widgets.
  ///
  /// Wrapped in a [SingleChildScrollView] so it fills the screen correctly
  /// on very small devices without causing overflow.
  Widget _buildSkeleton() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: List.generate(
          _skeletonRowCount,
          (_) => const HorizontalServiceRowSkeleton(),
        ),
      ),
    );
  }
}
