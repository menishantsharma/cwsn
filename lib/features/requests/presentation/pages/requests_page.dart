import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/requests/data/requests_repository.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:cwsn/features/requests/presentation/widgets/request_tile.dart';
import 'package:cwsn/features/requests/presentation/widgets/request_tile_skeleton.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final RequestsRepository _repository = RequestsRepository();
  late Future<List<CaregiverRequest>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = _repository.getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return PillScaffold(
      title: 'Requests',
      body: (context, padding) => FutureBuilder(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.separated(
              padding: padding.copyWith(left: 16, right: 16),
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(height: 24),
              itemBuilder: (_, _) => const RequestTileSkeleton(),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final requests = snapshot.data as List<CaregiverRequest>;

          if (requests.isEmpty) {
            return Center(child: Text('No requests at the moment'));
          }

          return ListView.separated(
            padding: padding.copyWith(left: 16, right: 16),
            itemCount: requests.length,
            itemBuilder: (context, index) => RequestTile(
              request: requests[index],
              onAccept: () {},
              onReject: () {},
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 24),
          );
        },
      ),
    );
  }
}
