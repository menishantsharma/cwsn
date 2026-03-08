import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_model.freezed.dart';
part 'request_model.g.dart';

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
  const CaregiverRequest._();

  const factory CaregiverRequest({
    required String id,
    required String parentId,
    required String parentName,
    String? parentImageUrl,
    required String parentLocation,
    required String childName,
    required int childAge,
    required String childGender,
    required String specialNeed,
    required String serviceName,

    @Default(RequestStatus.pending) RequestStatus status,
    required DateTime createdAt,
  }) = _CaregiverRequest;

  factory CaregiverRequest.fromJson(Map<String, dynamic> json) =>
      _$CaregiverRequestFromJson(json);

  String get childInfo => "$childName ($childGender, $childAge yrs)";
  String get serviceHeader => "$serviceName | $specialNeed";

  bool get isPending => status == RequestStatus.pending;
  bool get isAccepted => status == RequestStatus.accepted;
  bool get isRejected => status == RequestStatus.rejected;

  String get parentInitials {
    if (parentName.isEmpty) return '?';
    final names = parentName.trim().split(' ');
    if (names.length > 1) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return names[0][0].toUpperCase();
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
