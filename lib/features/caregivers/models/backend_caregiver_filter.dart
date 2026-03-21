/// Filter & sort parameters for the backend-powered caregivers list.
/// Maps directly to the query params accepted by `/api/services/services/`.
class BackendCaregiverFilter {
  final String? serviceType; // Online | Offline | Hybrid
  final String? paymentType; // Paid | Unpaid
  final String? gender; // Male | Female | Any
  final BackendCaregiverSort sort;

  const BackendCaregiverFilter({
    this.serviceType,
    this.paymentType,
    this.gender,
    this.sort = BackendCaregiverSort.recommended,
  });

  BackendCaregiverFilter copyWith({
    String? serviceType,
    String? paymentType,
    String? gender,
    BackendCaregiverSort? sort,
    bool clearServiceType = false,
    bool clearPaymentType = false,
    bool clearGender = false,
  }) {
    return BackendCaregiverFilter(
      serviceType: clearServiceType ? null : (serviceType ?? this.serviceType),
      paymentType: clearPaymentType ? null : (paymentType ?? this.paymentType),
      gender: clearGender ? null : (gender ?? this.gender),
      sort: sort ?? this.sort,
    );
  }

  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    if (serviceType != null) params['service_type'] = serviceType!;
    if (paymentType != null) params['payment_type'] = paymentType!;
    if (gender != null) params['target_gender'] = gender!;
    return params;
  }

  bool get isEmpty =>
      serviceType == null &&
      paymentType == null &&
      gender == null &&
      sort == BackendCaregiverSort.recommended;

  int get activeCount =>
      (serviceType != null ? 1 : 0) +
      (paymentType != null ? 1 : 0) +
      (gender != null ? 1 : 0);
}

enum BackendCaregiverSort { recommended, nameAsc, nameDesc }
