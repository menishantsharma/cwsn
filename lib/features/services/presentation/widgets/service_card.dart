import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:flutter/material.dart';

/// A tappable card representing a single [ServiceItem].
///
/// ## Design
/// Uses a full-bleed image with a bottom gradient overlay for the title,
/// a subtle `outlineVariant` border, and no box shadow — keeping the
/// aesthetic clean and uncluttered on any background.
///
/// ## How to extend
/// - Add a `badge` parameter (e.g. `Widget? badge`) and position it at
///   `Alignment.topRight` inside the [Stack] to show "New" or "Popular" tags.
/// - Pass `item.id` to the `onTap` callback to navigate to a detail page.
class ServiceCard extends StatelessWidget {
  /// The service data to display.
  final ServiceItem item;

  /// Called when the user taps the card.
  final VoidCallback onTap;

  // Card dimensions — kept as named constants for easy global tweaks.
  static const double _cardWidth = 148.0;
  static const double _borderRadius = 18.0;

  const ServiceCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _cardWidth,
      child: Material(
        // Use the theme's tonal surface so the card integrates with both
        // light and dark themes without a hardcoded colour.
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(_borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Background image ─────────────────────────────────────────
              _ServiceImage(imgUrl: item.imgUrl),

              // ── Title gradient overlay ────────────────────────────────────
              _TitleOverlay(title: item.title),

              // ── Subtle border drawn on top of everything ──────────────────
              // Rendered as a DecoratedBox so it respects clip and stays sharp.
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  border: Border.all(
                    // outlineVariant is a low-contrast, theme-aware border tone.
                    color: context.colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────────
// Extracted to keep [ServiceCard.build] scannable at a glance.

/// Fills the card with a [CachedNetworkImage], showing a skeleton-toned
/// placeholder while loading and a neutral icon on error.
class _ServiceImage extends StatelessWidget {
  final String imgUrl;
  const _ServiceImage({required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      fit: BoxFit.cover,
      // Placeholder matches the card's tonal surface to avoid a jarring flash.
      placeholder: (_, _) => ColoredBox(
        color: context.colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (_, _, _) => ColoredBox(
        color: context.colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: context.colorScheme.outline,
            size: 28,
          ),
        ),
      ),
    );
  }
}

/// A bottom-anchored gradient band that ensures the white title text is always
/// legible regardless of the image content beneath it.
class _TitleOverlay extends StatelessWidget {
  final String title;
  const _TitleOverlay({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        // Generous top padding grows the gradient fade zone for visual depth.
        padding: const EdgeInsets.fromLTRB(12, 40, 12, 14),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Transparent → rich black so any image stays readable.
            colors: [Colors.transparent, Color(0xCC000000)],
          ),
        ),
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 13,
            height: 1.3,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}
