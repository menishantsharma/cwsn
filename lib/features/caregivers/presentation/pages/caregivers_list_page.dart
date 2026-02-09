import 'package:cwsn/core/router/app_router.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:cwsn/features/caregivers/models/caregiver_model.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_card.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_filter_sheet.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CaregiversListPage extends StatefulWidget {
  const CaregiversListPage({super.key});

  @override
  State<CaregiversListPage> createState() => _CaregiversListPageState();
}

class _CaregiversListPageState extends State<CaregiversListPage> {
  final CaregiverRepository _repository = CaregiverRepository();
  late Future<List<Caregiver>> _caregiversFuture;

  @override
  void initState() {
    super.initState();
    _caregiversFuture = _repository.getCaregiversList();
  }

  @override
  Widget build(BuildContext context) {
    return PillScaffold(
      title: 'Caregivers',
      actionIcon: Icons.filter_alt_outlined,
      onActionPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => const CaregiverFilterSheet(),
        );
      },

      body: (context, padding) {
        return FutureBuilder<List<Caregiver>>(
          future: _caregiversFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                padding: padding.copyWith(left: 20, right: 20, bottom: 20),
                itemCount: 6,
                itemBuilder: (_, _) => const CaregiverSkeletonCard(),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final caregivers = snapshot.data ?? [];

            if (caregivers.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: padding.copyWith(left: 20, right: 20, bottom: 20),
              itemCount: caregivers.length,
              itemBuilder: (context, index) {
                return CaregiverCard(
                  caregiver: caregivers[index],
                  onCardTap: () => context.pushNamed(
                    AppRoutes.caregiverProfile,
                    extra: caregivers[index].id,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.people_outline, size: 64),
        const SizedBox(height: 16),
        const Text(
          'No caregivers available for this service.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
