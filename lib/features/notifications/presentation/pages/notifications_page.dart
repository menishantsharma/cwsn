import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/guest_placeholder.dart';
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
    final user = ref.watch(currentUserProvider).value;

    if (user == null) return const SizedBox.shrink();

    final isCaregiver = user.activeRole == UserRole.caregiver;

    if (user.isGuest) {
      return Scaffold(
        appBar: AppTopBar(title: 'Notifications'),
        body: GuestPlaceholder(
          title: "No Notifications",
          message: "Please login to see your updates and messages.",
          onLoginPressed: () => ref.read(currentUserProvider.notifier).logout(),
        ),
      );
    }

    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: 'Notifications',
        actions: [
          if (notificationsAsync.hasValue &&
              notificationsAsync.value!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.done_all_rounded),
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllAsRead();
              },
            ),
        ],
        showBackButton: false,
      ),

      body: notificationsAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: 6,
          itemBuilder: (_, _) => const NotificationSkeletonTile()
              .animate(onPlay: (c) => c.repeat())
              .shimmer(color: Colors.grey.shade200, duration: 1200.ms),
        ),

        error: (err, stack) => Center(child: Text('Error: $err')),

        data: (notifications) {
          if (notifications.isEmpty) {
            return _EmptyNotificationsState(isCaregiver: isCaregiver);
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(notificationsProvider),
            color: Theme.of(context).primaryColor,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return NotificationTile(
                      notification: notification,
                      onTap: () {
                        ref
                            .read(notificationsProvider.notifier)
                            .markAsRead(notification.id);

                        switch (notification.type) {
                          case NotificationType.requestAccepted:
                            if (notification.relatedId != null) {
                              context.pushNamed(
                                AppRoutes.caregiverProfile,
                                extra: notification.relatedId,
                              );
                            }
                            break;

                          case NotificationType.requestReceived:
                            break;

                          case NotificationType.message:
                            break;

                          default:
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
      ),
    );
  }
}

class _EmptyNotificationsState extends StatelessWidget {
  final bool isCaregiver;

  const _EmptyNotificationsState({required this.isCaregiver});

  @override
  Widget build(BuildContext context) {
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
