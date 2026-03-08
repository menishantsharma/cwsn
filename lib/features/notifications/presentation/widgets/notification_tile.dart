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
    final bool isUnread = !notification.isRead;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child:
                      notification.imageUrl != null &&
                          notification.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: notification.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => _buildFallbackIcon(),
                        )
                      : _buildFallbackIcon(),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: isUnread
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black87,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(notification.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: isUnread
                                ? const Color(0xFFE53935)
                                : Colors.grey.shade500,
                            fontWeight: isUnread
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isUnread ? Colors.black87 : Colors.grey.shade600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              if (isUnread)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 6),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Icon(
      Icons.notifications_outlined,
      color: Colors.grey.shade400,
      size: 24,
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inDays < 1) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';

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
