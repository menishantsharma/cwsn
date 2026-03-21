import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/features/caregivers/presentation/providers/caregiver_action_state_provider.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_action_zone.dart';
import 'package:cwsn/features/services/models/caregiver_profile_model.dart';
import 'package:cwsn/features/services/presentation/providers/services_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackendCaregiverProfilePage extends ConsumerWidget {
  final int caregiverId;

  const BackendCaregiverProfilePage({super.key, required this.caregiverId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(caregiverProfileByIdProvider(caregiverId));
    final caregiverIdStr = caregiverId.toString();

    // Pre-warm action zone providers so they're ready when profile loads.
    ref.watch(actionZoneStateProvider(caregiverIdStr));

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const AppTopBar(title: 'Caregiver Profile'),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Failed to load profile')),
        data: (profile) => Stack(
          children: [
            _ProfileBody(profile: profile),
            CaregiverActionZone(caregiverId: caregiverIdStr),
          ],
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final CaregiverProfile profile;

  const _ProfileBody({required this.profile});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [
        // ── Avatar + name ─────────────────────────────────────────────
        Center(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Text(
                  profile.name.isNotEmpty
                      ? profile.name[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              if (profile.regionName.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      profile.regionName,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // ── Metrics row ───────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MetricItem(
                value: '${profile.upvoteCount}',
                label: 'Upvotes',
                icon: Icons.thumb_up_rounded,
                color: Colors.orange,
              ),
              Container(width: 1, height: 30, color: Colors.grey.shade100),
              _MetricItem(
                value: '${profile.age}y',
                label: 'Age',
                icon: Icons.cake_outlined,
                color: Colors.blue,
              ),
              Container(width: 1, height: 30, color: Colors.grey.shade100),
              _MetricItem(
                value: profile.gender,
                label: 'Gender',
                icon: Icons.person_outline_rounded,
                color: Colors.green,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // ── Qualifications ────────────────────────────────────────────
        if (profile.qualifications.isNotEmpty) ...[
          const _SectionHeader(title: 'Qualifications'),
          Text(
            profile.qualifications,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF4A4A4A),
            ),
          ),
          const SizedBox(height: 28),
        ],

        // ── About / Recommendations ───────────────────────────────────
        if (profile.recommendations.isNotEmpty) ...[
          const _SectionHeader(title: 'About'),
          Text(
            profile.recommendations,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF4A4A4A),
            ),
          ),
          const SizedBox(height: 28),
        ],

        // ── Languages ─────────────────────────────────────────────────
        if (profile.languages.isNotEmpty) ...[
          const _SectionHeader(title: 'Languages'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: profile.languages
                .map(
                  (lang) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      lang,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 28),
        ],

        // ── Contact ───────────────────────────────────────────────────
        const _SectionHeader(title: 'Contact'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Icon(Icons.phone_outlined, size: 20, color: cs.primary),
              const SizedBox(width: 12),
              Text(
                profile.contactNo.isNotEmpty ? profile.contactNo : 'Hidden',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: profile.contactNo.isNotEmpty
                      ? const Color(0xFF1A1A1A)
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
      );
}

class _MetricItem extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;

  const _MetricItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}
