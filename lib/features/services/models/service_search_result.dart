import 'package:cwsn/features/services/models/caregiver_profile_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_search_result.freezed.dart';
part 'service_search_result.g.dart';

@freezed
class ServiceSearchResult with _$ServiceSearchResult {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ServiceSearchResult({
    required int id,
    required String title,
    required String description,
    String? image,
    String? categoryName,
    required String serviceType,
    required String paymentType,
    required String targetGender,
    int? targetAgeMin,
    int? targetAgeMax,
    @Default([]) List<String> targetDisabilitiesNames,
    CaregiverProfile? caregiverProfile,
  }) = _ServiceSearchResult;

  factory ServiceSearchResult.fromJson(Map<String, dynamic> json) =>
      _$ServiceSearchResultFromJson(json);
}
