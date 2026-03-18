import 'package:cwsn/features/services/data/services_data.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>(
  (ref) => FakeServiceRepository(),
);

abstract class ServiceRepository {
  Future<List<ServiceSection>> getServicesList();

  /// Returns all [ServiceItem]s for a single category identified by [sectionTitle].
  ///
  /// Throws a [StateError] if no section with that title exists.
  Future<List<ServiceItem>> getServicesByCategory(String sectionTitle);
}

class FakeServiceRepository implements ServiceRepository {
  Future<void> _delay() => Future.delayed(const Duration(seconds: 2));

  @override
  Future<List<ServiceSection>> getServicesList() async {
    await _delay();
    return mockServiceSections;
  }

  @override
  Future<List<ServiceItem>> getServicesByCategory(String sectionTitle) async {
    await _delay();
    return mockServiceSections
        .firstWhere(
          (s) => s.title == sectionTitle,
          orElse: () => throw StateError(
            'No section found for title: $sectionTitle',
          ),
        )
        .items;
  }
}
