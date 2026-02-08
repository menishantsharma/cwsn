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
          padding: const EdgeInsets.only(left: 16.0, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                section.title,
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Text('View all', style: context.textTheme.bodySmall),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 12),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, index) => ServiceCard(
              item: section.items[index],
              onTap: () {
                context.pushNamed(AppRoutes.specialNeeds);
              },
            ),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}
