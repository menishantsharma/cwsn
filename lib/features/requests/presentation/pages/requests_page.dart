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
  List<CaregiverRequest>? _localRequests;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final allRequests = await _repository.getRequests();
      final pendingRequests = allRequests
          .where((r) => r.status == RequestStatus.pending)
          .toList();

      if (mounted) {
        setState(() {
          _localRequests = pendingRequests;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _handleAction(String requestId, bool isAccepted) async {
    final requestIndex =
        _localRequests?.indexWhere((r) => r.id == requestId) ?? -1;
    if (requestIndex == -1) return;
    final removedItem = _localRequests![requestIndex];

    setState(() {
      _localRequests?.removeAt(requestIndex);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isAccepted ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              isAccepted ? "Accepted" : "Declined",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: isAccepted ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,

        margin: const EdgeInsets.only(bottom: 70, left: 16, right: 16),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      if (isAccepted) {
        await _repository.acceptRequest(requestId);
      } else {
        await _repository.rejectRequest(requestId);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _localRequests?.insert(requestIndex, removedItem);
        });

        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Action failed. Please try again."),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 70, left: 16, right: 16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PillScaffold(
      title: 'Requests',
      actionIcon: Icons.history_rounded,
      onActionPressed: () {},

      body: (context, padding) {
        if (_isLoading) {
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

        if (_error != null) {
          return Center(child: Text('Error: $_error'));
        }

        if (_localRequests == null || _localRequests!.isEmpty) {
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
          itemCount: _localRequests!.length,
          itemBuilder: (context, index) =>
              RequestTile(
                    request: _localRequests![index],
                    onAccept: () {
                      _handleAction(_localRequests![index].id, true);
                    },
                    onReject: () {
                      _handleAction(_localRequests![index].id, false);
                    },
                  )
                  .animate()
                  .fade(duration: 400.ms, delay: (100 * index).ms)
                  .slideY(begin: 0.1, end: 0, delay: (100 * index).ms),
        );
      },
    );
  }
}
