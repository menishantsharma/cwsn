// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceItemImpl _$$ServiceItemImplFromJson(Map<String, dynamic> json) =>
    _$ServiceItemImpl(
      title: json['title'] as String,
      imgUrl: json['imgUrl'] as String,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$$ServiceItemImplToJson(_$ServiceItemImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'imgUrl': instance.imgUrl,
      'id': instance.id,
    };

_$ServiceSectionImpl _$$ServiceSectionImplFromJson(Map<String, dynamic> json) =>
    _$ServiceSectionImpl(
      title: json['title'] as String,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ServiceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ServiceSectionImplToJson(
  _$ServiceSectionImpl instance,
) => <String, dynamic>{'title': instance.title, 'items': instance.items};
