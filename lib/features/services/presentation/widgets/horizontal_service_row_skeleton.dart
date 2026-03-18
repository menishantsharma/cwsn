import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/features/services/presentation/widgets/service_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Full-row skeleton that mirrors the layout of [HorizontalServiceRow].
///
/// Shown while [servicesListProvider] is in the loading state.  Rendered
/// for each expected section (default: 3 rows) inside [ServicesPageBody].
///
/// ## Layout contract
/// The [SizedBox] height (180) must stay in sync with [HorizontalServiceRow]'s
/// card list height so the page height does not jump on data arrival.
///
/// ## How to extend
/// - Increase [_skeletonCount] to show more placeholder cards per row.
/// - Animate the shimmer speed by wrapping [Shimmer.fromColors] in a custom
///   [AnimationController] and passing a [period] parameter.
class HorizontalServiceRowSkeleton extends StatelessWidget {
  // Number of skeleton cards shown per row — matches the typical visible count.
  static const int _skeletonCount = 3;

  const HorizontalServiceRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = context.colorScheme.surfaceContainerHighest;
    final highlightColor = context.colorScheme.surfaceContainerHigh;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section title placeholder ──────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 160,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),

        // ── Horizontal card row placeholder ────────────────────────────────
        // Height matches [HorizontalServiceRow]'s SizedBox height exactly.
        SizedBox(
          height: 180,
          child: ListView.separated(
            // Non-scrollable: skeleton is purely visual, not interactive.
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _skeletonCount,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (_, _) => const ServiceCardSkeleton(),
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}
