import 'package:cwsn/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.edit_outlined,
        'label': 'Edit Profile',
        'onTap': () => context.pushNamed('edit-profile'),
      },

      {
        'icon': Icons.add,
        'label': 'Add Child',
        'onTap': () => context.pushNamed('add-child'),
      },

      {'icon': Icons.logout, 'label': 'Logout', 'onTap': () {}},

      {'icon': Icons.delete_outline, 'label': 'Delete Account', 'onTap': () {}},
      {
        'icon': Icons.groups_outlined,
        'label': 'Start Caregiving',
        'onTap': () {},
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
            icon: item['icon'],
            label: item['label'],
            onTap: item['onTap'],
          );
        },
      ),
    );
  }
}
