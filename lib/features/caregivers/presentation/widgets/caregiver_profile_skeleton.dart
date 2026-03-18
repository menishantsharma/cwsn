import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CaregiverProfileSkeleton extends StatelessWidget {
  const CaregiverProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEEEEEE),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        children: [
          // Header — avatar + name + badge
          Column(
            children: [
              _box(100, 100, radius: 24),
              const SizedBox(height: 16),
              _box(160, 22, radius: 8),
              const SizedBox(height: 8),
              _box(100, 12, radius: 6),
            ],
          ),
          const SizedBox(height: 32),

          // Metrics card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _metricSkeleton(),
                _metricSkeleton(),
                _metricSkeleton(),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // About section
          _box(80, 17, radius: 6),
          const SizedBox(height: 12),
          _box(double.infinity, 14, radius: 6),
          const SizedBox(height: 6),
          _box(double.infinity, 14, radius: 6),
          const SizedBox(height: 6),
          _box(220, 14, radius: 6),
          const SizedBox(height: 32),

          // Specialties
          _box(90, 17, radius: 6),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              5,
              (_) => _box(80, 36, radius: 12),
            ),
          ),
          const SizedBox(height: 32),

          // General info
          _box(140, 17, radius: 6),
          const SizedBox(height: 16),
          _infoTileSkeleton(),
          const SizedBox(height: 16),
          _infoTileSkeleton(),
        ],
      ),
    );
  }

  Widget _box(double w, double h, {double radius = 8}) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
    ),
  );

  Widget _metricSkeleton() => Column(
    children: [
      _box(20, 20, radius: 4),
      const SizedBox(height: 6),
      _box(32, 16, radius: 4),
      const SizedBox(height: 4),
      _box(28, 10, radius: 4),
    ],
  );

  Widget _infoTileSkeleton() => Row(
    children: [
      _box(18, 18, radius: 4),
      const SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(50, 11, radius: 4),
          const SizedBox(height: 4),
          _box(120, 14, radius: 4),
        ],
      ),
    ],
  );
}
