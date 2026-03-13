import 'package:cwsn/core/data/user_data.dart';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/caregivers/models/caregiver_filter.dart';
import 'package:cwsn/features/caregivers/models/caregiver_sort.dart';
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
}

class FakeCaregiverRepository implements CaregiverRepository {
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
  }
}
