// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RemoteServiceImpl _$$RemoteServiceImplFromJson(Map<String, dynamic> json) =>
    _$RemoteServiceImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String?,
      categoryName: json['category_name'] as String?,
      serviceType: json['service_type'] as String,
      paymentType: json['payment_type'] as String,
      isActive: json['is_active'] as bool,
      targetAgeMin: (json['target_age_min'] as num?)?.toInt(),
      targetAgeMax: (json['target_age_max'] as num?)?.toInt(),
      targetGender: json['target_gender'] as String,
      maxParticipants: (json['max_participants'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RemoteServiceImplToJson(_$RemoteServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'category_name': instance.categoryName,
      'service_type': instance.serviceType,
      'payment_type': instance.paymentType,
      'is_active': instance.isActive,
      'target_age_min': instance.targetAgeMin,
      'target_age_max': instance.targetAgeMax,
      'target_gender': instance.targetGender,
      'max_participants': instance.maxParticipants,
    };
