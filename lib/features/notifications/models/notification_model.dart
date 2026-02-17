import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// Defines the category of notification to determine UI icons and routing.
enum NotificationType {
  @JsonValue('message')
  message,          // Chat messages
  @JsonValue('requestReceived')
  requestReceived,  // CAREGIVER: Parent sent a new request
  @JsonValue('requestAccepted')
  requestAccepted,  // PARENT: Caregiver accepted the request
  @JsonValue('alert')
  alert,            // Safety or urgent alerts
  @JsonValue('system')
  system,           // App updates or account info
}

@freezed
class NotificationItem with _$NotificationItem {
  // Added an empty private constructor to allow for custom getters if needed later
  const NotificationItem._();

  const factory NotificationItem({
    required String id,
    required String title,
    required String subtitle,
    
    // Default image if none is provided (e.g., a system logo)
    @Default('https://example.com/default_notification.png') String imageUrl,
    
    required DateTime timestamp,
    
    @Default(false) bool isRead,
    
    @Default(NotificationType.system) NotificationType type,
    
    /// The ID of the related object (e.g., a CaregiverID or ChatID).
    /// Used for deep-linking when the user taps the notification.
    String? relatedId,
  }) = _NotificationItem;

  /// Handles conversion from JSON (Backend API) to our Flutter model
  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}