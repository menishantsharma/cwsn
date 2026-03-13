import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/utils/utils.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/user_avatar.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/select_child_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final caregiverProfileProvider = FutureProvider.autoDispose
    .family<User, String>((ref, id) async {
      final repository = ref.watch(caregiverRepositoryProvider);
      return repository.getCaregiverDetails(id);
    });

class CaregiverProfilePage extends ConsumerWidget {
  final String caregiverId;
  const CaregiverProfilePage({super.key, required this.caregiverId});

  void _openRequestSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          SelectChildSheet(caregiverId: caregiverId, onRequestSent: () {}),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(caregiverProfileProvider(caregiverId));

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const AppTopBar(title: 'Caregiver Profile'),
      body: profileAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, _) => const Center(child: Text('Failed to load profile')),
        data: (user) {
          final caregiver = user.caregiverProfile!;
          final bool isAvailable = caregiver.isAvailable;

          return Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                children: [
                  _CenteredHeader(user: user),
                  const SizedBox(height: 32),

                  _MetricsCard(
                    recs: formatCompactNumber(caregiver.totalRecommendations),
                    exp: '${caregiver.yearsOfExperience}y',
                    parents: '50+',
                  ),

                  const SizedBox(height: 32),

                  if (!isAvailable) const _BusyAlert(),

                  const _SectionHeader(title: 'About Caregiver'),
                  Text(
                    caregiver.about,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const _SectionHeader(title: 'Specialties'),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: caregiver.services
                        .map((s) => _ModernChip(label: s))
                        .toList(),
                  ),
                  const SizedBox(height: 32),

                  const _SectionHeader(title: 'General Information'),
                  _InfoTile(
                    Icons.map_outlined,
                    'Location',
                    user.location ?? 'India',
                  ),
                  _InfoTile(
                    Icons.translate_rounded,
                    'Languages',
                    caregiver.languages.join(", "),
                  ),
                ],
              ),

              _FixedRequestButton(
                isAvailable: isAvailable,
                onTap: isAvailable ? () => _openRequestSheet(context) : null,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CenteredHeader extends StatelessWidget {
  final User user;
  const _CenteredHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAvatar(
          imageUrl: user.imageUrl,
          name: user.firstName,
          size: 100,
          borderRadius: 24,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            if (user.caregiverProfile?.isVerified ?? false)
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(
                  Icons.verified_rounded,
                  color: Colors.blue,
                  size: 22,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "CERTIFIED SPECIALIST",
          style: TextStyle(
            color: Colors.red.shade700,
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _MetricsCard extends StatelessWidget {
  final String recs, exp, parents;
  const _MetricsCard({
    required this.recs,
    required this.exp,
    required this.parents,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MetricItem(recs, 'Recs', Icons.thumb_up_rounded, Colors.orange),
          Container(height: 30, width: 1, color: Colors.grey.shade100),
          _MetricItem(exp, 'Exp', Icons.work_history_rounded, Colors.blue),
          Container(height: 30, width: 1, color: Colors.grey.shade100),
          _MetricItem(parents, 'Parents', Icons.people_rounded, Colors.green),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _MetricItem(this.value, this.label, this.icon, this.color);

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

class _BusyAlert extends StatelessWidget {
  const _BusyAlert();
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 32),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.orange.shade50,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.orange.shade100),
    ),
    child: Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          color: Colors.orange.shade800,
          size: 20,
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            "Currently busy and not accepting requests.",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}

class _ModernChip extends StatelessWidget {
  final String label;
  const _ModernChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
  );
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoTile(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade400),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ],
    ),
  );
}

class _FixedRequestButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isAvailable;
  const _FixedRequestButton({required this.onTap, required this.isAvailable});

  @override
  State<_FixedRequestButton> createState() => _FixedRequestButtonState();
}

class _FixedRequestButtonState extends State<_FixedRequestButton> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    final Color color = widget.isAvailable
        ? const Color(0xFFE53935)
        : Colors.grey.shade400;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GestureDetector(
          onTapDown: (_) =>
              widget.isAvailable ? setState(() => _isPressed = true) : null,
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _isPressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: widget.isAvailable
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  widget.isAvailable ? "Request Service" : "Currently Busy",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
