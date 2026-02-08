import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/features/services/presentation/widgets/service_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalServiceRowSkeleton extends StatelessWidget {
  const HorizontalServiceRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = context.colorScheme.surfaceContainerHighest;
    final highlightColor = context.colorScheme.surfaceContainerHigh;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 12),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 170,
          child: ListView.separated(
            itemBuilder: (_, _) => const ServiceCardSkeleton(),
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemCount: 3,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),

        const SizedBox(height: 28),
      ],
    );
  }
}
