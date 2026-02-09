import 'package:cwsn/core/router/app_router.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/special_needs/data/special_needs_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SpecialNeedsPage extends StatelessWidget {
  const SpecialNeedsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Data Source
    final List<String> specialNeeds = mockSpecialNeeds;

    return PillScaffold(
      title: 'Special Needs',
      body: (context, padding) => ListView.separated(
        padding: padding.copyWith(left: 20, right: 20, bottom: 40),
        itemCount: specialNeeds.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final item = specialNeeds[index];

          return Animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: (50 * index).ms),
              SlideEffect(
                begin: const Offset(0, 0.1),
                curve: Curves.easeOutQuad,
              ),
            ],
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () => context.pushNamed(AppRoutes.caregiversList),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _getPastelColor(
                              index,
                            ).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              item[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _getPastelColor(index),
                              ),
                            ),
                            // child: Icon(Icons.favorite, color: _getPastelColor(index)),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              // const SizedBox(height: 2),
                              // Text(
                              //   "Explore specialists",
                              //   style: context.textTheme.bodySmall?.copyWith(
                              //     color: Colors.grey.shade500,
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
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
    final colors = [
      const Color(0xFF535CE8), // Blue
      const Color(0xFFFF4B55), // Red
      const Color(0xFF4CAF50), // Green
      const Color(0xFFFF9800), // Orange
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF00BCD4), // Cyan
    ];
    return colors[index % colors.length];
  }
}
