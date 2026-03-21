import 'package:freezed_annotation/freezed_annotation.dart';

part 'caregiver_profile_model.freezed.dart';
part 'caregiver_profile_model.g.dart';

@freezed
class CaregiverProfile with _$CaregiverProfile {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CaregiverProfile({
    required int id,
    required String name,
    required int age,
    required String gender,
    required String qualifications,
    @Default('') String recommendations,
    @Default(0) int upvoteCount,
    @Default([]) List<String> languages,
    @Default('') String regionName,
    @Default('') String contactNo,
  }) = _CaregiverProfile;

  factory CaregiverProfile.fromJson(Map<String, dynamic> json) =>
      _$CaregiverProfileFromJson(json);
}
