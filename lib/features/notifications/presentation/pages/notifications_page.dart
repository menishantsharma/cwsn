import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/guest_placeholder.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:cwsn/features/notifications/presentation/providers/notification_provider.dart';
import 'package:cwsn/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for HapticFeedback
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;

    if (user == null) return const SizedBox.shrink();

    if (user.isGuest) {
      return Scaffold(
        appBar: const AppTopBar(title: 'Notifications', showBackButton: false),
        body: GuestPlaceholder(
          title: "No Notifications",
          message: "Please login to see your updates and messages.",
          onLoginPressed: () => ref.read(currentUserProvider.notifier).logout(),
        ),
      );
    }

    // Watch notifications list state
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppTopBar(
        title: 'Notifications',
        showBackButton: false,
        actions: [
          // Logic to show "Mark all as read" only if unread items exist
          if (notificationsAsync.value?.any((n) => !n.isRead) ?? false)
            IconButton(
              tooltip: 'Mark all as read',
              icon: const Icon(Icons.done_all_rounded, color: Colors.black87),
              onPressed: () {
                HapticFeedback.mediumImpact(); // Premium tactile feel
                ref.read(notificationsProvider.notifier).markAllAsRead();
              },
            ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, _) => Center(child: Text('Failed to load: $err')),
        data: (notifications) {
          if (notifications.isEmpty) {
            return _EmptyNotificationsState(
              isCaregiver: user.activeRole == UserRole.caregiver,
            );
          }

          return RefreshIndicator.adaptive(
            onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              separatorBuilder: (_, _) =>
                  Divider(height: 1, indent: 80, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return NotificationTile(
                  notification: item,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref
                        .read(notificationsProvider.notifier)
                        .markAsRead(item.id);
                    _handleNavigation(context, item);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleNavigation(BuildContext context, NotificationItem item) {
    switch (item.type) {
      case NotificationType.requestAccepted:
        if (item.relatedId != null) {
          context.pushNamed(AppRoutes.caregiverProfile, extra: item.relatedId);
        }
        break;
      default:
        break;
    }
  }
}

class _EmptyNotificationsState extends StatelessWidget {
  final bool isCaregiver;
  const _EmptyNotificationsState({required this.isCaregiver});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCaregiver
                  ? Icons.work_outline_rounded
                  : Icons.notifications_none_rounded,
              size: 48,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'All caught up!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            isCaregiver
                ? 'No new service requests yet.'
                : 'No new updates for you.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
