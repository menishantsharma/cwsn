// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'caregiver_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CaregiverFilter _$CaregiverFilterFromJson(Map<String, dynamic> json) {
  return _CaregiverFilter.fromJson(json);
}

/// @nodoc
mixin _$CaregiverFilter {
  String? get gender => throw _privateConstructorUsedError;
  List<String> get languages => throw _privateConstructorUsedError;
  List<String> get services => throw _privateConstructorUsedError;
  bool? get isAvailable => throw _privateConstructorUsedError;

  /// Serializes this CaregiverFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaregiverFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaregiverFilterCopyWith<CaregiverFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaregiverFilterCopyWith<$Res> {
  factory $CaregiverFilterCopyWith(
    CaregiverFilter value,
    $Res Function(CaregiverFilter) then,
  ) = _$CaregiverFilterCopyWithImpl<$Res, CaregiverFilter>;
  @useResult
  $Res call({
    String? gender,
    List<String> languages,
    List<String> services,
    bool? isAvailable,
  });
}

/// @nodoc
class _$CaregiverFilterCopyWithImpl<$Res, $Val extends CaregiverFilter>
    implements $CaregiverFilterCopyWith<$Res> {
  _$CaregiverFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaregiverFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gender = freezed,
    Object? languages = null,
    Object? services = null,
    Object? isAvailable = freezed,
  }) {
    return _then(
      _value.copyWith(
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            languages: null == languages
                ? _value.languages
                : languages // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            services: null == services
                ? _value.services
                : services // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isAvailable: freezed == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CaregiverFilterImplCopyWith<$Res>
    implements $CaregiverFilterCopyWith<$Res> {
  factory _$$CaregiverFilterImplCopyWith(
    _$CaregiverFilterImpl value,
    $Res Function(_$CaregiverFilterImpl) then,
  ) = __$$CaregiverFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? gender,
    List<String> languages,
    List<String> services,
    bool? isAvailable,
  });
}

/// @nodoc
class __$$CaregiverFilterImplCopyWithImpl<$Res>
    extends _$CaregiverFilterCopyWithImpl<$Res, _$CaregiverFilterImpl>
    implements _$$CaregiverFilterImplCopyWith<$Res> {
  __$$CaregiverFilterImplCopyWithImpl(
    _$CaregiverFilterImpl _value,
    $Res Function(_$CaregiverFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CaregiverFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gender = freezed,
    Object? languages = null,
    Object? services = null,
    Object? isAvailable = freezed,
  }) {
    return _then(
      _$CaregiverFilterImpl(
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        languages: null == languages
            ? _value._languages
            : languages // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        services: null == services
            ? _value._services
            : services // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isAvailable: freezed == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CaregiverFilterImpl extends _CaregiverFilter {
  const _$CaregiverFilterImpl({
    this.gender,
    final List<String> languages = const [],
    final List<String> services = const [],
    this.isAvailable,
  }) : _languages = languages,
       _services = services,
       super._();

  factory _$CaregiverFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaregiverFilterImplFromJson(json);

  @override
  final String? gender;
  final List<String> _languages;
  @override
  @JsonKey()
  List<String> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  final List<String> _services;
  @override
  @JsonKey()
  List<String> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  @override
  final bool? isAvailable;

  @override
  String toString() {
    return 'CaregiverFilter(gender: $gender, languages: $languages, services: $services, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaregiverFilterImpl &&
            (identical(other.gender, gender) || other.gender == gender) &&
            const DeepCollectionEquality().equals(
              other._languages,
              _languages,
            ) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    gender,
    const DeepCollectionEquality().hash(_languages),
    const DeepCollectionEquality().hash(_services),
    isAvailable,
  );

  /// Create a copy of CaregiverFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaregiverFilterImplCopyWith<_$CaregiverFilterImpl> get copyWith =>
      __$$CaregiverFilterImplCopyWithImpl<_$CaregiverFilterImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CaregiverFilterImplToJson(this);
  }
}

abstract class _CaregiverFilter extends CaregiverFilter {
  const factory _CaregiverFilter({
    final String? gender,
    final List<String> languages,
    final List<String> services,
    final bool? isAvailable,
  }) = _$CaregiverFilterImpl;
  const _CaregiverFilter._() : super._();

  factory _CaregiverFilter.fromJson(Map<String, dynamic> json) =
      _$CaregiverFilterImpl.fromJson;

  @override
  String? get gender;
  @override
  List<String> get languages;
  @override
  List<String> get services;
  @override
  bool? get isAvailable;

  /// Create a copy of CaregiverFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaregiverFilterImplCopyWith<_$CaregiverFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
