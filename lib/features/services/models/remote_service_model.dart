import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_service_model.freezed.dart';
part 'remote_service_model.g.dart';

/// Mirrors the shape returned by `GET /api/services/services/`.
@freezed
class RemoteService with _$RemoteService {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RemoteService({
    required int id,
    required String title,
    required String description,
    String? image,
    String? categoryName,
    required String serviceType,
    required String paymentType,
    required bool isActive,
    int? targetAgeMin,
    int? targetAgeMax,
    required String targetGender,
    int? maxParticipants,
  }) = _RemoteService;

  factory RemoteService.fromJson(Map<String, dynamic> json) =>
      _$RemoteServiceFromJson(json);
}
