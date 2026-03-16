import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActionZoneState { unauthenticated, none, pending, accepted }

final actionZoneStateProvider = FutureProvider.autoDispose
    .family<ActionZoneState, String>((ref, caregiverId) async {
      final user = ref.watch(currentUserProvider).value;
      if (user == null || user.isGuest) return ActionZoneState.unauthenticated;

      final repo = ref.watch(caregiverRepositoryProvider);
      final status = await repo.getRequestStatus(
        parentId: user.id,
        caregiverId: caregiverId,
      );

      return switch (status) {
        null => ActionZoneState.none,
        RequestStatus.pending => ActionZoneState.pending,
        RequestStatus.accepted => ActionZoneState.accepted,
        RequestStatus.rejected => ActionZoneState.none,
      };
    });

final hasRecommendedProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, caregiverId) async {
      final user = ref.watch(currentUserProvider).value;
      if (user == null || user.isGuest) return false;

      final repo = ref.watch(caregiverRepositoryProvider);
      return repo.hasRecommended(
        parentId: user.id,
        caregiverId: caregiverId,
      );
    });
