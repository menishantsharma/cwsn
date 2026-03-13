// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caregiver_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CaregiverServiceImpl _$$CaregiverServiceImplFromJson(
  Map<String, dynamic> json,
) => _$CaregiverServiceImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  specialNeeds:
      (json['specialNeeds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$$CaregiverServiceImplToJson(
  _$CaregiverServiceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'specialNeeds': instance.specialNeeds,
  'isActive': instance.isActive,
};
