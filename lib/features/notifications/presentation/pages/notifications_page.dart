import 'package:cwsn/core/models/user_model.dart';
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
    // 1. OPTIMIZED: Properly extract the user value from the AsyncValue
    final user = ref.watch(currentUserProvider).value;

    if (user == null) return const SizedBox.shrink();

    // 2. OPTIMIZED: Derive the role locally instead of watching another provider
    final isCaregiver = user.activeRole == UserRole.caregiver;

    // --- GUEST VIEW ---
    if (user.isGuest) {
      return PillScaffold(
        title: 'Notifications',
        showBack: false,
        body: (context, padding) => GuestPlaceholder(
          title: "No Notifications",
          message: "Please login to see your updates and messages.",
          // 3. OPTIMIZED: Use the proper logout method
          onLoginPressed: () => ref.read(currentUserProvider.notifier).logout(),
        ),
      );
    }

    // --- AUTHENTICATED VIEW ---
    final notificationsAsync = ref.watch(notificationsProvider);

    return PillScaffold(
      title: 'Notifications',
      showBack: false,
      // Only show the "Mark All Read" icon if there is actual data
      actionIcon:
          notificationsAsync.hasValue && notificationsAsync.value!.isNotEmpty
          ? Icons.done_all_rounded
          : null,
      onActionPressed: () {
        ref.read(notificationsProvider.notifier).markAllAsRead();
      },

      body: (context, padding) {
        return notificationsAsync.when(
          // --- LOADING STATE ---
          loading: () => ListView.builder(
            padding: padding.copyWith(left: 20, right: 20),
            itemCount: 6,
            itemBuilder: (_, _) => const NotificationSkeletonTile()
                .animate(onPlay: (c) => c.repeat())
                .shimmer(color: Colors.grey.shade200, duration: 1200.ms),
          ),

          // --- ERROR STATE ---
          error: (err, stack) => Center(child: Text('Error: $err')),

          // --- DATA STATE ---
          data: (notifications) {
            if (notifications.isEmpty) {
              return _EmptyNotificationsState(isCaregiver: isCaregiver);
            }

            return RefreshIndicator(
              // 4. OPTIMIZED: The most efficient way to refresh an AsyncNotifier in Riverpod 2+
              // Invalidate forces Riverpod to drop the current state and run build() again
              onRefresh: () async => ref.invalidate(notificationsProvider),
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                padding: padding.copyWith(left: 20, right: 20, bottom: 80),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  return NotificationTile(
                        notification: notification,
                        onTap: () {
                          // Mark as read instantly in UI & Backend
                          ref
                              .read(notificationsProvider.notifier)
                              .markAsRead(notification.id);

                          // Handle Navigation Logic based on Notification Type
                          switch (notification.type) {
                            case NotificationType.requestAccepted:
                              // PARENT: Open the Caregiver's Profile
                              if (notification.relatedId != null) {
                                context.pushNamed(
                                  AppRoutes.caregiverProfile,
                                  extra: notification.relatedId,
                                );
                              }
                              break;

                            case NotificationType.requestReceived:
                              // CAREGIVER: Go to the Requests Tab
                              break;

                            case NotificationType.message:
                              // Navigate to chat (Future)
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
}

// ==========================================
// 5. OPTIMIZED: EXTRACTED STATELESS WIDGET
// ==========================================
// Moving this out of the main build method prevents the entire
// NotificationsPage from rebuilding when it's just showing the empty state.
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
