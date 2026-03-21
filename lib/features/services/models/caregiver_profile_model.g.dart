// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caregiver_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CaregiverProfileImpl _$$CaregiverProfileImplFromJson(
  Map<String, dynamic> json,
) => _$CaregiverProfileImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  age: (json['age'] as num).toInt(),
  gender: json['gender'] as String,
  qualifications: json['qualifications'] as String,
  upvoteCount: (json['upvote_count'] as num?)?.toInt() ?? 0,
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  regionName: json['region_name'] as String? ?? '',
);

Map<String, dynamic> _$$CaregiverProfileImplToJson(
  _$CaregiverProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'age': instance.age,
  'gender': instance.gender,
  'qualifications': instance.qualifications,
  'upvote_count': instance.upvoteCount,
  'languages': instance.languages,
  'region_name': instance.regionName,
};
