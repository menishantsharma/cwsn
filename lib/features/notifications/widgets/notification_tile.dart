import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: notification.isRead
            ? null
            : context.colorScheme.primary.withValues(alpha: 0.05),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: CachedNetworkImageProvider(
                  notification.caregiver.imageUrl,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${notification.caregiver.name} ${notification.message}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _formatTimeAlgo(notification.timestamp),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatTimeAlgo(DateTime timestamp) {
  final Duration difference = DateTime.now().difference(timestamp);

  if (difference.inDays > 0) return "${difference.inDays}d ago";
  if (difference.inHours > 0) return "${difference.inHours}h ago";
  if (difference.inMinutes > 0) return "${difference.inMinutes}m ago";
  return "Just now";
}
