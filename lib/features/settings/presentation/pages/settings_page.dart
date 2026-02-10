import 'package:cwsn/core/providers/user_mode_provider.dart';
import 'package:cwsn/core/router/app_router.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCaregiverMode = ref.read(userModeProvider);

    return PillScaffold(
      title: 'Profile',
      body: (context, padding) => SingleChildScrollView(
        padding: padding.copyWith(left: 20, right: 20, bottom: 100),
        child: Column(
          children:
              [
                    _buildProfileHeader(context),

                    const SizedBox(height: 30),

                    _buildSwitchModeCard(context, isCaregiverMode),

                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Account Settings",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SettingsTile(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit Profile',
                      onTap: () =>
                          context.pushNamed(AppRoutes.parentEditProfile),
                    ),

                    if (!isCaregiverMode)
                      SettingsTile(
                        icon: Icons.child_care_rounded,
                        label: 'Add Child',
                        iconColor: Colors.orange,
                        onTap: () => context.pushNamed(AppRoutes.addChild),
                      ),

                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Other",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SettingsTile(
                      icon: Icons.logout_rounded,
                      label: 'Logout',
                      isDestructive: true,
                      onTap: () {},
                    ),
                    SettingsTile(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete Account',
                      isDestructive: true,
                      onTap: () {},
                    ),
                  ]
                  .animate(interval: 50.ms)
                  .fade(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: const CachedNetworkImageProvider(
                  'https://i.pravatar.cc/300',
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary, // Brand Color
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Nishant Sharma",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "nishant@example.com",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildSwitchModeCard(BuildContext context, bool isCaregiver) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCaregiver
              ? [
                  const Color(0xFF4CAF50),
                  const Color(0xFF2E7D32),
                ] // Green for Caregiver
              : [
                  const Color(0xFF535CE8),
                  const Color(0xFF3B46C4),
                ], // Blue for Parent
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isCaregiver ? Colors.green : Colors.blue).withValues(
              alpha: 0.3,
            ),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.goNamed(AppRoutes.switching),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.swap_horiz_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCaregiver ? "Switch to Parent" : "Start Caregiving",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isCaregiver
                            ? "Access services for your child"
                            : "Switch to caregiver mode",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
