import 'package:cwsn/features/caregivers/models/caregiver_model.dart';

class NotificationItem {
  final String id;
  final Caregiver caregiver;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.caregiver,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}
