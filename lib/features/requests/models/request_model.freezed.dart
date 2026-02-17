// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CaregiverRequest _$CaregiverRequestFromJson(Map<String, dynamic> json) {
  return _CaregiverRequest.fromJson(json);
}

/// @nodoc
mixin _$CaregiverRequest {
  String get id =>
      throw _privateConstructorUsedError; // Parent Details (The person paying for the service)
  String get parentId => throw _privateConstructorUsedError;
  String get parentName => throw _privateConstructorUsedError;
  String get parentImageUrl => throw _privateConstructorUsedError;
  String get parentLocation =>
      throw _privateConstructorUsedError; // Child Details (The person receiving the care)
  String get childName => throw _privateConstructorUsedError;
  int get childAge => throw _privateConstructorUsedError;
  String get childGender => throw _privateConstructorUsedError;
  String get specialNeed =>
      throw _privateConstructorUsedError; // Service Context
  String get serviceName => throw _privateConstructorUsedError;
  RequestStatus get status => throw _privateConstructorUsedError;

  /// Serializes this CaregiverRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaregiverRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaregiverRequestCopyWith<CaregiverRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaregiverRequestCopyWith<$Res> {
  factory $CaregiverRequestCopyWith(
    CaregiverRequest value,
    $Res Function(CaregiverRequest) then,
  ) = _$CaregiverRequestCopyWithImpl<$Res, CaregiverRequest>;
  @useResult
  $Res call({
    String id,
    String parentId,
    String parentName,
    String parentImageUrl,
    String parentLocation,
    String childName,
    int childAge,
    String childGender,
    String specialNeed,
    String serviceName,
    RequestStatus status,
  });
}

/// @nodoc
class _$CaregiverRequestCopyWithImpl<$Res, $Val extends CaregiverRequest>
    implements $CaregiverRequestCopyWith<$Res> {
  _$CaregiverRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaregiverRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = null,
    Object? parentName = null,
    Object? parentImageUrl = null,
    Object? parentLocation = null,
    Object? childName = null,
    Object? childAge = null,
    Object? childGender = null,
    Object? specialNeed = null,
    Object? serviceName = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            parentId: null == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String,
            parentName: null == parentName
                ? _value.parentName
                : parentName // ignore: cast_nullable_to_non_nullable
                      as String,
            parentImageUrl: null == parentImageUrl
                ? _value.parentImageUrl
                : parentImageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            parentLocation: null == parentLocation
                ? _value.parentLocation
                : parentLocation // ignore: cast_nullable_to_non_nullable
                      as String,
            childName: null == childName
                ? _value.childName
                : childName // ignore: cast_nullable_to_non_nullable
                      as String,
            childAge: null == childAge
                ? _value.childAge
                : childAge // ignore: cast_nullable_to_non_nullable
                      as int,
            childGender: null == childGender
                ? _value.childGender
                : childGender // ignore: cast_nullable_to_non_nullable
                      as String,
            specialNeed: null == specialNeed
                ? _value.specialNeed
                : specialNeed // ignore: cast_nullable_to_non_nullable
                      as String,
            serviceName: null == serviceName
                ? _value.serviceName
                : serviceName // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RequestStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CaregiverRequestImplCopyWith<$Res>
    implements $CaregiverRequestCopyWith<$Res> {
  factory _$$CaregiverRequestImplCopyWith(
    _$CaregiverRequestImpl value,
    $Res Function(_$CaregiverRequestImpl) then,
  ) = __$$CaregiverRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String parentId,
    String parentName,
    String parentImageUrl,
    String parentLocation,
    String childName,
    int childAge,
    String childGender,
    String specialNeed,
    String serviceName,
    RequestStatus status,
  });
}

/// @nodoc
class __$$CaregiverRequestImplCopyWithImpl<$Res>
    extends _$CaregiverRequestCopyWithImpl<$Res, _$CaregiverRequestImpl>
    implements _$$CaregiverRequestImplCopyWith<$Res> {
  __$$CaregiverRequestImplCopyWithImpl(
    _$CaregiverRequestImpl _value,
    $Res Function(_$CaregiverRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CaregiverRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = null,
    Object? parentName = null,
    Object? parentImageUrl = null,
    Object? parentLocation = null,
    Object? childName = null,
    Object? childAge = null,
    Object? childGender = null,
    Object? specialNeed = null,
    Object? serviceName = null,
    Object? status = null,
  }) {
    return _then(
      _$CaregiverRequestImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: null == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentName: null == parentName
            ? _value.parentName
            : parentName // ignore: cast_nullable_to_non_nullable
                  as String,
        parentImageUrl: null == parentImageUrl
            ? _value.parentImageUrl
            : parentImageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        parentLocation: null == parentLocation
            ? _value.parentLocation
            : parentLocation // ignore: cast_nullable_to_non_nullable
                  as String,
        childName: null == childName
            ? _value.childName
            : childName // ignore: cast_nullable_to_non_nullable
                  as String,
        childAge: null == childAge
            ? _value.childAge
            : childAge // ignore: cast_nullable_to_non_nullable
                  as int,
        childGender: null == childGender
            ? _value.childGender
            : childGender // ignore: cast_nullable_to_non_nullable
                  as String,
        specialNeed: null == specialNeed
            ? _value.specialNeed
            : specialNeed // ignore: cast_nullable_to_non_nullable
                  as String,
        serviceName: null == serviceName
            ? _value.serviceName
            : serviceName // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RequestStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CaregiverRequestImpl extends _CaregiverRequest {
  const _$CaregiverRequestImpl({
    required this.id,
    required this.parentId,
    required this.parentName,
    this.parentImageUrl = 'https://example.com/placeholder.png',
    required this.parentLocation,
    required this.childName,
    required this.childAge,
    required this.childGender,
    required this.specialNeed,
    required this.serviceName,
    this.status = RequestStatus.pending,
  }) : super._();

  factory _$CaregiverRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaregiverRequestImplFromJson(json);

  @override
  final String id;
  // Parent Details (The person paying for the service)
  @override
  final String parentId;
  @override
  final String parentName;
  @override
  @JsonKey()
  final String parentImageUrl;
  @override
  final String parentLocation;
  // Child Details (The person receiving the care)
  @override
  final String childName;
  @override
  final int childAge;
  @override
  final String childGender;
  @override
  final String specialNeed;
  // Service Context
  @override
  final String serviceName;
  @override
  @JsonKey()
  final RequestStatus status;

  @override
  String toString() {
    return 'CaregiverRequest(id: $id, parentId: $parentId, parentName: $parentName, parentImageUrl: $parentImageUrl, parentLocation: $parentLocation, childName: $childName, childAge: $childAge, childGender: $childGender, specialNeed: $specialNeed, serviceName: $serviceName, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaregiverRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.parentName, parentName) ||
                other.parentName == parentName) &&
            (identical(other.parentImageUrl, parentImageUrl) ||
                other.parentImageUrl == parentImageUrl) &&
            (identical(other.parentLocation, parentLocation) ||
                other.parentLocation == parentLocation) &&
            (identical(other.childName, childName) ||
                other.childName == childName) &&
            (identical(other.childAge, childAge) ||
                other.childAge == childAge) &&
            (identical(other.childGender, childGender) ||
                other.childGender == childGender) &&
            (identical(other.specialNeed, specialNeed) ||
                other.specialNeed == specialNeed) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    parentId,
    parentName,
    parentImageUrl,
    parentLocation,
    childName,
    childAge,
    childGender,
    specialNeed,
    serviceName,
    status,
  );

  /// Create a copy of CaregiverRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaregiverRequestImplCopyWith<_$CaregiverRequestImpl> get copyWith =>
      __$$CaregiverRequestImplCopyWithImpl<_$CaregiverRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CaregiverRequestImplToJson(this);
  }
}

abstract class _CaregiverRequest extends CaregiverRequest {
  const factory _CaregiverRequest({
    required final String id,
    required final String parentId,
    required final String parentName,
    final String parentImageUrl,
    required final String parentLocation,
    required final String childName,
    required final int childAge,
    required final String childGender,
    required final String specialNeed,
    required final String serviceName,
    final RequestStatus status,
  }) = _$CaregiverRequestImpl;
  const _CaregiverRequest._() : super._();

  factory _CaregiverRequest.fromJson(Map<String, dynamic> json) =
      _$CaregiverRequestImpl.fromJson;

  @override
  String get id; // Parent Details (The person paying for the service)
  @override
  String get parentId;
  @override
  String get parentName;
  @override
  String get parentImageUrl;
  @override
  String get parentLocation; // Child Details (The person receiving the care)
  @override
  String get childName;
  @override
  int get childAge;
  @override
  String get childGender;
  @override
  String get specialNeed; // Service Context
  @override
  String get serviceName;
  @override
  RequestStatus get status;

  /// Create a copy of CaregiverRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaregiverRequestImplCopyWith<_$CaregiverRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
