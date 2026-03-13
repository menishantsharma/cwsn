// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'caregiver_service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CaregiverService _$CaregiverServiceFromJson(Map<String, dynamic> json) {
  return _CaregiverService.fromJson(json);
}

/// @nodoc
mixin _$CaregiverService {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<String> get specialNeeds => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this CaregiverService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaregiverService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaregiverServiceCopyWith<CaregiverService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaregiverServiceCopyWith<$Res> {
  factory $CaregiverServiceCopyWith(
    CaregiverService value,
    $Res Function(CaregiverService) then,
  ) = _$CaregiverServiceCopyWithImpl<$Res, CaregiverService>;
  @useResult
  $Res call({String id, String name, List<String> specialNeeds, bool isActive});
}

/// @nodoc
class _$CaregiverServiceCopyWithImpl<$Res, $Val extends CaregiverService>
    implements $CaregiverServiceCopyWith<$Res> {
  _$CaregiverServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaregiverService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? specialNeeds = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            specialNeeds: null == specialNeeds
                ? _value.specialNeeds
                : specialNeeds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CaregiverServiceImplCopyWith<$Res>
    implements $CaregiverServiceCopyWith<$Res> {
  factory _$$CaregiverServiceImplCopyWith(
    _$CaregiverServiceImpl value,
    $Res Function(_$CaregiverServiceImpl) then,
  ) = __$$CaregiverServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, List<String> specialNeeds, bool isActive});
}

/// @nodoc
class __$$CaregiverServiceImplCopyWithImpl<$Res>
    extends _$CaregiverServiceCopyWithImpl<$Res, _$CaregiverServiceImpl>
    implements _$$CaregiverServiceImplCopyWith<$Res> {
  __$$CaregiverServiceImplCopyWithImpl(
    _$CaregiverServiceImpl _value,
    $Res Function(_$CaregiverServiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CaregiverService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? specialNeeds = null,
    Object? isActive = null,
  }) {
    return _then(
      _$CaregiverServiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        specialNeeds: null == specialNeeds
            ? _value._specialNeeds
            : specialNeeds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CaregiverServiceImpl implements _CaregiverService {
  const _$CaregiverServiceImpl({
    required this.id,
    required this.name,
    final List<String> specialNeeds = const [],
    this.isActive = true,
  }) : _specialNeeds = specialNeeds;

  factory _$CaregiverServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaregiverServiceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<String> _specialNeeds;
  @override
  @JsonKey()
  List<String> get specialNeeds {
    if (_specialNeeds is EqualUnmodifiableListView) return _specialNeeds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialNeeds);
  }

  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'CaregiverService(id: $id, name: $name, specialNeeds: $specialNeeds, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaregiverServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(
              other._specialNeeds,
              _specialNeeds,
            ) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_specialNeeds),
    isActive,
  );

  /// Create a copy of CaregiverService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaregiverServiceImplCopyWith<_$CaregiverServiceImpl> get copyWith =>
      __$$CaregiverServiceImplCopyWithImpl<_$CaregiverServiceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CaregiverServiceImplToJson(this);
  }
}

abstract class _CaregiverService implements CaregiverService {
  const factory _CaregiverService({
    required final String id,
    required final String name,
    final List<String> specialNeeds,
    final bool isActive,
  }) = _$CaregiverServiceImpl;

  factory _CaregiverService.fromJson(Map<String, dynamic> json) =
      _$CaregiverServiceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<String> get specialNeeds;
  @override
  bool get isActive;

  /// Create a copy of CaregiverService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaregiverServiceImplCopyWith<_$CaregiverServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
