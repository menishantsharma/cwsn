// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String?,
  imageUrl:
      json['imageUrl'] as String? ??
      'https://randomuser.me/api/portraits/lego/1.jpg',
  location: json['location'] as String?,
  email: json['email'] as String? ?? 'abc@example.com',
  isGuest: json['isGuest'] as bool? ?? false,
  phoneNumber: json['phoneNumber'] as String?,
  gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
  activeRole: $enumDecodeNullable(_$UserRoleEnumMap, json['activeRole']),
  token: json['token'] as String?,
  caregiverProfile: json['caregiverProfile'] == null
      ? null
      : CaregiverProfile.fromJson(
          json['caregiverProfile'] as Map<String, dynamic>,
        ),
  parentProfile: json['parentProfile'] == null
      ? null
      : ParentModel.fromJson(json['parentProfile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'imageUrl': instance.imageUrl,
      'location': instance.location,
      'email': instance.email,
      'isGuest': instance.isGuest,
      'phoneNumber': instance.phoneNumber,
      'gender': _$GenderEnumMap[instance.gender],
      'activeRole': _$UserRoleEnumMap[instance.activeRole],
      'token': instance.token,
      'caregiverProfile': instance.caregiverProfile,
      'parentProfile': instance.parentProfile,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};

const _$UserRoleEnumMap = {
  UserRole.parent: 'parent',
  UserRole.caregiver: 'caregiver',
};

_$ChildModelImpl _$$ChildModelImplFromJson(Map<String, dynamic> json) =>
    _$ChildModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
    );

Map<String, dynamic> _$$ChildModelImplToJson(_$ChildModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gender': _$GenderEnumMap[instance.gender]!,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
    };

_$ParentModelImpl _$$ParentModelImplFromJson(Map<String, dynamic> json) =>
    _$ParentModelImpl(
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => ChildModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      joinedDate: json['joinedDate'] == null
          ? null
          : DateTime.parse(json['joinedDate'] as String),
    );

Map<String, dynamic> _$$ParentModelImplToJson(_$ParentModelImpl instance) =>
    <String, dynamic>{
      'children': instance.children,
      'joinedDate': instance.joinedDate?.toIso8601String(),
    };

_$CaregiverProfileImpl _$$CaregiverProfileImplFromJson(
  Map<String, dynamic> json,
) => _$CaregiverProfileImpl(
  about: json['about'] as String? ?? '',
  services:
      (json['services'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isVerified: json['isVerified'] as bool? ?? false,
  isAvailable: json['isAvailable'] as bool? ?? true,
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  joinedDate: json['joinedDate'] == null
      ? null
      : DateTime.parse(json['joinedDate'] as String),
  yearsOfExperience: (json['yearsOfExperience'] as num?)?.toInt() ?? 0,
  totalRecommendations: (json['totalRecommendations'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$CaregiverProfileImplToJson(
  _$CaregiverProfileImpl instance,
) => <String, dynamic>{
  'about': instance.about,
  'services': instance.services,
  'isVerified': instance.isVerified,
  'isAvailable': instance.isAvailable,
  'languages': instance.languages,
  'joinedDate': instance.joinedDate?.toIso8601String(),
  'yearsOfExperience': instance.yearsOfExperience,
  'totalRecommendations': instance.totalRecommendations,
};
