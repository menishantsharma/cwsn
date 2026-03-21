// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RemoteService _$RemoteServiceFromJson(Map<String, dynamic> json) {
  return _RemoteService.fromJson(json);
}

/// @nodoc
mixin _$RemoteService {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  String get serviceType => throw _privateConstructorUsedError;
  String get paymentType => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int? get targetAgeMin => throw _privateConstructorUsedError;
  int? get targetAgeMax => throw _privateConstructorUsedError;
  String get targetGender => throw _privateConstructorUsedError;
  int? get maxParticipants => throw _privateConstructorUsedError;

  /// Serializes this RemoteService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RemoteService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RemoteServiceCopyWith<RemoteService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteServiceCopyWith<$Res> {
  factory $RemoteServiceCopyWith(
    RemoteService value,
    $Res Function(RemoteService) then,
  ) = _$RemoteServiceCopyWithImpl<$Res, RemoteService>;
  @useResult
  $Res call({
    int id,
    String title,
    String description,
    String? image,
    String? categoryName,
    String serviceType,
    String paymentType,
    bool isActive,
    int? targetAgeMin,
    int? targetAgeMax,
    String targetGender,
    int? maxParticipants,
  });
}

/// @nodoc
class _$RemoteServiceCopyWithImpl<$Res, $Val extends RemoteService>
    implements $RemoteServiceCopyWith<$Res> {
  _$RemoteServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RemoteService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? image = freezed,
    Object? categoryName = freezed,
    Object? serviceType = null,
    Object? paymentType = null,
    Object? isActive = null,
    Object? targetAgeMin = freezed,
    Object? targetAgeMax = freezed,
    Object? targetGender = null,
    Object? maxParticipants = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryName: freezed == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String?,
            serviceType: null == serviceType
                ? _value.serviceType
                : serviceType // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentType: null == paymentType
                ? _value.paymentType
                : paymentType // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            targetAgeMin: freezed == targetAgeMin
                ? _value.targetAgeMin
                : targetAgeMin // ignore: cast_nullable_to_non_nullable
                      as int?,
            targetAgeMax: freezed == targetAgeMax
                ? _value.targetAgeMax
                : targetAgeMax // ignore: cast_nullable_to_non_nullable
                      as int?,
            targetGender: null == targetGender
                ? _value.targetGender
                : targetGender // ignore: cast_nullable_to_non_nullable
                      as String,
            maxParticipants: freezed == maxParticipants
                ? _value.maxParticipants
                : maxParticipants // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RemoteServiceImplCopyWith<$Res>
    implements $RemoteServiceCopyWith<$Res> {
  factory _$$RemoteServiceImplCopyWith(
    _$RemoteServiceImpl value,
    $Res Function(_$RemoteServiceImpl) then,
  ) = __$$RemoteServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    String description,
    String? image,
    String? categoryName,
    String serviceType,
    String paymentType,
    bool isActive,
    int? targetAgeMin,
    int? targetAgeMax,
    String targetGender,
    int? maxParticipants,
  });
}

/// @nodoc
class __$$RemoteServiceImplCopyWithImpl<$Res>
    extends _$RemoteServiceCopyWithImpl<$Res, _$RemoteServiceImpl>
    implements _$$RemoteServiceImplCopyWith<$Res> {
  __$$RemoteServiceImplCopyWithImpl(
    _$RemoteServiceImpl _value,
    $Res Function(_$RemoteServiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RemoteService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? image = freezed,
    Object? categoryName = freezed,
    Object? serviceType = null,
    Object? paymentType = null,
    Object? isActive = null,
    Object? targetAgeMin = freezed,
    Object? targetAgeMax = freezed,
    Object? targetGender = null,
    Object? maxParticipants = freezed,
  }) {
    return _then(
      _$RemoteServiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryName: freezed == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String?,
        serviceType: null == serviceType
            ? _value.serviceType
            : serviceType // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentType: null == paymentType
            ? _value.paymentType
            : paymentType // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        targetAgeMin: freezed == targetAgeMin
            ? _value.targetAgeMin
            : targetAgeMin // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetAgeMax: freezed == targetAgeMax
            ? _value.targetAgeMax
            : targetAgeMax // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetGender: null == targetGender
            ? _value.targetGender
            : targetGender // ignore: cast_nullable_to_non_nullable
                  as String,
        maxParticipants: freezed == maxParticipants
            ? _value.maxParticipants
            : maxParticipants // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$RemoteServiceImpl implements _RemoteService {
  const _$RemoteServiceImpl({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    this.categoryName,
    required this.serviceType,
    required this.paymentType,
    required this.isActive,
    this.targetAgeMin,
    this.targetAgeMax,
    required this.targetGender,
    this.maxParticipants,
  });

  factory _$RemoteServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$RemoteServiceImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String? image;
  @override
  final String? categoryName;
  @override
  final String serviceType;
  @override
  final String paymentType;
  @override
  final bool isActive;
  @override
  final int? targetAgeMin;
  @override
  final int? targetAgeMax;
  @override
  final String targetGender;
  @override
  final int? maxParticipants;

  @override
  String toString() {
    return 'RemoteService(id: $id, title: $title, description: $description, image: $image, categoryName: $categoryName, serviceType: $serviceType, paymentType: $paymentType, isActive: $isActive, targetAgeMin: $targetAgeMin, targetAgeMax: $targetAgeMax, targetGender: $targetGender, maxParticipants: $maxParticipants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoteServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.targetAgeMin, targetAgeMin) ||
                other.targetAgeMin == targetAgeMin) &&
            (identical(other.targetAgeMax, targetAgeMax) ||
                other.targetAgeMax == targetAgeMax) &&
            (identical(other.targetGender, targetGender) ||
                other.targetGender == targetGender) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    image,
    categoryName,
    serviceType,
    paymentType,
    isActive,
    targetAgeMin,
    targetAgeMax,
    targetGender,
    maxParticipants,
  );

  /// Create a copy of RemoteService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoteServiceImplCopyWith<_$RemoteServiceImpl> get copyWith =>
      __$$RemoteServiceImplCopyWithImpl<_$RemoteServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RemoteServiceImplToJson(this);
  }
}

abstract class _RemoteService implements RemoteService {
  const factory _RemoteService({
    required final int id,
    required final String title,
    required final String description,
    final String? image,
    final String? categoryName,
    required final String serviceType,
    required final String paymentType,
    required final bool isActive,
    final int? targetAgeMin,
    final int? targetAgeMax,
    required final String targetGender,
    final int? maxParticipants,
  }) = _$RemoteServiceImpl;

  factory _RemoteService.fromJson(Map<String, dynamic> json) =
      _$RemoteServiceImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String? get image;
  @override
  String? get categoryName;
  @override
  String get serviceType;
  @override
  String get paymentType;
  @override
  bool get isActive;
  @override
  int? get targetAgeMin;
  @override
  int? get targetAgeMax;
  @override
  String get targetGender;
  @override
  int? get maxParticipants;

  /// Create a copy of RemoteService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoteServiceImplCopyWith<_$RemoteServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
