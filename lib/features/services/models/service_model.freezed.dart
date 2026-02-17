// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ServiceItem _$ServiceItemFromJson(Map<String, dynamic> json) {
  return _ServiceItem.fromJson(json);
}

/// @nodoc
mixin _$ServiceItem {
  String get title => throw _privateConstructorUsedError;

  /// The path to the image (can be a network URL or an Asset path)
  String get imgUrl => throw _privateConstructorUsedError;

  /// Optional: Add an ID if you want to navigate to a specific service detail page
  String? get id => throw _privateConstructorUsedError;

  /// Serializes this ServiceItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceItemCopyWith<ServiceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceItemCopyWith<$Res> {
  factory $ServiceItemCopyWith(
    ServiceItem value,
    $Res Function(ServiceItem) then,
  ) = _$ServiceItemCopyWithImpl<$Res, ServiceItem>;
  @useResult
  $Res call({String title, String imgUrl, String? id});
}

/// @nodoc
class _$ServiceItemCopyWithImpl<$Res, $Val extends ServiceItem>
    implements $ServiceItemCopyWith<$Res> {
  _$ServiceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? imgUrl = null,
    Object? id = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            imgUrl: null == imgUrl
                ? _value.imgUrl
                : imgUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServiceItemImplCopyWith<$Res>
    implements $ServiceItemCopyWith<$Res> {
  factory _$$ServiceItemImplCopyWith(
    _$ServiceItemImpl value,
    $Res Function(_$ServiceItemImpl) then,
  ) = __$$ServiceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String imgUrl, String? id});
}

/// @nodoc
class __$$ServiceItemImplCopyWithImpl<$Res>
    extends _$ServiceItemCopyWithImpl<$Res, _$ServiceItemImpl>
    implements _$$ServiceItemImplCopyWith<$Res> {
  __$$ServiceItemImplCopyWithImpl(
    _$ServiceItemImpl _value,
    $Res Function(_$ServiceItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? imgUrl = null,
    Object? id = freezed,
  }) {
    return _then(
      _$ServiceItemImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        imgUrl: null == imgUrl
            ? _value.imgUrl
            : imgUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceItemImpl implements _ServiceItem {
  const _$ServiceItemImpl({required this.title, required this.imgUrl, this.id});

  factory _$ServiceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceItemImplFromJson(json);

  @override
  final String title;

  /// The path to the image (can be a network URL or an Asset path)
  @override
  final String imgUrl;

  /// Optional: Add an ID if you want to navigate to a specific service detail page
  @override
  final String? id;

  @override
  String toString() {
    return 'ServiceItem(title: $title, imgUrl: $imgUrl, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceItemImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, imgUrl, id);

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceItemImplCopyWith<_$ServiceItemImpl> get copyWith =>
      __$$ServiceItemImplCopyWithImpl<_$ServiceItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceItemImplToJson(this);
  }
}

abstract class _ServiceItem implements ServiceItem {
  const factory _ServiceItem({
    required final String title,
    required final String imgUrl,
    final String? id,
  }) = _$ServiceItemImpl;

  factory _ServiceItem.fromJson(Map<String, dynamic> json) =
      _$ServiceItemImpl.fromJson;

  @override
  String get title;

  /// The path to the image (can be a network URL or an Asset path)
  @override
  String get imgUrl;

  /// Optional: Add an ID if you want to navigate to a specific service detail page
  @override
  String? get id;

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceItemImplCopyWith<_$ServiceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ServiceSection _$ServiceSectionFromJson(Map<String, dynamic> json) {
  return _ServiceSection.fromJson(json);
}

/// @nodoc
mixin _$ServiceSection {
  String get title => throw _privateConstructorUsedError;

  /// The list of service cards belonging to this specific category
  List<ServiceItem> get items => throw _privateConstructorUsedError;

  /// Serializes this ServiceSection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceSectionCopyWith<ServiceSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceSectionCopyWith<$Res> {
  factory $ServiceSectionCopyWith(
    ServiceSection value,
    $Res Function(ServiceSection) then,
  ) = _$ServiceSectionCopyWithImpl<$Res, ServiceSection>;
  @useResult
  $Res call({String title, List<ServiceItem> items});
}

/// @nodoc
class _$ServiceSectionCopyWithImpl<$Res, $Val extends ServiceSection>
    implements $ServiceSectionCopyWith<$Res> {
  _$ServiceSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = null, Object? items = null}) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ServiceItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServiceSectionImplCopyWith<$Res>
    implements $ServiceSectionCopyWith<$Res> {
  factory _$$ServiceSectionImplCopyWith(
    _$ServiceSectionImpl value,
    $Res Function(_$ServiceSectionImpl) then,
  ) = __$$ServiceSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, List<ServiceItem> items});
}

/// @nodoc
class __$$ServiceSectionImplCopyWithImpl<$Res>
    extends _$ServiceSectionCopyWithImpl<$Res, _$ServiceSectionImpl>
    implements _$$ServiceSectionImplCopyWith<$Res> {
  __$$ServiceSectionImplCopyWithImpl(
    _$ServiceSectionImpl _value,
    $Res Function(_$ServiceSectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = null, Object? items = null}) {
    return _then(
      _$ServiceSectionImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ServiceItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceSectionImpl implements _ServiceSection {
  const _$ServiceSectionImpl({
    required this.title,
    final List<ServiceItem> items = const [],
  }) : _items = items;

  factory _$ServiceSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceSectionImplFromJson(json);

  @override
  final String title;

  /// The list of service cards belonging to this specific category
  final List<ServiceItem> _items;

  /// The list of service cards belonging to this specific category
  @override
  @JsonKey()
  List<ServiceItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'ServiceSection(title: $title, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceSectionImpl &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of ServiceSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceSectionImplCopyWith<_$ServiceSectionImpl> get copyWith =>
      __$$ServiceSectionImplCopyWithImpl<_$ServiceSectionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceSectionImplToJson(this);
  }
}

abstract class _ServiceSection implements ServiceSection {
  const factory _ServiceSection({
    required final String title,
    final List<ServiceItem> items,
  }) = _$ServiceSectionImpl;

  factory _ServiceSection.fromJson(Map<String, dynamic> json) =
      _$ServiceSectionImpl.fromJson;

  @override
  String get title;

  /// The list of service cards belonging to this specific category
  @override
  List<ServiceItem> get items;

  /// Create a copy of ServiceSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceSectionImplCopyWith<_$ServiceSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
