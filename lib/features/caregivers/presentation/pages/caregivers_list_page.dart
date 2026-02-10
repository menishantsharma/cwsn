import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/router/app_router.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_card.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_filter_sheet.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // 1. Import
import 'package:go_router/go_router.dart';

class CaregiversListPage extends StatefulWidget {
  const CaregiversListPage({super.key});

  @override
  State<CaregiversListPage> createState() => _CaregiversListPageState();
}

class _CaregiversListPageState extends State<CaregiversListPage> {
  final CaregiverRepository _repository = CaregiverRepository();
  late Future<List<User>> _caregiversFuture;

  @override
  void initState() {
    super.initState();
    _caregiversFuture = _repository.getCaregiversList();
  }

  @override
  Widget build(BuildContext context) {
    return PillScaffold(
      title: 'Caregivers',
      actionIcon: Icons.filter_list_rounded,
      onActionPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => const CaregiverFilterSheet(),
        );
      },

      body: (context, padding) {
        return FutureBuilder<List<User>>(
          future: _caregiversFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                padding: padding.copyWith(left: 20, right: 20, bottom: 20),
                itemCount: 6,
                itemBuilder: (_, _) => const CaregiverSkeletonCard()
                    .animate(onPlay: (loop) => loop.repeat())
                    .shimmer(
                      duration: 1200.ms,
                      color: const Color(0xFFEBEBF4),
                      angle: 0.5,
                    ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final users = snapshot.data ?? [];

            if (users.isEmpty) {
              return _buildEmptyState().animate().fade().scale();
            }

            return ListView.builder(
              padding: padding.copyWith(left: 20, right: 20, bottom: 100),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return CaregiverCard(
                      user: users[index],
                      onCardTap: () => context.pushNamed(
                        AppRoutes.caregiverProfile,
                        extra: users[index].id,
                      ),
                    )
                    .animate()
                    .fade(duration: 400.ms, delay: (50 * index).ms)
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 400.ms,
                      curve: Curves.easeOutQuad,
                      delay: (50 * index).ms,
                    );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No caregivers found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters to see more results.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
