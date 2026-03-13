import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/settings/data/caregiver_service_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the active [CaregiverServiceNotifier] for managing offered services.
final caregiverServiceNotifierProvider = Provider<CaregiverServiceNotifier>((
  ref,
) {
  return CaregiverServiceNotifier(ref);
});

/// Manages CRUD operations on a caregiver's service list.
///
/// Reads the current user from [currentUserProvider], mutates the
/// caregiver profile through [CaregiverServiceRepository], and writes
/// the result back via [AuthNotifier.updateUser].
class CaregiverServiceNotifier {
  final Ref _ref;
  const CaregiverServiceNotifier(this._ref);

  User? get _user => _ref.read(currentUserProvider).value;
  AuthNotifier get _auth => _ref.read(currentUserProvider.notifier);
  CaregiverServiceRepository get _repo =>
      _ref.read(caregiverServiceRepositoryProvider);

  /// Adds a new service. Returns the saved service name.
  Future<String> addService(String service) async {
    final user = _user;
    if (user == null) throw StateError('No authenticated user');

    final saved = await _repo.addService(
      caregiverId: user.id,
      service: service,
    );

    final current = user.caregiverProfile?.services ?? [];
    final updatedProfile = (user.caregiverProfile ?? const CaregiverProfile())
        .copyWith(services: [...current, saved]);
    _auth.updateUser(user.copyWith(caregiverProfile: updatedProfile));
    return saved;
  }

  /// Updates an existing service. Returns the new service name.
  Future<String> updateService({
    required String oldService,
    required String newService,
  }) async {
    final user = _user;
    if (user == null) throw StateError('No authenticated user');

    final saved = await _repo.updateService(
      caregiverId: user.id,
      oldService: oldService,
      newService: newService,
    );

    final updatedServices = (user.caregiverProfile?.services ?? [])
        .map((s) => s == oldService ? saved : s)
        .toList();
    final updatedProfile = (user.caregiverProfile ?? const CaregiverProfile())
        .copyWith(services: updatedServices);
    _auth.updateUser(user.copyWith(caregiverProfile: updatedProfile));
    return saved;
  }

  /// Deletes a service with optimistic removal and rollback on failure.
  Future<void> deleteService(String service) async {
    final user = _user;
    if (user == null) return;
    final previousProfile = user.caregiverProfile!;

    // Optimistic removal
    final optimistic = previousProfile.copyWith(
      services: previousProfile.services.where((s) => s != service).toList(),
    );
    _auth.updateUser(user.copyWith(caregiverProfile: optimistic));

    try {
      await _repo.deleteService(caregiverId: user.id, service: service);
    } catch (_) {
      _auth.updateUser(user.copyWith(caregiverProfile: previousProfile));
      rethrow;
    }
  }
}
