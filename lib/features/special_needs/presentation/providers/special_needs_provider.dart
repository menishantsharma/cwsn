import 'package:cwsn/features/special_needs/data/special_needs_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final specialNeedsProvider = FutureProvider<List<String>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return mockSpecialNeeds;
});