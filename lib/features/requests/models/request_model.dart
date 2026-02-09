enum RequestStatus { pending, accepted, rejected }

class CaregiverRequest {
  final String id;
  final String parentId;
  final String parentName;
  final String parentImageUrl;
  final String parentLocation;

  final String childName;
  final int childAge;
  final String childGender;
  final String specialNeed;

  final String serviceName;

  final RequestStatus status;

  CaregiverRequest({
    required this.id,
    required this.parentId,
    required this.parentName,
    required this.parentImageUrl,
    required this.parentLocation,
    required this.childName,
    required this.childAge,
    required this.childGender,
    required this.specialNeed,
    required this.serviceName,
    this.status = RequestStatus.pending,
  });

  String get childDescription => "For $childGender Child of $childAge years";
  String get serviceDescription => "$specialNeed | $serviceName";

  CaregiverRequest copyWith({RequestStatus? status}) {
    return CaregiverRequest(
      id: id,
      parentId: parentId,
      parentName: parentName,
      parentImageUrl: parentImageUrl,
      parentLocation: parentLocation,
      childName: childName,
      childAge: childAge,
      childGender: childGender,
      specialNeed: specialNeed,
      serviceName: serviceName,
      status: status ?? this.status,
    );
  }
}
