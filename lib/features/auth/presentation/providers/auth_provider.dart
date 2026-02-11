import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());
final currentUserProvider = StateProvider<User?>((ref) => null);
final authLoadingProvider = StateProvider<bool>((ref) => false);
