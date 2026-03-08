import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@JsonEnum()
enum NotificationType {
  @JsonValue('message')
  message,
  @JsonValue('requestReceived')
  requestReceived,
  @JsonValue('requestAccepted')
  requestAccepted,
  @JsonValue('alert')
  alert,
  @JsonValue('system')
  system,
  @JsonValue('unknown')
  unknown,
}

@freezed
class NotificationItem with _$NotificationItem {
  const NotificationItem._();

  const factory NotificationItem({
    required String id,
    required String title,
    required String subtitle,
    required DateTime timestamp,

    @Default(false) bool isRead,

    @Default(NotificationType.unknown) NotificationType type,

    String? imageUrl,
    String? relatedId,
    Map<String, dynamic>? payload,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
