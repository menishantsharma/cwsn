import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_model.freezed.dart';
part 'request_model.g.dart';

/// The status of a service request from a Parent to a Caregiver.
enum RequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
}

@freezed
class CaregiverRequest with _$CaregiverRequest {
  const CaregiverRequest._(); // Needed for our custom getters below

  const factory CaregiverRequest({
    required String id,
    
    // Parent Details (The person paying for the service)
    required String parentId,
    required String parentName,
    @Default('https://example.com/placeholder.png') String parentImageUrl,
    required String parentLocation,

    // Child Details (The person receiving the care)
    required String childName,
    required int childAge,
    required String childGender,
    required String specialNeed,

    // Service Context
    required String serviceName,

    @Default(RequestStatus.pending) RequestStatus status,
  }) = _CaregiverRequest;

  factory CaregiverRequest.fromJson(Map<String, dynamic> json) =>
      _$CaregiverRequestFromJson(json);

  // --- EASY HELPERS: Makes your UI code look much cleaner ---

  /// Example: "For Male Child of 8 years"
  String get childDescription => "For $childGender Child of $childAge years";

  /// Example: "Autism Support | Speech Therapy"
  String get serviceDescription => "$specialNeed | $serviceName";
  
  /// Helper to check if the request is still actionable
  bool get isPending => status == RequestStatus.pending;
}