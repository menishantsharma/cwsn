import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final parentRepositoryProvider = Provider((ref) => ParentRepository());

class ParentRepository {
  Future<ChildModel> addChild({
    required String parentId,
    required ChildModel child,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return child.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
  }

  Future<ChildModel> updateChild({
    required String parentId,
    required ChildModel child,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return child;
  }

  Future<void> deleteChild({
    required String parentId,
    required String childId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
