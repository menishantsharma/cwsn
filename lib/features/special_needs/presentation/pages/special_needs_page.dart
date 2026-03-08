import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cwsn/features/special_needs/presentation/providers/special_needs_provider.dart';

class SpecialNeedsPage extends ConsumerWidget {
  const SpecialNeedsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialNeedsAsync = ref.watch(specialNeedsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const AppTopBar(title: 'Special Needs'),
      body: specialNeedsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (list) => ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: list.length,
          separatorBuilder: (_, _) => Container(
            height: 1,
            color: Colors.grey.shade50,
            margin: const EdgeInsets.only(left: 72),
          ),
          itemBuilder: (context, index) {
            final item = list[index];
            final color = _getPastelColor(index);

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: index == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: index == list.length - 1
                      ? const Radius.circular(16)
                      : Radius.zero,
                ),
              ),
              child: ListTile(
                onTap: () => context.pushNamed(AppRoutes.caregiversList),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      item[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  item,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: -0.2,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: Colors.black12,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getPastelColor(int index) {
    const colors = [
      Color(0xFF535CE8),
      Color(0xFFE91E63),
      Color(0xFF009688),
      Color(0xFF673AB7),
      Color(0xFFFF9800),
      Color(0xFF2196F3),
    ];
    return colors[index % colors.length];
  }
}
