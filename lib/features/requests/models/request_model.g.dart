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
  parentName: json['parentName'] as String,
  parentImageUrl:
      json['parentImageUrl'] as String? ??
      'https://example.com/placeholder.png',
  parentLocation: json['parentLocation'] as String,
  childName: json['childName'] as String,
  childAge: (json['childAge'] as num).toInt(),
  childGender: json['childGender'] as String,
  specialNeed: json['specialNeed'] as String,
  serviceName: json['serviceName'] as String,
  status:
      $enumDecodeNullable(_$RequestStatusEnumMap, json['status']) ??
      RequestStatus.pending,
);

Map<String, dynamic> _$$CaregiverRequestImplToJson(
  _$CaregiverRequestImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'parentId': instance.parentId,
  'parentName': instance.parentName,
  'parentImageUrl': instance.parentImageUrl,
  'parentLocation': instance.parentLocation,
  'childName': instance.childName,
  'childAge': instance.childAge,
  'childGender': instance.childGender,
  'specialNeed': instance.specialNeed,
  'serviceName': instance.serviceName,
  'status': _$RequestStatusEnumMap[instance.status]!,
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.accepted: 'accepted',
  RequestStatus.rejected: 'rejected',
};
