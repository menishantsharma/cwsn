import 'package:freezed_annotation/freezed_annotation.dart';

part 'caregiver_filter.freezed.dart';
part 'caregiver_filter.g.dart';

/// Type-safe filter parameters for the caregivers list.
@freezed
class CaregiverFilter with _$CaregiverFilter {
  const CaregiverFilter._();

  const factory CaregiverFilter({
    String? gender,
    @Default([]) List<String> languages,
    @Default([]) List<String> services,
    bool? isAvailable,
  }) = _CaregiverFilter;

  factory CaregiverFilter.fromJson(Map<String, dynamic> json) =>
      _$CaregiverFilterFromJson(json);

  bool get isEmpty =>
      gender == null &&
      languages.isEmpty &&
      services.isEmpty &&
      isAvailable == null;

  int get activeCount =>
      (gender != null ? 1 : 0) +
      (languages.isNotEmpty ? 1 : 0) +
      (services.isNotEmpty ? 1 : 0) +
      (isAvailable != null ? 1 : 0);
}
