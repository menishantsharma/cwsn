// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ServiceSearchResult _$ServiceSearchResultFromJson(Map<String, dynamic> json) {
  return _ServiceSearchResult.fromJson(json);
}

/// @nodoc
mixin _$ServiceSearchResult {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  String get serviceType => throw _privateConstructorUsedError;
  String get paymentType => throw _privateConstructorUsedError;
  String get targetGender => throw _privateConstructorUsedError;
  int? get targetAgeMin => throw _privateConstructorUsedError;
  int? get targetAgeMax => throw _privateConstructorUsedError;
  List<String> get targetDisabilitiesNames =>
      throw _privateConstructorUsedError;
  CaregiverProfile? get caregiverProfile => throw _privateConstructorUsedError;

  /// Serializes this ServiceSearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceSearchResultCopyWith<ServiceSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceSearchResultCopyWith<$Res> {
  factory $ServiceSearchResultCopyWith(
    ServiceSearchResult value,
    $Res Function(ServiceSearchResult) then,
  ) = _$ServiceSearchResultCopyWithImpl<$Res, ServiceSearchResult>;
  @useResult
  $Res call({
    int id,
    String title,
    String description,
    String? image,
    String? categoryName,
    String serviceType,
    String paymentType,
    String targetGender,
    int? targetAgeMin,
    int? targetAgeMax,
    List<String> targetDisabilitiesNames,
    CaregiverProfile? caregiverProfile,
  });

  $CaregiverProfileCopyWith<$Res>? get caregiverProfile;
}

/// @nodoc
class _$ServiceSearchResultCopyWithImpl<$Res, $Val extends ServiceSearchResult>
    implements $ServiceSearchResultCopyWith<$Res> {
  _$ServiceSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceSearchResult
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
    Object? targetGender = null,
    Object? targetAgeMin = freezed,
    Object? targetAgeMax = freezed,
    Object? targetDisabilitiesNames = null,
    Object? caregiverProfile = freezed,
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
            targetGender: null == targetGender
                ? _value.targetGender
                : targetGender // ignore: cast_nullable_to_non_nullable
                      as String,
            targetAgeMin: freezed == targetAgeMin
                ? _value.targetAgeMin
                : targetAgeMin // ignore: cast_nullable_to_non_nullable
                      as int?,
            targetAgeMax: freezed == targetAgeMax
                ? _value.targetAgeMax
                : targetAgeMax // ignore: cast_nullable_to_non_nullable
                      as int?,
            targetDisabilitiesNames: null == targetDisabilitiesNames
                ? _value.targetDisabilitiesNames
                : targetDisabilitiesNames // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            caregiverProfile: freezed == caregiverProfile
                ? _value.caregiverProfile
                : caregiverProfile // ignore: cast_nullable_to_non_nullable
                      as CaregiverProfile?,
          )
          as $Val,
    );
  }

  /// Create a copy of ServiceSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CaregiverProfileCopyWith<$Res>? get caregiverProfile {
    if (_value.caregiverProfile == null) {
      return null;
    }

    return $CaregiverProfileCopyWith<$Res>(_value.caregiverProfile!, (value) {
      return _then(_value.copyWith(caregiverProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ServiceSearchResultImplCopyWith<$Res>
    implements $ServiceSearchResultCopyWith<$Res> {
  factory _$$ServiceSearchResultImplCopyWith(
    _$ServiceSearchResultImpl value,
    $Res Function(_$ServiceSearchResultImpl) then,
  ) = __$$ServiceSearchResultImplCopyWithImpl<$Res>;
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
    String targetGender,
    int? targetAgeMin,
    int? targetAgeMax,
    List<String> targetDisabilitiesNames,
    CaregiverProfile? caregiverProfile,
  });

  @override
  $CaregiverProfileCopyWith<$Res>? get caregiverProfile;
}

/// @nodoc
class __$$ServiceSearchResultImplCopyWithImpl<$Res>
    extends _$ServiceSearchResultCopyWithImpl<$Res, _$ServiceSearchResultImpl>
    implements _$$ServiceSearchResultImplCopyWith<$Res> {
  __$$ServiceSearchResultImplCopyWithImpl(
    _$ServiceSearchResultImpl _value,
    $Res Function(_$ServiceSearchResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceSearchResult
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
    Object? targetGender = null,
    Object? targetAgeMin = freezed,
    Object? targetAgeMax = freezed,
    Object? targetDisabilitiesNames = null,
    Object? caregiverProfile = freezed,
  }) {
    return _then(
      _$ServiceSearchResultImpl(
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
        targetGender: null == targetGender
            ? _value.targetGender
            : targetGender // ignore: cast_nullable_to_non_nullable
                  as String,
        targetAgeMin: freezed == targetAgeMin
            ? _value.targetAgeMin
            : targetAgeMin // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetAgeMax: freezed == targetAgeMax
            ? _value.targetAgeMax
            : targetAgeMax // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetDisabilitiesNames: null == targetDisabilitiesNames
            ? _value._targetDisabilitiesNames
            : targetDisabilitiesNames // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        caregiverProfile: freezed == caregiverProfile
            ? _value.caregiverProfile
            : caregiverProfile // ignore: cast_nullable_to_non_nullable
                  as CaregiverProfile?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ServiceSearchResultImpl implements _ServiceSearchResult {
  const _$ServiceSearchResultImpl({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    this.categoryName,
    required this.serviceType,
    required this.paymentType,
    required this.targetGender,
    this.targetAgeMin,
    this.targetAgeMax,
    final List<String> targetDisabilitiesNames = const [],
    this.caregiverProfile,
  }) : _targetDisabilitiesNames = targetDisabilitiesNames;

  factory _$ServiceSearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceSearchResultImplFromJson(json);

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
  final String targetGender;
  @override
  final int? targetAgeMin;
  @override
  final int? targetAgeMax;
  final List<String> _targetDisabilitiesNames;
  @override
  @JsonKey()
  List<String> get targetDisabilitiesNames {
    if (_targetDisabilitiesNames is EqualUnmodifiableListView)
      return _targetDisabilitiesNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetDisabilitiesNames);
  }

  @override
  final CaregiverProfile? caregiverProfile;

  @override
  String toString() {
    return 'ServiceSearchResult(id: $id, title: $title, description: $description, image: $image, categoryName: $categoryName, serviceType: $serviceType, paymentType: $paymentType, targetGender: $targetGender, targetAgeMin: $targetAgeMin, targetAgeMax: $targetAgeMax, targetDisabilitiesNames: $targetDisabilitiesNames, caregiverProfile: $caregiverProfile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceSearchResultImpl &&
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
            (identical(other.targetGender, targetGender) ||
                other.targetGender == targetGender) &&
            (identical(other.targetAgeMin, targetAgeMin) ||
                other.targetAgeMin == targetAgeMin) &&
            (identical(other.targetAgeMax, targetAgeMax) ||
                other.targetAgeMax == targetAgeMax) &&
            const DeepCollectionEquality().equals(
              other._targetDisabilitiesNames,
              _targetDisabilitiesNames,
            ) &&
            (identical(other.caregiverProfile, caregiverProfile) ||
                other.caregiverProfile == caregiverProfile));
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
    targetGender,
    targetAgeMin,
    targetAgeMax,
    const DeepCollectionEquality().hash(_targetDisabilitiesNames),
    caregiverProfile,
  );

  /// Create a copy of ServiceSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceSearchResultImplCopyWith<_$ServiceSearchResultImpl> get copyWith =>
      __$$ServiceSearchResultImplCopyWithImpl<_$ServiceSearchResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceSearchResultImplToJson(this);
  }
}

abstract class _ServiceSearchResult implements ServiceSearchResult {
  const factory _ServiceSearchResult({
    required final int id,
    required final String title,
    required final String description,
    final String? image,
    final String? categoryName,
    required final String serviceType,
    required final String paymentType,
    required final String targetGender,
    final int? targetAgeMin,
    final int? targetAgeMax,
    final List<String> targetDisabilitiesNames,
    final CaregiverProfile? caregiverProfile,
  }) = _$ServiceSearchResultImpl;

  factory _ServiceSearchResult.fromJson(Map<String, dynamic> json) =
      _$ServiceSearchResultImpl.fromJson;

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
  String get targetGender;
  @override
  int? get targetAgeMin;
  @override
  int? get targetAgeMax;
  @override
  List<String> get targetDisabilitiesNames;
  @override
  CaregiverProfile? get caregiverProfile;

  /// Create a copy of ServiceSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceSearchResultImplCopyWith<_$ServiceSearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
