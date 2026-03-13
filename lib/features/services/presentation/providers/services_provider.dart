import 'package:cwsn/features/services/data/services_repository.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches the full service catalog organized by section (auto-disposed).
final servicesListProvider =
    FutureProvider.autoDispose<List<ServiceSection>>((ref) async {
  return ref.watch(serviceRepositoryProvider).getServicesList();
});

/// Cached master service list -- NOT auto-disposed. Fetched once, reused.
final masterServiceListProvider =
    FutureProvider<List<ServiceSection>>((ref) async {
  return ref.watch(serviceRepositoryProvider).getServicesList();
});

/// Flat list of all unique service names from the master catalog.
final masterServiceNamesProvider = FutureProvider<List<String>>((ref) async {
  final sections = await ref.watch(masterServiceListProvider.future);
  return sections
      .expand((section) => section.items)
      .map((item) => item.title)
      .toSet()
      .toList()
    ..sort();
});
