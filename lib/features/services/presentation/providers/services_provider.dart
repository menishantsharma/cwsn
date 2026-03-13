import 'package:cwsn/features/services/data/services_repository.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches the full service catalog organized by section.
final servicesListProvider = FutureProvider.autoDispose<List<ServiceSection>>((
  ref,
) async {
  return ref.watch(serviceRepositoryProvider).getServicesList();
});
