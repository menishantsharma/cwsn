import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:flutter/material.dart';

/// A tappable card representing a single [ServiceItem].
///
/// Layout: text-first — service name and a subtle arrow on the left,
/// a small rounded image thumbnail on the right. The image is an accent,
/// not the hero. Gives a breathable, readable feel in both the horizontal
/// scroll list and the category grid.
class ServiceCard extends StatelessWidget {
  final ServiceItem item;
  final VoidCallback onTap;

  static const double _defaultWidth = 200.0;
  static const double _borderRadius = 16.0;

  /// Width of the card. Defaults to [_defaultWidth] for the horizontal
  /// scroll list. Pass `double.infinity` when placing the card inside a
  /// grid cell (e.g. category page or search results).
  final double? width;

  const ServiceCard({
    super.key,
    required this.item,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return SizedBox(
      width: width ?? _defaultWidth,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
              border: Border.all(
                color: context.colorScheme.outlineVariant.withValues(
                  alpha: 0.6,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Text side ───────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                          letterSpacing: -0.2,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ── "Explore" chip ─────────────────────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Explore',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: primary,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 10,
                              color: primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // ── Image thumbnail ─────────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CachedNetworkImage(
                      imageUrl: item.imgUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => ColoredBox(
                        color: context.colorScheme.surfaceContainerHighest,
                      ),
                      errorWidget: (_, _, _) => ColoredBox(
                        color: context.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: context.colorScheme.outline,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
