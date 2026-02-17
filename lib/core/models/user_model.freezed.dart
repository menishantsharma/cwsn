// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String? get lastName =>
      throw _privateConstructorUsedError; // Default image if the user hasn't uploaded one
  String get imageUrl => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  bool get isGuest => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  Gender? get gender =>
      throw _privateConstructorUsedError; // This tells the app if we are currently looking at the "Parent" or "Caregiver" side
  UserRole? get activeRole =>
      throw _privateConstructorUsedError; // Security token for API calls
  String? get token =>
      throw _privateConstructorUsedError; // Detailed profiles (Optional: a user could be one or both)
  CaregiverProfile? get caregiverProfile => throw _privateConstructorUsedError;
  ParentModel? get parentProfile => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String id,
    String firstName,
    String? lastName,
    String imageUrl,
    String? location,
    String email,
    bool isGuest,
    String? phoneNumber,
    Gender? gender,
    UserRole? activeRole,
    String? token,
    CaregiverProfile? caregiverProfile,
    ParentModel? parentProfile,
  });

  $CaregiverProfileCopyWith<$Res>? get caregiverProfile;
  $ParentModelCopyWith<$Res>? get parentProfile;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = freezed,
    Object? imageUrl = null,
    Object? location = freezed,
    Object? email = null,
    Object? isGuest = null,
    Object? phoneNumber = freezed,
    Object? gender = freezed,
    Object? activeRole = freezed,
    Object? token = freezed,
    Object? caregiverProfile = freezed,
    Object? parentProfile = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            isGuest: null == isGuest
                ? _value.isGuest
                : isGuest // ignore: cast_nullable_to_non_nullable
                      as bool,
            phoneNumber: freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as Gender?,
            activeRole: freezed == activeRole
                ? _value.activeRole
                : activeRole // ignore: cast_nullable_to_non_nullable
                      as UserRole?,
            token: freezed == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String?,
            caregiverProfile: freezed == caregiverProfile
                ? _value.caregiverProfile
                : caregiverProfile // ignore: cast_nullable_to_non_nullable
                      as CaregiverProfile?,
            parentProfile: freezed == parentProfile
                ? _value.parentProfile
                : parentProfile // ignore: cast_nullable_to_non_nullable
                      as ParentModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of User
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

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParentModelCopyWith<$Res>? get parentProfile {
    if (_value.parentProfile == null) {
      return null;
    }

    return $ParentModelCopyWith<$Res>(_value.parentProfile!, (value) {
      return _then(_value.copyWith(parentProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String firstName,
    String? lastName,
    String imageUrl,
    String? location,
    String email,
    bool isGuest,
    String? phoneNumber,
    Gender? gender,
    UserRole? activeRole,
    String? token,
    CaregiverProfile? caregiverProfile,
    ParentModel? parentProfile,
  });

  @override
  $CaregiverProfileCopyWith<$Res>? get caregiverProfile;
  @override
  $ParentModelCopyWith<$Res>? get parentProfile;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = freezed,
    Object? imageUrl = null,
    Object? location = freezed,
    Object? email = null,
    Object? isGuest = null,
    Object? phoneNumber = freezed,
    Object? gender = freezed,
    Object? activeRole = freezed,
    Object? token = freezed,
    Object? caregiverProfile = freezed,
    Object? parentProfile = freezed,
  }) {
    return _then(
      _$UserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        isGuest: null == isGuest
            ? _value.isGuest
            : isGuest // ignore: cast_nullable_to_non_nullable
                  as bool,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as Gender?,
        activeRole: freezed == activeRole
            ? _value.activeRole
            : activeRole // ignore: cast_nullable_to_non_nullable
                  as UserRole?,
        token: freezed == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String?,
        caregiverProfile: freezed == caregiverProfile
            ? _value.caregiverProfile
            : caregiverProfile // ignore: cast_nullable_to_non_nullable
                  as CaregiverProfile?,
        parentProfile: freezed == parentProfile
            ? _value.parentProfile
            : parentProfile // ignore: cast_nullable_to_non_nullable
                  as ParentModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl extends _User {
  const _$UserImpl({
    required this.id,
    required this.firstName,
    this.lastName,
    this.imageUrl = 'https://randomuser.me/api/portraits/lego/1.jpg',
    this.location,
    this.email = 'abc@example.com',
    this.isGuest = false,
    this.phoneNumber,
    this.gender,
    this.activeRole,
    this.token,
    this.caregiverProfile,
    this.parentProfile,
  }) : super._();

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String? lastName;
  // Default image if the user hasn't uploaded one
  @override
  @JsonKey()
  final String imageUrl;
  @override
  final String? location;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final bool isGuest;
  @override
  final String? phoneNumber;
  @override
  final Gender? gender;
  // This tells the app if we are currently looking at the "Parent" or "Caregiver" side
  @override
  final UserRole? activeRole;
  // Security token for API calls
  @override
  final String? token;
  // Detailed profiles (Optional: a user could be one or both)
  @override
  final CaregiverProfile? caregiverProfile;
  @override
  final ParentModel? parentProfile;

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, imageUrl: $imageUrl, location: $location, email: $email, isGuest: $isGuest, phoneNumber: $phoneNumber, gender: $gender, activeRole: $activeRole, token: $token, caregiverProfile: $caregiverProfile, parentProfile: $parentProfile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isGuest, isGuest) || other.isGuest == isGuest) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.activeRole, activeRole) ||
                other.activeRole == activeRole) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.caregiverProfile, caregiverProfile) ||
                other.caregiverProfile == caregiverProfile) &&
            (identical(other.parentProfile, parentProfile) ||
                other.parentProfile == parentProfile));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    firstName,
    lastName,
    imageUrl,
    location,
    email,
    isGuest,
    phoneNumber,
    gender,
    activeRole,
    token,
    caregiverProfile,
    parentProfile,
  );

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User extends User {
  const factory _User({
    required final String id,
    required final String firstName,
    final String? lastName,
    final String imageUrl,
    final String? location,
    final String email,
    final bool isGuest,
    final String? phoneNumber,
    final Gender? gender,
    final UserRole? activeRole,
    final String? token,
    final CaregiverProfile? caregiverProfile,
    final ParentModel? parentProfile,
  }) = _$UserImpl;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String? get lastName; // Default image if the user hasn't uploaded one
  @override
  String get imageUrl;
  @override
  String? get location;
  @override
  String get email;
  @override
  bool get isGuest;
  @override
  String? get phoneNumber;
  @override
  Gender? get gender; // This tells the app if we are currently looking at the "Parent" or "Caregiver" side
  @override
  UserRole? get activeRole; // Security token for API calls
  @override
  String? get token; // Detailed profiles (Optional: a user could be one or both)
  @override
  CaregiverProfile? get caregiverProfile;
  @override
  ParentModel? get parentProfile;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChildModel _$ChildModelFromJson(Map<String, dynamic> json) {
  return _ChildModel.fromJson(json);
}

/// @nodoc
mixin _$ChildModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Gender get gender => throw _privateConstructorUsedError;
  DateTime get dateOfBirth => throw _privateConstructorUsedError;

  /// Serializes this ChildModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChildModelCopyWith<ChildModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildModelCopyWith<$Res> {
  factory $ChildModelCopyWith(
    ChildModel value,
    $Res Function(ChildModel) then,
  ) = _$ChildModelCopyWithImpl<$Res, ChildModel>;
  @useResult
  $Res call({String id, String name, Gender gender, DateTime dateOfBirth});
}

/// @nodoc
class _$ChildModelCopyWithImpl<$Res, $Val extends ChildModel>
    implements $ChildModelCopyWith<$Res> {
  _$ChildModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? gender = null,
    Object? dateOfBirth = null,
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
            gender: null == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as Gender,
            dateOfBirth: null == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChildModelImplCopyWith<$Res>
    implements $ChildModelCopyWith<$Res> {
  factory _$$ChildModelImplCopyWith(
    _$ChildModelImpl value,
    $Res Function(_$ChildModelImpl) then,
  ) = __$$ChildModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, Gender gender, DateTime dateOfBirth});
}

/// @nodoc
class __$$ChildModelImplCopyWithImpl<$Res>
    extends _$ChildModelCopyWithImpl<$Res, _$ChildModelImpl>
    implements _$$ChildModelImplCopyWith<$Res> {
  __$$ChildModelImplCopyWithImpl(
    _$ChildModelImpl _value,
    $Res Function(_$ChildModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? gender = null,
    Object? dateOfBirth = null,
  }) {
    return _then(
      _$ChildModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        gender: null == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as Gender,
        dateOfBirth: null == dateOfBirth
            ? _value.dateOfBirth
            : dateOfBirth // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChildModelImpl extends _ChildModel {
  const _$ChildModelImpl({
    required this.id,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
  }) : super._();

  factory _$ChildModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final Gender gender;
  @override
  final DateTime dateOfBirth;

  @override
  String toString() {
    return 'ChildModel(id: $id, name: $name, gender: $gender, dateOfBirth: $dateOfBirth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, gender, dateOfBirth);

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildModelImplCopyWith<_$ChildModelImpl> get copyWith =>
      __$$ChildModelImplCopyWithImpl<_$ChildModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChildModelImplToJson(this);
  }
}

abstract class _ChildModel extends ChildModel {
  const factory _ChildModel({
    required final String id,
    required final String name,
    required final Gender gender,
    required final DateTime dateOfBirth,
  }) = _$ChildModelImpl;
  const _ChildModel._() : super._();

  factory _ChildModel.fromJson(Map<String, dynamic> json) =
      _$ChildModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  Gender get gender;
  @override
  DateTime get dateOfBirth;

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChildModelImplCopyWith<_$ChildModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ParentModel _$ParentModelFromJson(Map<String, dynamic> json) {
  return _ParentModel.fromJson(json);
}

/// @nodoc
mixin _$ParentModel {
  List<ChildModel> get children => throw _privateConstructorUsedError;
  DateTime? get joinedDate => throw _privateConstructorUsedError;

  /// Serializes this ParentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParentModelCopyWith<ParentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParentModelCopyWith<$Res> {
  factory $ParentModelCopyWith(
    ParentModel value,
    $Res Function(ParentModel) then,
  ) = _$ParentModelCopyWithImpl<$Res, ParentModel>;
  @useResult
  $Res call({List<ChildModel> children, DateTime? joinedDate});
}

/// @nodoc
class _$ParentModelCopyWithImpl<$Res, $Val extends ParentModel>
    implements $ParentModelCopyWith<$Res> {
  _$ParentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? children = null, Object? joinedDate = freezed}) {
    return _then(
      _value.copyWith(
            children: null == children
                ? _value.children
                : children // ignore: cast_nullable_to_non_nullable
                      as List<ChildModel>,
            joinedDate: freezed == joinedDate
                ? _value.joinedDate
                : joinedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ParentModelImplCopyWith<$Res>
    implements $ParentModelCopyWith<$Res> {
  factory _$$ParentModelImplCopyWith(
    _$ParentModelImpl value,
    $Res Function(_$ParentModelImpl) then,
  ) = __$$ParentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ChildModel> children, DateTime? joinedDate});
}

/// @nodoc
class __$$ParentModelImplCopyWithImpl<$Res>
    extends _$ParentModelCopyWithImpl<$Res, _$ParentModelImpl>
    implements _$$ParentModelImplCopyWith<$Res> {
  __$$ParentModelImplCopyWithImpl(
    _$ParentModelImpl _value,
    $Res Function(_$ParentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? children = null, Object? joinedDate = freezed}) {
    return _then(
      _$ParentModelImpl(
        children: null == children
            ? _value._children
            : children // ignore: cast_nullable_to_non_nullable
                  as List<ChildModel>,
        joinedDate: freezed == joinedDate
            ? _value.joinedDate
            : joinedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ParentModelImpl implements _ParentModel {
  const _$ParentModelImpl({
    final List<ChildModel> children = const [],
    this.joinedDate,
  }) : _children = children;

  factory _$ParentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParentModelImplFromJson(json);

  final List<ChildModel> _children;
  @override
  @JsonKey()
  List<ChildModel> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  final DateTime? joinedDate;

  @override
  String toString() {
    return 'ParentModel(children: $children, joinedDate: $joinedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParentModelImpl &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            (identical(other.joinedDate, joinedDate) ||
                other.joinedDate == joinedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_children),
    joinedDate,
  );

  /// Create a copy of ParentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParentModelImplCopyWith<_$ParentModelImpl> get copyWith =>
      __$$ParentModelImplCopyWithImpl<_$ParentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParentModelImplToJson(this);
  }
}

abstract class _ParentModel implements ParentModel {
  const factory _ParentModel({
    final List<ChildModel> children,
    final DateTime? joinedDate,
  }) = _$ParentModelImpl;

  factory _ParentModel.fromJson(Map<String, dynamic> json) =
      _$ParentModelImpl.fromJson;

  @override
  List<ChildModel> get children;
  @override
  DateTime? get joinedDate;

  /// Create a copy of ParentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParentModelImplCopyWith<_$ParentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CaregiverProfile _$CaregiverProfileFromJson(Map<String, dynamic> json) {
  return _CaregiverProfile.fromJson(json);
}

/// @nodoc
mixin _$CaregiverProfile {
  String get about => throw _privateConstructorUsedError; // A short bio
  List<String> get services =>
      throw _privateConstructorUsedError; // Skills like 'Shadow Teacher'
  bool get isVerified =>
      throw _privateConstructorUsedError; // Blue checkmark status
  bool get isAvailable => throw _privateConstructorUsedError; // Ready for work?
  List<String> get languages =>
      throw _privateConstructorUsedError; // Languages spoken
  DateTime? get joinedDate => throw _privateConstructorUsedError;
  int get yearsOfExperience => throw _privateConstructorUsedError;
  int get totalRecommendations => throw _privateConstructorUsedError;

  /// Serializes this CaregiverProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaregiverProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaregiverProfileCopyWith<CaregiverProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaregiverProfileCopyWith<$Res> {
  factory $CaregiverProfileCopyWith(
    CaregiverProfile value,
    $Res Function(CaregiverProfile) then,
  ) = _$CaregiverProfileCopyWithImpl<$Res, CaregiverProfile>;
  @useResult
  $Res call({
    String about,
    List<String> services,
    bool isVerified,
    bool isAvailable,
    List<String> languages,
    DateTime? joinedDate,
    int yearsOfExperience,
    int totalRecommendations,
  });
}

/// @nodoc
class _$CaregiverProfileCopyWithImpl<$Res, $Val extends CaregiverProfile>
    implements $CaregiverProfileCopyWith<$Res> {
  _$CaregiverProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaregiverProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? about = null,
    Object? services = null,
    Object? isVerified = null,
    Object? isAvailable = null,
    Object? languages = null,
    Object? joinedDate = freezed,
    Object? yearsOfExperience = null,
    Object? totalRecommendations = null,
  }) {
    return _then(
      _value.copyWith(
            about: null == about
                ? _value.about
                : about // ignore: cast_nullable_to_non_nullable
                      as String,
            services: null == services
                ? _value.services
                : services // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAvailable: null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            languages: null == languages
                ? _value.languages
                : languages // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            joinedDate: freezed == joinedDate
                ? _value.joinedDate
                : joinedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            yearsOfExperience: null == yearsOfExperience
                ? _value.yearsOfExperience
                : yearsOfExperience // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRecommendations: null == totalRecommendations
                ? _value.totalRecommendations
                : totalRecommendations // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CaregiverProfileImplCopyWith<$Res>
    implements $CaregiverProfileCopyWith<$Res> {
  factory _$$CaregiverProfileImplCopyWith(
    _$CaregiverProfileImpl value,
    $Res Function(_$CaregiverProfileImpl) then,
  ) = __$$CaregiverProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String about,
    List<String> services,
    bool isVerified,
    bool isAvailable,
    List<String> languages,
    DateTime? joinedDate,
    int yearsOfExperience,
    int totalRecommendations,
  });
}

/// @nodoc
class __$$CaregiverProfileImplCopyWithImpl<$Res>
    extends _$CaregiverProfileCopyWithImpl<$Res, _$CaregiverProfileImpl>
    implements _$$CaregiverProfileImplCopyWith<$Res> {
  __$$CaregiverProfileImplCopyWithImpl(
    _$CaregiverProfileImpl _value,
    $Res Function(_$CaregiverProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CaregiverProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? about = null,
    Object? services = null,
    Object? isVerified = null,
    Object? isAvailable = null,
    Object? languages = null,
    Object? joinedDate = freezed,
    Object? yearsOfExperience = null,
    Object? totalRecommendations = null,
  }) {
    return _then(
      _$CaregiverProfileImpl(
        about: null == about
            ? _value.about
            : about // ignore: cast_nullable_to_non_nullable
                  as String,
        services: null == services
            ? _value._services
            : services // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAvailable: null == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        languages: null == languages
            ? _value._languages
            : languages // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        joinedDate: freezed == joinedDate
            ? _value.joinedDate
            : joinedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        yearsOfExperience: null == yearsOfExperience
            ? _value.yearsOfExperience
            : yearsOfExperience // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRecommendations: null == totalRecommendations
            ? _value.totalRecommendations
            : totalRecommendations // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CaregiverProfileImpl implements _CaregiverProfile {
  const _$CaregiverProfileImpl({
    this.about = '',
    final List<String> services = const [],
    this.isVerified = false,
    this.isAvailable = true,
    final List<String> languages = const [],
    this.joinedDate,
    this.yearsOfExperience = 0,
    this.totalRecommendations = 0,
  }) : _services = services,
       _languages = languages;

  factory _$CaregiverProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaregiverProfileImplFromJson(json);

  @override
  @JsonKey()
  final String about;
  // A short bio
  final List<String> _services;
  // A short bio
  @override
  @JsonKey()
  List<String> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  // Skills like 'Shadow Teacher'
  @override
  @JsonKey()
  final bool isVerified;
  // Blue checkmark status
  @override
  @JsonKey()
  final bool isAvailable;
  // Ready for work?
  final List<String> _languages;
  // Ready for work?
  @override
  @JsonKey()
  List<String> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  // Languages spoken
  @override
  final DateTime? joinedDate;
  @override
  @JsonKey()
  final int yearsOfExperience;
  @override
  @JsonKey()
  final int totalRecommendations;

  @override
  String toString() {
    return 'CaregiverProfile(about: $about, services: $services, isVerified: $isVerified, isAvailable: $isAvailable, languages: $languages, joinedDate: $joinedDate, yearsOfExperience: $yearsOfExperience, totalRecommendations: $totalRecommendations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaregiverProfileImpl &&
            (identical(other.about, about) || other.about == about) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            const DeepCollectionEquality().equals(
              other._languages,
              _languages,
            ) &&
            (identical(other.joinedDate, joinedDate) ||
                other.joinedDate == joinedDate) &&
            (identical(other.yearsOfExperience, yearsOfExperience) ||
                other.yearsOfExperience == yearsOfExperience) &&
            (identical(other.totalRecommendations, totalRecommendations) ||
                other.totalRecommendations == totalRecommendations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    about,
    const DeepCollectionEquality().hash(_services),
    isVerified,
    isAvailable,
    const DeepCollectionEquality().hash(_languages),
    joinedDate,
    yearsOfExperience,
    totalRecommendations,
  );

  /// Create a copy of CaregiverProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaregiverProfileImplCopyWith<_$CaregiverProfileImpl> get copyWith =>
      __$$CaregiverProfileImplCopyWithImpl<_$CaregiverProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CaregiverProfileImplToJson(this);
  }
}

abstract class _CaregiverProfile implements CaregiverProfile {
  const factory _CaregiverProfile({
    final String about,
    final List<String> services,
    final bool isVerified,
    final bool isAvailable,
    final List<String> languages,
    final DateTime? joinedDate,
    final int yearsOfExperience,
    final int totalRecommendations,
  }) = _$CaregiverProfileImpl;

  factory _CaregiverProfile.fromJson(Map<String, dynamic> json) =
      _$CaregiverProfileImpl.fromJson;

  @override
  String get about; // A short bio
  @override
  List<String> get services; // Skills like 'Shadow Teacher'
  @override
  bool get isVerified; // Blue checkmark status
  @override
  bool get isAvailable; // Ready for work?
  @override
  List<String> get languages; // Languages spoken
  @override
  DateTime? get joinedDate;
  @override
  int get yearsOfExperience;
  @override
  int get totalRecommendations;

  /// Create a copy of CaregiverProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaregiverProfileImplCopyWith<_$CaregiverProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
