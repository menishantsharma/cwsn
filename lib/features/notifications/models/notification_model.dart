enum NotificationType {
  message,
  requestReceived,
  requestAccepted,
  alert,
  system,
}

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;
  final String? relatedId; // Target ID (e.g., Caregiver ID to open profile)

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.timestamp,
    this.isRead = false,
    this.type = NotificationType.system,
    this.relatedId,
  });

  // Essential for updating local state (like marking as read instantly)
  NotificationItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
    String? relatedId,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
    );
  }
}
