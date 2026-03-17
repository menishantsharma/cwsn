import 'package:cached_network_image/cached_network_image.dart';
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
    final primary = Theme.of(context).primaryColor;
    final unread = !notification.isRead;
    final hasImage =
        notification.imageUrl != null && notification.imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: unread ? primary.withValues(alpha: 0.03) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: unread
                ? primary.withValues(alpha: 0.1)
                : Colors.grey.shade100,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon / image
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: hasImage
                    ? Colors.grey.shade50
                    : _typeColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: hasImage
                    ? CachedNetworkImage(
                        imageUrl: notification.imageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => _icon,
                      )
                    : _icon,
              ),
            ),
            const SizedBox(width: 12),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: unread
                                ? FontWeight.w700
                                : FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (unread)
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        _formatTime(notification.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: unread
                          ? Colors.grey.shade700
                          : Colors.grey.shade500,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _typeColor {
    return switch (notification.type) {
      NotificationType.message => Colors.blue,
      NotificationType.requestReceived => Colors.orange,
      NotificationType.requestAccepted => Colors.green,
      NotificationType.alert => Colors.red,
      NotificationType.system => Colors.purple,
      NotificationType.unknown => Colors.grey,
    };
  }

  IconData get _typeIcon {
    return switch (notification.type) {
      NotificationType.message => Icons.chat_bubble_outline_rounded,
      NotificationType.requestReceived => Icons.person_add_alt_1_rounded,
      NotificationType.requestAccepted => Icons.check_circle_outline_rounded,
      NotificationType.alert => Icons.warning_amber_rounded,
      NotificationType.system => Icons.settings_outlined,
      NotificationType.unknown => Icons.notifications_outlined,
    };
  }

  Widget get _icon => Icon(_typeIcon, color: _typeColor, size: 22);

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[time.month - 1]} ${time.day}';
  }
}
