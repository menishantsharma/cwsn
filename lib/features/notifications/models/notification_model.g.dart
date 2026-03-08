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
  timestamp: DateTime.parse(json['timestamp'] as String),
  isRead: json['isRead'] as bool? ?? false,
  type:
      $enumDecodeNullable(_$NotificationTypeEnumMap, json['type']) ??
      NotificationType.unknown,
  imageUrl: json['imageUrl'] as String?,
  relatedId: json['relatedId'] as String?,
  payload: json['payload'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$NotificationItemImplToJson(
  _$NotificationItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'timestamp': instance.timestamp.toIso8601String(),
  'isRead': instance.isRead,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'imageUrl': instance.imageUrl,
  'relatedId': instance.relatedId,
  'payload': instance.payload,
};

const _$NotificationTypeEnumMap = {
  NotificationType.message: 'message',
  NotificationType.requestReceived: 'requestReceived',
  NotificationType.requestAccepted: 'requestAccepted',
  NotificationType.alert: 'alert',
  NotificationType.system: 'system',
  NotificationType.unknown: 'unknown',
};
