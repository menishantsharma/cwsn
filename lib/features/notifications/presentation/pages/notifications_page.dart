import 'package:cwsn/core/providers/user_mode_provider.dart';
import 'package:cwsn/core/router/app_router.dart';
import 'package:cwsn/core/widgets/guest_placeholder.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:cwsn/features/notifications/presentation/providers/notification_provider.dart';
import 'package:cwsn/features/notifications/presentation/widgets/notification_skeleton_tile.dart';
import 'package:cwsn/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCaregiverMode = ref.watch(userModeProvider);
    final user = ref.watch(currentUserProvider);

    // Watch the Riverpod state
    final notificationsState = ref.watch(notificationsProvider);

    if (user == null) return const SizedBox.shrink();

    // GUEST VIEW
    if (user.isGuest) {
      return PillScaffold(
        title: 'Notifications',
        showBack: false,
        body: (context, padding) => GuestPlaceholder(
          title: "No Notifications",
          message: "Please login to see your updates and messages.",
          onLoginPressed: () {
            ref.read(currentUserProvider.notifier).state = null;
          },
        ),
      );
    }

    // AUTHENTICATED VIEW
    return PillScaffold(
      title: 'Notifications',
      showBack: false,
      actionIcon: Icons.done_all_rounded,
      onActionPressed: () {
        ref.read(notificationsProvider.notifier).markAllAsRead();
      },

      body: (context, padding) {
        return notificationsState.when(
          // LOADING STATE
          loading: () => ListView.builder(
            padding: padding.copyWith(left: 20, right: 20),
            itemCount: 6,
            itemBuilder: (_, _) => const NotificationSkeletonTile()
                .animate(onPlay: (c) => c.repeat())
                .shimmer(color: Colors.grey.shade200, duration: 1200.ms),
          ),

          error: (err, stack) => Center(child: Text('Error: $err')),

          data: (notifications) {
            if (notifications.isEmpty) return _buildEmptyState(isCaregiverMode);

            return RefreshIndicator(
              onRefresh: () => ref.read(notificationsProvider.notifier).fetch(),
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                padding: padding.copyWith(left: 20, right: 20, bottom: 80),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  return NotificationTile(
                        notification: notification,
                        onTap: () {
                          // 1. Mark as read instantly in UI & Backend
                          ref
                              .read(notificationsProvider.notifier)
                              .markAsRead(notification.id);

                          // 2. Handle Navigation Logic based on Notification Type
                          switch (notification.type) {
                            case NotificationType.requestAccepted:
                              // PARENT: Open the Caregiver's Profile
                              if (notification.relatedId != null) {
                                context.pushNamed(
                                  AppRoutes.caregiverProfile,
                                  extra: notification
                                      .relatedId, // Pass the Caregiver ID
                                );
                              }
                              break;

                            case NotificationType.requestReceived:
                              // CAREGIVER: Go to the Requests Tab
                              break;

                            case NotificationType.message:
                              break;

                            default:
                              // Just marked as read, do nothing else
                              break;
                          }
                        },
                      )
                      .animate()
                      .fade(duration: 400.ms, delay: (50 * index).ms)
                      .slideX(
                        begin: 0.1,
                        end: 0,
                        duration: 400.ms,
                        curve: Curves.easeOutQuad,
                        delay: (50 * index).ms,
                      );
                },
              ),
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
            decoration: const BoxDecoration(
              color: Color(0xFFF5F7FF),
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
          const Text(
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
