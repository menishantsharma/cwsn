import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/widgets/user_avatar.dart';
import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/guest_placeholder.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(currentUserProvider.notifier).logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;

    if (user == null) return const SizedBox.shrink();

    // 1. Handle Guest State instantly
    if (user.isGuest) {
      return Scaffold(
        appBar: const AppTopBar(title: 'Profile', showBackButton: false),
        body: GuestPlaceholder(
          message:
              "Sign in to manage your profile, children details, and app preferences.",
          onLoginPressed: () => ref.read(currentUserProvider.notifier).logout(),
        ),
      );
    }

    final isCaregiverMode = user.activeRole == UserRole.caregiver;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const AppTopBar(title: 'Profile', showBackButton: false),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _ProfileHeader(user: user),
          const SizedBox(height: 32),

          _SwitchModeCard(isCaregiver: isCaregiverMode),
          const SizedBox(height: 32),

          const _SectionTitle("Account Settings"),
          SettingsTile(
            icon: Icons.person_outline_rounded,
            label: 'Edit Profile',
            onTap: () => context.pushNamed(AppRoutes.parentEditProfile),
          ),

          if (!isCaregiverMode)
            SettingsTile(
              icon: Icons.child_care_rounded,
              label: 'Add Child',
              iconColor: Colors.orange.shade600,
              onTap: () => context.pushNamed(AppRoutes.addChild),
            ),
          
          if(isCaregiverMode) 
            SettingsTile(
              icon: Icons.work_outline_rounded,
              label: 'Manage Services',
              iconColor: Colors.blue.shade600,
              onTap: () => context.pushNamed(AppRoutes.caregiverServices),
            ),
          

          const SizedBox(height: 24),

          const _SectionTitle("Other"),
          SettingsTile(
            icon: Icons.logout_rounded,
            label: 'Logout',
            isDestructive: true,
            onTap: () => _confirmLogout(context, ref),
          ),
          SettingsTile(
            icon: Icons.delete_outline_rounded,
            label: 'Delete Account',
            isDestructive: true,
            onTap: () {
              // Add deletion logic
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.parentEditProfile),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              UserAvatar(
                imageUrl: user.imageUrl,
                name: user.firstName,
                size: 96,
                isCircle: true,
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _SwitchModeCard extends StatelessWidget {
  final bool isCaregiver;
  const _SwitchModeCard({required this.isCaregiver});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCaregiver
              ? const [Color(0xFF4CAF50), Color(0xFF2E7D32)]
              : const [Color(0xFF535CE8), Color(0xFF3B46C4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isCaregiver ? Colors.green : Colors.blue).withValues(
              alpha: 0.2,
            ),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.pushNamed(AppRoutes.switching),
          borderRadius: BorderRadius.circular(20),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
            ),
            title: Text(
              isCaregiver ? "Switch to Parent" : "Start Caregiving",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              isCaregiver
                  ? "Access services for your child"
                  : "Offer your caregiver services",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.grey.shade500,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
