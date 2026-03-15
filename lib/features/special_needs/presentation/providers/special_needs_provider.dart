import 'package:cwsn/features/special_needs/data/special_needs_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Master list of all special needs (for browsing page).
final specialNeedsProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(specialNeedsRepositoryProvider).getAll();
});

/// Special needs filtered by service name.
///
/// Automatically re-fetches when [serviceName] changes.
/// Auto-disposes when the consuming widget (bottom sheet) unmounts.
final specialNeedsByServiceProvider = FutureProvider.autoDispose
    .family<List<String>, String>((ref, serviceName) async {
      return ref
          .watch(specialNeedsRepositoryProvider)
          .getByService(serviceName);
    });
