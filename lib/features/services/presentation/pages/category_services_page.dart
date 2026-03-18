import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/core/widgets/error_state_widget.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:cwsn/features/services/presentation/providers/services_provider.dart';
import 'package:cwsn/features/services/presentation/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

/// Displays all [ServiceItem]s for a single category in a scrollable,
/// pull-to-refresh grid fetched from the backend.
///
/// ## Navigation
/// Pushed from [HorizontalServiceRow] via:
/// ```dart
/// context.pushNamed(AppRoutes.categoryServices, extra: section)
/// ```
/// The [section] is passed as `extra` to provide the title for the AppBar
/// and to key the [categoryServicesProvider] family.
///
/// ## How to extend
/// - **Sorting/filtering:** Add a scoped provider that transforms the list
///   returned by [categoryServicesProvider] before passing it to the grid.
/// - **Detail navigation:** Replace [AppRoutes.specialNeeds] with a route
///   that accepts `item.id` once detail pages exist.
/// - **Adaptive columns:** Wrap the grid in a [LayoutBuilder] and set
///   `crossAxisCount` based on `constraints.maxWidth`.
class CategoryServicesPage extends ConsumerWidget {
  /// Passed from the parent — used for the AppBar title and provider key.
  final ServiceSection section;

  const CategoryServicesPage({super.key, required this.section});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppTopBar(title: section.title),
      body: _CategoryServicesBody(sectionTitle: section.title),
    );
  }
}

// ── Body ───────────────────────────────────────────────────────────────────────

/// Handles loading / error / data states for the category grid.
///
/// Extracted so [CategoryServicesPage] stays lean and this widget can be
/// tested independently.
class _CategoryServicesBody extends ConsumerWidget {
  final String sectionTitle;

  // Grid layout constants — tweak here to affect the whole page.
  static const int _columns = 2;
  static const double _spacing = 14.0;
  static const double _padding = 16.0;

  // Aspect ratio for each card cell: width / height.
  // Lower = taller cards.  0.85 gives compact, uncluttered tiles.
  static const double _aspectRatio = 0.85;

  const _CategoryServicesBody({required this.sectionTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(categoryServicesProvider(sectionTitle));

    return switch (itemsAsync) {
      // ── Loading ────────────────────────────────────────────────────────────
      AsyncLoading() => _CategoryGridSkeleton(
        columns: _columns,
        spacing: _spacing,
        padding: _padding,
        aspectRatio: _aspectRatio,
      ),

      // ── Error ──────────────────────────────────────────────────────────────
      AsyncError() => ErrorStateWidget(
        message: 'Failed to load services',
        onRetry: () => ref.invalidate(categoryServicesProvider(sectionTitle)),
      ),

      // ── Data ───────────────────────────────────────────────────────────────
      AsyncData(:final value) => value.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.category_outlined,
              title: 'No services available',
              subtitle: 'Check back later for new services.',
            )
          : _CategoryGrid(
              items: value,
              columns: _columns,
              spacing: _spacing,
              padding: _padding,
              aspectRatio: _aspectRatio,
              onRefresh: () =>
                  ref.refresh(categoryServicesProvider(sectionTitle).future),
            ),
    };
  }
}

// ── Live grid ──────────────────────────────────────────────────────────────────

/// Scrollable, pull-to-refresh grid of live [ServiceCard]s.
class _CategoryGrid extends StatelessWidget {
  final List<ServiceItem> items;
  final int columns;
  final double spacing;
  final double padding;
  final double aspectRatio;
  final Future<void> Function() onRefresh;

  const _CategoryGrid({
    required this.items,
    required this.columns,
    required this.spacing,
    required this.padding,
    required this.aspectRatio,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: Colors.white,
      color: Theme.of(context).primaryColor,
      strokeWidth: 2.5,
      displacement: 40,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          // AlwaysScrollable ensures pull-to-refresh works even when the grid
          // doesn't fill the full screen height.
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.all(padding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: aspectRatio,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ServiceCard(
            item: item,
            // TODO: swap for item.id-based route once detail pages exist.
            onTap: () => context.pushNamed(AppRoutes.specialNeeds),
          );
        },
      ),
    );
  }
}

// ── Skeleton grid ──────────────────────────────────────────────────────────────

/// Shimmer placeholder grid shown while [categoryServicesProvider] loads.
///
/// Uses the same layout constants as [_CategoryServicesBody] so there is zero
/// layout shift when real cards replace the skeletons.
class _CategoryGridSkeleton extends StatelessWidget {
  final int columns;
  final double spacing;
  final double padding;
  final double aspectRatio;

  // Total skeleton cells to render — enough to fill a typical screen.
  static const int _cellCount = 8;

  const _CategoryGridSkeleton({
    required this.columns,
    required this.spacing,
    required this.padding,
    required this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlightColor = Theme.of(context).colorScheme.surfaceContainerHigh;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: GridView.builder(
        // Non-scrollable: purely visual placeholder, no interaction needed.
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(padding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: aspectRatio,
        ),
        itemCount: _cellCount,
        itemBuilder: (_, _) => Container(
          decoration: BoxDecoration(
            // White required: shimmer composites over base/highlight gradient.
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
