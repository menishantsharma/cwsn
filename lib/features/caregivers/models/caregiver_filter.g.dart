// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caregiver_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CaregiverFilterImpl _$$CaregiverFilterImplFromJson(
  Map<String, dynamic> json,
) => _$CaregiverFilterImpl(
  gender: json['gender'] as String?,
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  services:
      (json['services'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isAvailable: json['isAvailable'] as bool?,
);

Map<String, dynamic> _$$CaregiverFilterImplToJson(
  _$CaregiverFilterImpl instance,
) => <String, dynamic>{
  'gender': instance.gender,
  'languages': instance.languages,
  'services': instance.services,
  'isAvailable': instance.isAvailable,
};
