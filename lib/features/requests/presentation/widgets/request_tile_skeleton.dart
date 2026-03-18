import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RequestTileSkeleton extends StatelessWidget {
  const RequestTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEEEEEE),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                const _Circle(radius: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(140, 15),
                      const SizedBox(height: 6),
                      _box(100, 12),
                    ],
                  ),
                ),
                _box(40, 22, radius: 8),
              ],
            ),
            const SizedBox(height: 14),
            // Detail rows
            _detailRow(),
            const SizedBox(height: 8),
            _detailRow(),
            const SizedBox(height: 8),
            _detailRow(),
            const SizedBox(height: 14),
            // Action buttons
            Row(
              children: [
                Expanded(child: _box(double.infinity, 44, radius: 12)),
                const SizedBox(width: 10),
                Expanded(child: _box(double.infinity, 44, radius: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow() => Row(
    children: [
      _box(16, 16, radius: 4),
      const SizedBox(width: 8),
      _box(40, 13),
      const SizedBox(width: 6),
      _box(100, 13),
    ],
  );
}

class _Circle extends StatelessWidget {
  final double radius;
  const _Circle({required this.radius});

  @override
  Widget build(BuildContext context) => Container(
    width: radius * 2,
    height: radius * 2,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
  );
}

Widget _box(double w, double h, {double radius = 6}) => Container(
  width: w,
  height: h,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
  ),
);

class RequestsListSkeleton extends StatelessWidget {
  const RequestsListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const RequestTileSkeleton(),
    );
  }
}

class RequestHistoryListSkeleton extends StatelessWidget {
  const RequestHistoryListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const _AcceptedRequestTileSkeleton(),
    );
  }
}

class _AcceptedRequestTileSkeleton extends StatelessWidget {
  const _AcceptedRequestTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEEEEEE),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _Circle(radius: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(140, 15),
                      const SizedBox(height: 6),
                      _box(100, 12),
                    ],
                  ),
                ),
                _box(60, 22, radius: 8),
              ],
            ),
            const SizedBox(height: 14),
            _detailRow(),
            const SizedBox(height: 8),
            _detailRow(),
            const SizedBox(height: 8),
            _detailRow(),
          ],
        ),
      ),
    );
  }

  Widget _detailRow() => Row(
    children: [
      _box(16, 16, radius: 4),
      const SizedBox(width: 8),
      _box(40, 13),
      const SizedBox(width: 6),
      _box(100, 13),
    ],
  );
}
