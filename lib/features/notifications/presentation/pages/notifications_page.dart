import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/core/widgets/error_state_widget.dart';
import 'package:cwsn/core/widgets/guest_placeholder.dart';
import 'package:cwsn/core/widgets/modern_refresh_indicator.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:cwsn/features/notifications/presentation/providers/notification_provider.dart';
import 'package:cwsn/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:cwsn/features/notifications/presentation/widgets/notification_tile_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        appBar: const AppTopBar(title: 'Alerts', showBackButton: false),
        body: GuestPlaceholder(
          title: 'No Notifications',
          message: 'Please login to see your updates and messages.',
          onLoginPressed: () => ref.read(currentUserProvider.notifier).logout(),
        ),
      );
    }

    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppTopBar(
        title: 'Alerts',
        showBackButton: false,
        actions: [
          if (notificationsAsync.value?.any((n) => !n.isRead) ?? false)
            IconButton(
              tooltip: 'Mark all as read',
              icon: const Icon(Icons.done_all_rounded, size: 22),
              onPressed: () {
                HapticFeedback.mediumImpact();
                ref.read(notificationsProvider.notifier).markAllAsRead();
              },
            ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const NotificationsListSkeleton(),
        error: (_, _) => ErrorStateWidget(
          message: 'Failed to load notifications',
          onRetry: () => ref.read(notificationsProvider.notifier).refresh(),
        ),
        data: (notifications) => ModernRefreshIndicatorList(
          onRefresh: () =>
              ref.read(notificationsProvider.notifier).refresh(),
          itemCount: notifications.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          emptyWidget: notifications.isEmpty
              ? SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.25,
                  child: Center(
                    child: EmptyStateWidget(
                      icon: user.activeRole == UserRole.caregiver
                          ? Icons.work_outline_rounded
                          : Icons.notifications_none_rounded,
                      iconSize: 56,
                      title: 'All Caught Up!',
                      subtitle: user.activeRole == UserRole.caregiver
                          ? 'No new service requests yet.'
                          : 'No new updates for you.',
                    ),
                  ),
                )
              : null,
          itemBuilder: (_, index) {
            final item = notifications[index];
            return NotificationTile(
              key: ValueKey(item.id),
              notification: item,
              onTap: () => _act(context, ref, item),
            );
          },
        ),
      ),
    );
  }

  void _act(BuildContext context, WidgetRef ref, NotificationItem item) {
    HapticFeedback.lightImpact();
    ref.read(notificationsProvider.notifier).markAsRead(item.id);
    _handleNavigation(context, item);
  }

  void _handleNavigation(BuildContext context, NotificationItem item) {
    switch (item.type) {
      case NotificationType.requestAccepted:
        if (item.relatedId != null) {
          context.pushNamed(AppRoutes.caregiverProfile, extra: item.relatedId);
        }
      default:
        break;
    }
  }
}
