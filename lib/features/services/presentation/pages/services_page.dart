import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/services/data/services_repository.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:cwsn/features/services/presentation/widgets/horizontal_service_row.dart';
import 'package:cwsn/features/services/presentation/widgets/horizontal_service_row_skeleton.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final ServiceRepository _repository = ServiceRepository();
  late Future<List<ServiceSection>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = _repository.getServicesList();
  }

  @override
  Widget build(BuildContext context) {
    return PillScaffold(
      title: 'Services',
      body: (context, padding) => FutureBuilder(
        future: _servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              padding: padding.copyWith(left: 0, right: 0),
              itemCount: 3,
              itemBuilder: (_, _) => const HorizontalServiceRowSkeleton(),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading services'));
          }

          final sections = snapshot.data ?? [];

          if (sections.isEmpty) {
            return Center(child: Text('No services available'));
          }

          return ListView.builder(
            padding: padding.copyWith(left: 0, right: 0),
            itemCount: sections.length,
            itemBuilder: (_, index) {
              final section = sections[index];

              return HorizontalServiceRow(section: section);
            },
          );
        },
      ),
    );
  }
}
