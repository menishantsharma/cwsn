import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/features/caregivers/models/caregiver_model.dart';
import 'package:flutter/material.dart';

class CaregiverCard extends StatelessWidget {
  final Caregiver caregiver;
  final VoidCallback onCardTap;

  const CaregiverCard({
    super.key,
    required this.onCardTap,
    required this.caregiver,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: onCardTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IMAGE Section
            Expanded(
              child: CachedNetworkImage(
                imageUrl: caregiver.imageUrl,
                fit: BoxFit.cover,
                memCacheHeight: 400,
                placeholder: (_, _) => Container(
                  color: context.colorScheme.surfaceContainerHighest,
                ),
                errorWidget: (_, _, _) => const Icon(Icons.person),
              ),
            ),

            // INFO Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caregiver.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi, size: 16),
                      const SizedBox(width: 8),
                      const Icon(Icons.thumb_up_outlined, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        caregiver.rating.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.65),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
