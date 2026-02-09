import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/requests/data/requests_repository.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:cwsn/features/requests/presentation/widgets/request_tile.dart';
import 'package:cwsn/features/requests/presentation/widgets/request_tile_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      // Optional: Add a refresh button or filter in the header
      actionIcon: Icons.history_rounded,
      onActionPressed: () {},

      body: (context, padding) => FutureBuilder(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              padding: padding.copyWith(left: 20, right: 20),
              itemCount: 4,
              itemBuilder: (_, _) => const RequestTileSkeleton()
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(
                    duration: 1200.ms,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final requests = snapshot.data as List<CaregiverRequest>;

          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.inbox_rounded,
                      size: 40,
                      color: Color(0xFF535CE8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Pending Requests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'New bookings will appear here.',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            ).animate().fade().scale();
          }

          return ListView.builder(
            padding: padding.copyWith(left: 20, right: 20, bottom: 80),
            itemCount: requests.length,
            itemBuilder: (context, index) =>
                RequestTile(
                      request: requests[index],
                      onAccept: () {
                        // Add logic
                      },
                      onReject: () {
                        // Add logic
                      },
                    )
                    .animate()
                    .fade(duration: 400.ms, delay: (100 * index).ms)
                    .slideY(begin: 0.1, end: 0, delay: (100 * index).ms),
          );
        },
      ),
    );
  }
}
