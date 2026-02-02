import 'package:cwsn/core/router/app_router.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/special_needs/data/special_needs_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SpecialNeedsPage extends StatelessWidget {
  const SpecialNeedsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> specialNeeds = mockSpecialNeeds;

    return PillScaffold(
      title: 'Special Needs',
      body: (context, padding) => ListView.separated(
        padding: padding.copyWith(left: 20, right: 20),
        itemBuilder: (_, index) => InkWell(
          onTap: () {
            context.pushNamed(AppRoutes.caregiversList);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              specialNeeds[index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium,
            ),
          ),
        ),
        separatorBuilder: (_, index) => Divider(
          height: 1,
          thickness: 1,
          color: context.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        itemCount: specialNeeds.length,
      ),
    );
  }
}
