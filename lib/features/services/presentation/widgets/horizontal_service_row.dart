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
          child: Text(section.title, style: context.textTheme.titleMedium),
        ),
        SizedBox(
          height: 188,
          child: ListView.separated(
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
        const SizedBox(height: 24),
      ],
    );
  }
}
