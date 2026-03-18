import 'package:cwsn/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton placeholder for a single [ServiceCard] while data loads.
///
/// ## Design
/// Mirrors the exact dimensions of [ServiceCard] (width: 148, same border
/// radius) so the layout does not shift when real cards replace skeletons.
/// Uses the theme's tonal surface colours so it adapts to light/dark mode
/// without hardcoded greys.  No box shadow — consistent with the card aesthetic.
///
/// ## How to extend
/// To add a title-line skeleton at the bottom (matching the gradient overlay),
/// add a [Positioned] widget inside the [Stack] below, anchored to `bottom: 14`.
class ServiceCardSkeleton extends StatelessWidget {
  /// Width kept in sync with [ServiceCard._cardWidth].
  static const double _cardWidth = 148.0;
  static const double _borderRadius = 18.0;

  const ServiceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Pull theme-aware shimmer colours so they work in light and dark mode.
    final baseColor = context.colorScheme.surfaceContainerHighest;
    final highlightColor = context.colorScheme.surfaceContainerHigh;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: _cardWidth,
        decoration: BoxDecoration(
          // Shimmer needs an opaque fill colour to animate over.
          color: baseColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          // Intentionally no boxShadow — matches the real ServiceCard.
        ),
        child: Stack(
          children: [
            // ── Simulated title lines at the bottom ───────────────────────
            Positioned(
              bottom: 14,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Line 1 — wider, simulates the first word of the title.
                  Container(
                    height: 10,
                    width: 90,
                    decoration: BoxDecoration(
                      // White is required: shimmer animates by compositing
                      // over the base/highlight gradient.
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Line 2 — narrower, simulates a second shorter word.
                  Container(
                    height: 10,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
