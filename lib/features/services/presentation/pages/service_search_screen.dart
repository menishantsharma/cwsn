import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/features/services/models/service_search_result.dart';
import 'package:cwsn/features/services/presentation/providers/services_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Full-screen search experience for the services catalog.
///
/// ## Entry point
/// Navigated to via GoRouter from [ServicesPage]:
/// ```dart
/// context.pushNamed(AppRoutes.serviceSearch)
/// ```
/// Registered as a top-level route (outside the shell) so the bottom
/// navigation bar is never visible on this screen.
///
/// ## Architecture
/// - [serviceSearchQueryProvider] holds the *committed* query — updated only
///   inside `onSubmitted`, never on every keystroke.
/// - [serviceSearchResultsProvider] watches the query and fires the backend.
/// - The [TextEditingController] is local state; it drives the visible text
///   field independently of Riverpod so clearing never causes a rebuild loop.
///
/// ## How to extend
/// - **Recent searches:** watch a `recentSearchesProvider` and render chips
///   in the [_InitialPrompt] body.
/// - **Filters:** add an [IconButton] to [AppTopBar]'s `actions`; write to a
///   filter provider and compose it inside [serviceSearchResultsProvider].
/// - **Pagination:** convert [serviceSearchResultsProvider] to `.family<int>`
///   and add a [ScrollController] listener to load the next page.
class ServiceSearchScreen extends ConsumerStatefulWidget {
  const ServiceSearchScreen({super.key});

  @override
  ConsumerState<ServiceSearchScreen> createState() =>
      _ServiceSearchScreenState();
}

class _ServiceSearchScreenState extends ConsumerState<ServiceSearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Commits the trimmed query to Riverpod — triggers the backend fetch.
  /// Called from `TextField.onSubmitted` only (not on every keystroke).
  void _onSubmitted(String value) =>
      ref.read(serviceSearchQueryProvider.notifier).submit(value);

  /// Wipes the visible text field AND resets the provider query to empty,
  /// bringing the body back to the initial "prompt" state.
  void _onClear() {
    _controller.clear();
    ref.read(serviceSearchQueryProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      // ── Custom AppTopBar with a TextField as its title ─────────────────
      // [titleWidget] overrides the plain-text title while preserving the
      // branded back-button, divider, and background from [AppTopBar].
      appBar: AppTopBar(
        // titleSpacing: 0 makes the TextField flush with the back-button pill.
        titleSpacing: 0,
        titleWidget: TextField(
          controller: _controller,
          autofocus: true, // Keyboard opens immediately when screen pushes.
          textInputAction: TextInputAction.search,
          onSubmitted: _onSubmitted,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Search services…',
            hintStyle: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            // No border — the AppTopBar's divider acts as the visual separator.
            border: InputBorder.none,
            // Clear button appears only when the field has text.
            suffixIcon: ListenableBuilder(
              listenable: _controller,
              builder: (_, _) => _controller.text.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: cs.onSurface.withValues(alpha: 0.45),
                      ),
                      tooltip: 'Clear',
                      onPressed: _onClear,
                    ),
            ),
          ),
        ),
      ),

      body: const _SearchBody(),
    );
  }
}

// ── Body ───────────────────────────────────────────────────────────────────────

/// Watches [serviceSearchQueryProvider] + [serviceSearchResultsProvider] and
/// delegates to the correct child for each state.
class _SearchBody extends ConsumerWidget {
  const _SearchBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(serviceSearchQueryProvider);
    final resultsAsync = ref.watch(serviceSearchResultsProvider);

    // No query submitted yet — show the prompt instead of an empty grid.
    if (query.isEmpty) return const _InitialPrompt();

    return switch (resultsAsync) {
      AsyncLoading() => const _SearchListSkeleton(),
      AsyncError() => _ErrorView(
        onRetry: () => ref.invalidate(serviceSearchResultsProvider),
      ),
      AsyncData(:final value) when value.isEmpty => _NoResultsView(query: query),
      AsyncData(:final value) => _ResultsList(items: value),
    };
  }
}

// ── Skeleton grid ─────────────────────────────────────────────────────────────

/// Shimmer placeholder that exactly mirrors [_ResultsGrid]'s layout so there
/// is zero layout shift when real cards arrive.
class _SearchListSkeleton extends StatelessWidget {
  const _SearchListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => Container(
        height: 120,
        decoration: BoxDecoration(
          color: context.colorScheme.onSurface.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  final List<ServiceSearchResult> items;
  const _ResultsList({required this.items});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              '${items.length} result${items.length == 1 ? '' : 's'} found',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _CaregiverResultCard(result: items[index]),
          ),
        ),
      ],
    );
  }
}

class _CaregiverResultCard extends StatelessWidget {
  final ServiceSearchResult result;
  const _CaregiverResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final profile = result.caregiverProfile;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  result.title,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (result.categoryName != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    result.categoryName!,
                    style: tt.labelSmall?.copyWith(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (profile != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: cs.primaryContainer,
                  child: Text(
                    profile.name.isNotEmpty
                        ? profile.name[0].toUpperCase()
                        : '?',
                    style: tt.titleSmall?.copyWith(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        profile.qualifications,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.55),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _MetaChip(
                  icon: Icons.location_on_outlined,
                  label: profile.regionName,
                ),
                _MetaChip(
                  icon: Icons.swap_horiz_rounded,
                  label: result.serviceType,
                ),
                _MetaChip(
                  icon: Icons.payment_outlined,
                  label: result.paymentType,
                ),
                if (profile.upvoteCount > 0)
                  _MetaChip(
                    icon: Icons.thumb_up_outlined,
                    label: '${profile.upvoteCount}',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: cs.onSurface.withValues(alpha: 0.45)),
        const SizedBox(width: 3),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

// ── Edge-case states ───────────────────────────────────────────────────────────

/// Shown before any query is submitted.
class _InitialPrompt extends StatelessWidget {
  const _InitialPrompt();

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_rounded,
            size: 56,
            color: cs.onSurface.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 14),
          Text(
            'Search for services',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Type a keyword and press Search on your keyboard.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when the backend returned zero matches for [query].
class _NoResultsView extends StatelessWidget {
  final String query;
  const _NoResultsView({required this.query});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: cs.onSurface.withValues(alpha: 0.12),
            ),
            const SizedBox(height: 14),
            Text(
              'No results for "$query"',
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try a different keyword.',
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when [serviceSearchResultsProvider] resolves with an error.
class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: cs.onSurface.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 14),
          Text(
            'Search failed',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: onRetry,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh_rounded, size: 16),
                SizedBox(width: 6),
                Text('Tap to Retry'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
