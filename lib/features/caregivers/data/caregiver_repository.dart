import 'package:cwsn/core/data/user_data.dart';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/caregivers/models/caregiver_filter.dart';
import 'package:cwsn/features/caregivers/models/caregiver_sort.dart';
import 'package:cwsn/features/requests/data/requests_data.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the active [CaregiverRepository] implementation.
final caregiverRepositoryProvider = Provider<CaregiverRepository>(
  (ref) => FakeCaregiverRepository(),
);

/// Contract for caregiver listing, detail fetching, and service requests.
abstract class CaregiverRepository {
  Future<List<User>> getCaregiversList({
    CaregiverFilter? filter,
    CaregiverSortOption sort = CaregiverSortOption.recommended,
  });
  Future<User> getCaregiverDetails(String id);
  Future<void> sendRequest({
    required String parentId,
    required String caregiverId,
    required String childId,
  });
  Future<RequestStatus?> getRequestStatus({
    required String parentId,
    required String caregiverId,
  });
  Future<void> unsendRequest({
    required String parentId,
    required String caregiverId,
  });
  Future<int> toggleRecommendation({
    required String caregiverId,
    required bool isCurrentlyRecommended,
  });
  Future<bool> hasRecommended({
    required String parentId,
    required String caregiverId,
  });
}

class FakeCaregiverRepository implements CaregiverRepository {
  static final _recommendations = <String>{};

  static String _recKey(String parentId, String caregiverId) =>
      '$parentId:$caregiverId';

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<List<User>> getCaregiversList({
    CaregiverFilter? filter,
    CaregiverSortOption sort = CaregiverSortOption.recommended,
  }) async {
    await _simulateNetworkDelay();

    var results = List<User>.from(caregivers);

    if (filter != null && !filter.isEmpty) {
      results = results.where((user) {
        final profile = user.caregiverProfile;
        if (profile == null) return false;

        if (filter.gender != null) {
          final userGender = user.gender == Gender.male ? 'Male' : 'Female';
          if (userGender != filter.gender) return false;
        }

        if (filter.languages.isNotEmpty) {
          final hasLanguage = filter.languages.any(
            (lang) => profile.languages.contains(lang),
          );
          if (!hasLanguage) return false;
        }

        if (filter.services.isNotEmpty) {
          final hasService = filter.services.any(
            (svc) => profile.services.any((s) => s.name == svc && s.isActive),
          );
          if (!hasService) return false;
        }

        if (filter.isAvailable != null) {
          if (profile.isAvailable != filter.isAvailable) return false;
        }

        return true;
      }).toList();
    }

    switch (sort) {
      case CaregiverSortOption.recommended:
        results.sort(
          (a, b) => (b.caregiverProfile?.totalRecommendations ?? 0)
              .compareTo(a.caregiverProfile?.totalRecommendations ?? 0),
        );
      case CaregiverSortOption.experience:
        results.sort(
          (a, b) => (b.caregiverProfile?.yearsOfExperience ?? 0)
              .compareTo(a.caregiverProfile?.yearsOfExperience ?? 0),
        );
      case CaregiverSortOption.nameAsc:
        results.sort((a, b) => a.fullName.compareTo(b.fullName));
      case CaregiverSortOption.nameDesc:
        results.sort((a, b) => b.fullName.compareTo(a.fullName));
    }

    return results;
  }

  @override
  Future<User> getCaregiverDetails(String id) async {
    await _simulateNetworkDelay();
    final user = caregivers.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Caregiver not found'),
    );
    return user;
  }

  @override
  Future<void> sendRequest({
    required String parentId,
    required String caregiverId,
    required String childId,
  }) async {
    await _simulateNetworkDelay();
    mockRequests.add(
      CaregiverRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        parentId: parentId,
        caregiverId: caregiverId,
        parentName: '',
        parentLocation: '',
        childName: '',
        childAge: 0,
        childGender: '',
        specialNeed: '',
        serviceName: '',
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<RequestStatus?> getRequestStatus({
    required String parentId,
    required String caregiverId,
  }) async {
    try {
      final match = mockRequests.firstWhere(
        (r) => r.parentId == parentId && r.caregiverId == caregiverId,
      );
      return match.status;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> unsendRequest({
    required String parentId,
    required String caregiverId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    mockRequests.removeWhere(
      (r) => r.parentId == parentId && r.caregiverId == caregiverId,
    );
  }

  @override
  Future<int> toggleRecommendation({
    required String caregiverId,
    required bool isCurrentlyRecommended,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = caregivers.indexWhere((c) => c.id == caregiverId);
    if (idx == -1) throw Exception('Caregiver not found');
    final profile = caregivers[idx].caregiverProfile!;
    final newCount = isCurrentlyRecommended
        ? (profile.totalRecommendations - 1).clamp(0, 999999)
        : profile.totalRecommendations + 1;
    caregivers[idx] = caregivers[idx].copyWith(
      caregiverProfile: profile.copyWith(totalRecommendations: newCount),
    );
    // Track in the set — we don't have parentId here, so we use a
    // wildcard key. In a real API this would be server-side.
    final key = _recKey('*', caregiverId);
    if (isCurrentlyRecommended) {
      _recommendations.remove(key);
    } else {
      _recommendations.add(key);
    }
    return newCount;
  }

  @override
  Future<bool> hasRecommended({
    required String parentId,
    required String caregiverId,
  }) async {
    return _recommendations.contains(_recKey('*', caregiverId));
  }
}
