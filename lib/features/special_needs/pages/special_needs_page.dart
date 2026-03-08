import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/features/special_needs/data/special_needs_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SpecialNeedsPage extends StatelessWidget {
  const SpecialNeedsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> specialNeeds = mockSpecialNeeds;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const AppTopBar(title: 'Special Needs'),

      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: specialNeeds.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final item = specialNeeds[index];
          final themeColor = _getPastelColor(index);

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.pushNamed(AppRoutes.caregiversList),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),

                  leading: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        item[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                        ),
                      ),
                    ),
                  ),

                  title: Text(
                    item,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      fontSize: 16,
                      letterSpacing: -0.2,
                    ),
                  ),

                  // 5. Contextual Subtitle: Adds "Standard App" depth
                  // subtitle: Text(
                  //   'Find specialized caregivers',
                  //   style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  // ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 24,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getPastelColor(int index) {
    const colors = [
      Color(0xFF535CE8), // Indigo
      Color(0xFFE91E63), // Pink
      Color(0xFF009688), // Teal
      Color(0xFF673AB7), // Deep Purple
      Color(0xFFFF9800), // Orange
      Color(0xFF2196F3), // Blue
    ];
    return colors[index % colors.length];
  }
}
