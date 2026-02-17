// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationItemImpl _$$NotificationItemImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationItemImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  subtitle: json['subtitle'] as String,
  imageUrl:
      json['imageUrl'] as String? ??
      'https://example.com/default_notification.png',
  timestamp: DateTime.parse(json['timestamp'] as String),
  isRead: json['isRead'] as bool? ?? false,
  type:
      $enumDecodeNullable(_$NotificationTypeEnumMap, json['type']) ??
      NotificationType.system,
  relatedId: json['relatedId'] as String?,
);

Map<String, dynamic> _$$NotificationItemImplToJson(
  _$NotificationItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'imageUrl': instance.imageUrl,
  'timestamp': instance.timestamp.toIso8601String(),
  'isRead': instance.isRead,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'relatedId': instance.relatedId,
};

const _$NotificationTypeEnumMap = {
  NotificationType.message: 'message',
  NotificationType.requestReceived: 'requestReceived',
  NotificationType.requestAccepted: 'requestAccepted',
  NotificationType.alert: 'alert',
  NotificationType.system: 'system',
};
