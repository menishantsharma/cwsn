import 'package:cwsn/features/special_needs/data/special_needs_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Full browsing list of all special needs (for the Special Needs page).
final specialNeedsProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(specialNeedsRepositoryProvider).getAll();
});

/// Special needs filtered by a specific service name.
/// Used in AddEditServiceSheet to show only relevant options.
final specialNeedsByServiceProvider =
    FutureProvider.autoDispose.family<List<String>, String>(
  (ref, serviceName) async {
    return ref.watch(specialNeedsRepositoryProvider).getByService(serviceName);
  },
);
