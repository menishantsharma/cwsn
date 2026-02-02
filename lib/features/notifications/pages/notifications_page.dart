import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/notifications/data/notification_repository.dart';
import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:cwsn/features/notifications/widgets/notification_skeleton_tile.dart';
import 'package:cwsn/features/notifications/widgets/notification_tile.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationRepository _repository = NotificationRepository();
  late Future<List<NotificationItem>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _repository.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return PillScaffold(
      title: 'Notifications',
      body: (context, padding) {
        return FutureBuilder(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                padding: padding,
                itemBuilder: (context, index) =>
                    const NotificationSkeletonTile(),
                itemCount: 6,
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text('No notifications available.'));
            }

            final notifications = snapshot.data!;

            return ListView.builder(
              padding: padding.copyWith(left: 0, right: 0),
              itemBuilder: (context, index) => NotificationTile(
                notification: notifications[index],
                onTap: () {},
              ),
              itemCount: notifications.length,
            );
          },
        );
      },
    );
    // return Scaffold(
    //   appBar: AppBar(title: const Text('Notifications')),
    //   body: FutureBuilder(
    //     future: _notificationsFuture,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return ListView.builder(
    //           itemBuilder: (context, index) => const NotificationSkeletonTile(),
    //           itemCount: 6,
    //         );
    //       }
    //       if (snapshot.hasError) {
    //         return Center(child: Text('Error: ${snapshot.error}'));
    //       }

    //       if (snapshot.data == null || snapshot.data!.isEmpty) {
    //         return const Center(child: Text('No notifications available.'));
    //       }

    //       final notifications = snapshot.data!;

    //       return ListView.builder(
    //         itemBuilder: (context, index) => NotificationTile(
    //           notification: notifications[index],
    //           onTap: () {},
    //         ),
    //         itemCount: notifications.length,
    //       );
    //     },
    //   ),
    // );
  }
}
