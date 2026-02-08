import 'package:cwsn/core/router/app_router.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:cwsn/features/services/presentation/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Widget displaying a horizontal scrollable row of service cards
class HorizontalServiceRow extends StatelessWidget {
  // List of service items to display provided by parent
  final ServiceSection section;

  const HorizontalServiceRow({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 4, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                section.title,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          // Text matches brand color
                          color: context.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: context.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 170,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemCount: section.items.length,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            itemBuilder: (_, index) => ServiceCard(
              item: section.items[index],
              onTap: () {
                context.pushNamed(AppRoutes.specialNeeds);
              },
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
