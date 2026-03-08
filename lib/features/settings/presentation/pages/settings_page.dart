import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/models/user_model.dart';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

    final isCaregiverMode = user.activeRole == UserRole.caregiver;

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

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB), // Premium classic off-white
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
              // Add account deletion logic here
            },
          ),
        ],
      ),
    );
  }
}

// ==========================================
// MINIMAL INTERNAL COMPONENTS
// ==========================================

class _ProfileHeader extends StatelessWidget {
  final User user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.parentEditProfile),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.grey.shade100,
                backgroundImage: user.imageUrl.isNotEmpty
                    ? CachedNetworkImageProvider(user.imageUrl)
                    : null,
                child: user.imageUrl.isEmpty
                    ? Icon(Icons.person, size: 40, color: Colors.grey.shade400)
                    : null,
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              ? const [Color(0xFF4CAF50), Color(0xFF2E7D32)] // Premium Green
              : const [Color(0xFF535CE8), Color(0xFF3B46C4)], // Premium Blue
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        // A much lighter, optimized shadow that doesn't hurt scroll performance
        boxShadow: [
          BoxShadow(
            color: (isCaregiver ? Colors.green : Colors.blue).withValues(
              alpha: 0.25,
            ),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors
            .transparent, // Crucial: Allows the gradient to show through the InkWell
        child: InkWell(
          onTap: () => context.pushNamed(AppRoutes.switching),
          borderRadius: BorderRadius.circular(16),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
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
                  : "Switch to caregiver mode",
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
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
