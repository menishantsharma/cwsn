import 'package:cwsn/core/providers/user_mode_provider.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/notifications/data/notification_repository.dart';
import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:cwsn/features/notifications/widgets/notification_tile.dart';
// Create a skeleton similar to previous examples if needed
import 'package:cwsn/features/notifications/widgets/notification_skeleton_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final NotificationRepository _repository = NotificationRepository();

  @override
  Widget build(BuildContext context) {
    final isCaregiverMode = ref.watch(userModeProvider);

    return PillScaffold(
      title: 'Notifications',
      actionIcon: Icons.done_all_rounded, // "Mark all read" button
      onActionPressed: () {},

      body: (context, padding) {
        return FutureBuilder<List<NotificationItem>>(
          future: _repository.fetchNotifications(isCaregiver: isCaregiverMode),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                padding: padding.copyWith(left: 20, right: 20),
                itemCount: 6,
                itemBuilder: (_, _) => const NotificationSkeletonTile()
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(color: Colors.grey.shade200, duration: 1200.ms),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final notifications = snapshot.data ?? [];

            if (notifications.isEmpty) {
              return _buildEmptyState(isCaregiverMode);
            }

            return ListView.builder(
              padding: padding.copyWith(left: 20, right: 20, bottom: 80),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationTile(
                      notification: notifications[index],
                      onTap: () {
                        // Handle tap
                      },
                    )
                    .animate()
                    .fade(duration: 400.ms, delay: (50 * index).ms)
                    .slideX(
                      begin: 0.1, // Slide in from right slightly
                      end: 0,
                      duration: 400.ms,
                      curve: Curves.easeOutQuad,
                      delay: (50 * index).ms,
                    );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(bool isCaregiver) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FF), // Soft Blue
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCaregiver
                  ? Icons.work_off_rounded
                  : Icons.notifications_off_rounded,
              size: 48,
              color: const Color(0xFF535CE8).withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isCaregiver
                ? 'You have no new requests from parents.'
                : 'You have no new updates from caregivers.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ).animate().fade().scale(),
    );
  }
}
