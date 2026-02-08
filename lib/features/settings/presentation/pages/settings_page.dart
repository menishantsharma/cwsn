import 'package:cwsn/core/providers/user_mode_provider.dart';
import 'package:cwsn/core/router/app_router.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/settings/models/setting_model.dart';
import 'package:cwsn/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCaregiverMode = ref.read(userModeProvider);

    final parentSettings = [
      Setting(
        icon: Icons.edit_outlined,
        label: 'Edit Profile',
        onTap: () => context.pushNamed('edit-profile'),
      ),
      Setting(
        icon: Icons.add,
        label: 'Add Child',
        onTap: () => context.pushNamed('add-child'),
      ),
      Setting(icon: Icons.logout, label: 'Logout', onTap: () {}),
      Setting(
        icon: Icons.delete_outline,
        label: 'Delete Account',
        onTap: () {},
      ),
      Setting(
        icon: Icons.groups_outlined,
        label: 'Start Caregiving',
        onTap: () {
          context.goNamed(AppRoutes.switching);
        },
      ),
    ];

    final caregiverSettings = [
      Setting(icon: Icons.edit_outlined, label: 'Edit Profile', onTap: () {}),
      Setting(icon: Icons.logout, label: 'Logout', onTap: () {}),
      Setting(
        icon: Icons.delete_outline,
        label: 'Delete Account',
        onTap: () {},
      ),
      Setting(
        icon: Icons.groups_outlined,
        label: 'Switch to Parent',
        onTap: () {
          context.goNamed(AppRoutes.switching);
        },
      ),
    ];

    final menuItems = isCaregiverMode ? caregiverSettings : parentSettings;

    return PillScaffold(
      title: 'Profile',
      body: (context, padding) => GridView.builder(
        padding: padding.copyWith(left: 20, right: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 1,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return SettingsTile(
            icon: item.icon,
            label: item.label,
            onTap: item.onTap,
          );
        },
      ),
    );
  }
}
