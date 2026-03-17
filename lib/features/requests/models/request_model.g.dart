// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CaregiverRequestImpl _$$CaregiverRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CaregiverRequestImpl(
  id: json['id'] as String,
  parentId: json['parentId'] as String,
  caregiverId: json['caregiverId'] as String,
  parentName: json['parentName'] as String,
  parentImageUrl: json['parentImageUrl'] as String?,
  parentLocation: json['parentLocation'] as String,
  childName: json['childName'] as String,
  childAge: (json['childAge'] as num).toInt(),
  childGender: json['childGender'] as String,
  specialNeed: json['specialNeed'] as String,
  serviceName: json['serviceName'] as String,
  status:
      $enumDecodeNullable(_$RequestStatusEnumMap, json['status']) ??
      RequestStatus.pending,
  createdAt: DateTime.parse(json['createdAt'] as String),
  resolvedAt: json['resolvedAt'] == null
      ? null
      : DateTime.parse(json['resolvedAt'] as String),
);

Map<String, dynamic> _$$CaregiverRequestImplToJson(
  _$CaregiverRequestImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'parentId': instance.parentId,
  'caregiverId': instance.caregiverId,
  'parentName': instance.parentName,
  'parentImageUrl': instance.parentImageUrl,
  'parentLocation': instance.parentLocation,
  'childName': instance.childName,
  'childAge': instance.childAge,
  'childGender': instance.childGender,
  'specialNeed': instance.specialNeed,
  'serviceName': instance.serviceName,
  'status': _$RequestStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'resolvedAt': instance.resolvedAt?.toIso8601String(),
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.accepted: 'accepted',
  RequestStatus.rejected: 'rejected',
};
