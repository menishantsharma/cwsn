// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceSearchResultImpl _$$ServiceSearchResultImplFromJson(
  Map<String, dynamic> json,
) => _$ServiceSearchResultImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  image: json['image'] as String?,
  categoryName: json['category_name'] as String?,
  serviceType: json['service_type'] as String,
  paymentType: json['payment_type'] as String,
  targetGender: json['target_gender'] as String,
  targetAgeMin: (json['target_age_min'] as num?)?.toInt(),
  targetAgeMax: (json['target_age_max'] as num?)?.toInt(),
  targetDisabilitiesNames:
      (json['target_disabilities_names'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  caregiverProfile: json['caregiver_profile'] == null
      ? null
      : CaregiverProfile.fromJson(
          json['caregiver_profile'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$ServiceSearchResultImplToJson(
  _$ServiceSearchResultImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'image': instance.image,
  'category_name': instance.categoryName,
  'service_type': instance.serviceType,
  'payment_type': instance.paymentType,
  'target_gender': instance.targetGender,
  'target_age_min': instance.targetAgeMin,
  'target_age_max': instance.targetAgeMax,
  'target_disabilities_names': instance.targetDisabilitiesNames,
  'caregiver_profile': instance.caregiverProfile,
};
