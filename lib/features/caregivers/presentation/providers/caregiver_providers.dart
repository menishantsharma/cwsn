import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches the full list of available caregivers.
final caregiversListProvider = FutureProvider.autoDispose<List<User>>((
  ref,
) async {
  return ref.watch(caregiverRepositoryProvider).getCaregiversList();
});

/// Fetches a single caregiver's profile by ID.
final caregiverProfileProvider = FutureProvider.autoDispose
    .family<User, String>((ref, caregiverId) async {
      return ref
          .watch(caregiverRepositoryProvider)
          .getCaregiverDetails(caregiverId);
    });
