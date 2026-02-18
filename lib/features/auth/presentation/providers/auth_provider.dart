import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final currentUserProvider = StateProvider<User?>((ref) => null);
final authLoadingProvider = StateProvider<bool>((ref) => false);
final isCaregiverProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.activeRole == UserRole.caregiver;
});