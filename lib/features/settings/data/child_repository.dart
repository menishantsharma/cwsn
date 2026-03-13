import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the active [ChildRepository] implementation.
final childRepositoryProvider = Provider<ChildRepository>(
  (ref) => FakeChildRepository(),
);

/// Contract for managing a parent's children profiles.
abstract class ChildRepository {
  Future<ChildModel> addChild({
    required String parentId,
    required ChildModel child,
  });
  Future<ChildModel> updateChild({
    required String parentId,
    required ChildModel child,
  });
  Future<void> deleteChild({required String parentId, required String childId});
}

class FakeChildRepository implements ChildRepository {
  @override
  Future<ChildModel> addChild({
    required String parentId,
    required ChildModel child,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return child.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
  }

  @override
  Future<ChildModel> updateChild({
    required String parentId,
    required ChildModel child,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return child;
  }

  @override
  Future<void> deleteChild({
    required String parentId,
    required String childId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
