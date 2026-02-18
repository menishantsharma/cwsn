import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleSelectionPage extends ConsumerWidget {
  const RoleSelectionPage({super.key});

  // OPTIMIZED: Use the dedicated switchRole method from our AsyncNotifier
  void _selectRole(WidgetRef ref, UserRole role) {
    ref.read(currentUserProvider.notifier).switchRole(role);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).primaryColor;

    // OPTIMIZED: Extract the actual User object from the AsyncValue
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),

              // --- GREETING ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.waving_hand_rounded,
                  size: 48,
                  color: primaryColor,
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 32),

              Text(
                "Welcome, ${user?.firstName ?? 'User'}!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ).animate().fade(delay: 200.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 12),

              Text(
                "How would you like to continue today?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ).animate().fade(delay: 300.ms).slideY(begin: 0.2, end: 0),

              const Spacer(flex: 1),

              // --- PARENT CARD ---
              _RoleCard(
                title: "Continue as Parent",
                subtitle:
                    "Find trusted caregivers and specialized services for your child.",
                icon: Icons.family_restroom_rounded,
                color: Colors.blue.shade600,
                delay: 400,
                onTap: () => _selectRole(ref, UserRole.parent),
              ),

              const SizedBox(height: 20),

              // --- CAREGIVER CARD ---
              _RoleCard(
                title: "Continue as Caregiver",
                subtitle:
                    "Manage your profile, view requests, and offer your services.",
                icon: Icons.volunteer_activism_rounded,
                color: primaryColor,
                delay: 500,
                onTap: () => _selectRole(ref, UserRole.caregiver),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

// OPTIMIZED: Extracted into a StatelessWidget for better performance and rendering
class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int delay;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fade(delay: delay.ms).slideX(begin: 0.1, end: 0);
  }
}
