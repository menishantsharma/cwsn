import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleSelectionPage extends ConsumerWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = Theme.of(context).primaryColor;
    final user = ref.watch(currentUserProvider).value;
    final notifier = ref.read(currentUserProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(
                  Icons.waving_hand_rounded,
                  size: 36,
                  color: primary,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Hi, ${user?.firstName ?? 'there'}!',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'How would you like to continue?',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
              ),

              const Spacer(flex: 2),

              // Role cards
              _RoleCard(
                icon: Icons.family_restroom_rounded,
                label: 'Parent',
                hint: 'Find caregivers & services for your child',
                color: Colors.blue.shade600,
                onTap: () => notifier.switchRole(UserRole.parent),
              ),
              const SizedBox(height: 14),
              _RoleCard(
                icon: Icons.volunteer_activism_rounded,
                label: 'Caregiver',
                hint: 'Offer your services & manage requests',
                color: primary,
                onTap: () => notifier.switchRole(UserRole.caregiver),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.hint,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hint,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade300,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
