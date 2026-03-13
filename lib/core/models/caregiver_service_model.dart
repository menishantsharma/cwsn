import 'package:freezed_annotation/freezed_annotation.dart';

part 'caregiver_service_model.freezed.dart';
part 'caregiver_service_model.g.dart';

/// A service offered by a caregiver, with associated special needs and status.
@freezed
class CaregiverService with _$CaregiverService {
  const factory CaregiverService({
    required String id,
    required String name,
    @Default([]) List<String> specialNeeds,
    @Default(true) bool isActive,
  }) = _CaregiverService;

  factory CaregiverService.fromJson(Map<String, dynamic> json) =>
      _$CaregiverServiceFromJson(json);
}
