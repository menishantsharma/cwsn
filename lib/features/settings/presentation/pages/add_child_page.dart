import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/settings/presentation/providers/child_provider.dart';
import 'package:cwsn/features/settings/presentation/widgets/add_edit_child_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddChildPage extends ConsumerWidget {
  const AddChildPage({super.key});

  Future<void> _deleteChild(BuildContext context, WidgetRef ref, ChildModel child) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(childNotifierProvider).deleteChild(child);
    } catch (_) {
      if (context.mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text("Failed to delete. Restoring...")),
        );
      }
    }
  }

  void _openChildFormSheet(BuildContext context, WidgetRef ref, User user, {ChildModel? existingChild}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditChildSheet(
        existingChild: existingChild,
        onSave: (childData) async {
          final notifier = ref.read(childNotifierProvider);
          try {
            if (existingChild == null) {
              await notifier.addChild(childData);
            } else {
              await notifier.updateChild(childData);
            }
          } catch (_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to save profile.")),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return const SizedBox.shrink();

    final children = user.parentProfile?.children ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const AppTopBar(title: 'Children Details'),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          const Text(
            "Manage Profiles",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Add or edit details about your children.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          if (children.isEmpty)
            const EmptyStateWidget(
              icon: Icons.child_care_rounded,
              title: 'No children added yet.',
            )
          else
            ...children.map(
              (child) => _ChildCard(
                child: child,
                onEdit: () => _openChildFormSheet(
                  context,
                  ref,
                  user,
                  existingChild: child,
                ),
                onDelete: () => _deleteChild(context, ref, child),
              ),
            ),

          const SizedBox(height: 16),
          _AddChildButton(onTap: () => _openChildFormSheet(context, ref, user)),
        ],
      ),
    );
  }
}

class _ChildCard extends StatelessWidget {
  final ChildModel child;
  final VoidCallback onEdit, onDelete;

  const _ChildCard({
    required this.child,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isGirl = child.gender == Gender.female;
    final primary = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: primary.withValues(alpha: 0.1),
          foregroundColor: primary,
          child: Icon(isGirl ? Icons.face_3_rounded : Icons.face_rounded),
        ),
        title: Text(
          child.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          "${child.age} yrs • ${child.gender.name.toUpperCase()}",
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddChildButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddChildButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        foregroundColor: Theme.of(context).primaryColor,
        side: BorderSide(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onTap,
      icon: const Icon(Icons.add_rounded),
      label: const Text(
        "Add New Child",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
