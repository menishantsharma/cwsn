import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/settings/data/parent_repository.dart';
import 'package:cwsn/features/settings/presentation/widgets/add_edit_child_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// OPTIMIZED: Use a provider for the repository to allow for easy testing/mocking
final parentRepositoryProvider = Provider((ref) => ParentRepository());

class AddChildPage extends ConsumerStatefulWidget {
  const AddChildPage({super.key});

  @override
  ConsumerState<AddChildPage> createState() => _AddChildPageState();
}

class _AddChildPageState extends ConsumerState<AddChildPage> {
  // --- ACTIONS ---

  void _deleteChild(User user, ChildModel child) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Deleting ${child.name}...")));

    // Call Backend API
    await ref
        .read(parentRepositoryProvider)
        .deleteChild(parentId: user.id, childId: child.id);

    // Update Local State using the new Notifier method
    final updatedChildren = user.parentProfile!.children
        .where((c) => c.id != child.id)
        .toList();
    final updatedProfile = user.parentProfile!.copyWith(
      children: updatedChildren,
    );

    ref.read(currentUserProvider.notifier).updateParentProfile(updatedProfile);
  }

  void _openChildFormSheet(User user, {ChildModel? existingChild}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditChildSheet(
        existingChild: existingChild,
        onSave: (childData) async {
          final repo = ref.read(parentRepositoryProvider);

          if (existingChild == null) {
            // ADD LOGIC
            final savedChild = await repo.addChild(
              parentId: user.id,
              child: childData,
            );

            final updatedChildren = [
              ...(user.parentProfile?.children ?? <ChildModel>[]),
              savedChild,
            ];
            final updatedProfile = (user.parentProfile ?? const ParentModel())
                .copyWith(children: updatedChildren);

            ref
                .read(currentUserProvider.notifier)
                .updateParentProfile(updatedProfile);
          } else {
            // EDIT LOGIC
            final updatedChild = await repo.updateChild(
              parentId: user.id,
              child: childData,
            );

            final updatedChildren = user.parentProfile!.children
                .map((c) => c.id == updatedChild.id ? updatedChild : c)
                .toList();
            final updatedProfile = user.parentProfile!.copyWith(
              children: updatedChildren,
            );

            ref
                .read(currentUserProvider.notifier)
                .updateParentProfile(updatedProfile);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // OPTIMIZED: Safely extract the user from AsyncValue
    final user = ref.watch(currentUserProvider).value;

    // Safety check in case the user was logged out while on this screen
    if (user == null) return const SizedBox.shrink();

    final children = user.parentProfile?.children ?? [];

    return PillScaffold(
      title: 'Children Details',
      body: (context, padding) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: padding.copyWith(left: 24, right: 24, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Manage Profiles",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ).animate().fade().slideX(begin: -0.2, end: 0),

            const SizedBox(height: 8),
            Text(
              "Add basic details about your children.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ).animate().fade(delay: 100.ms).slideX(begin: -0.2, end: 0),
            const SizedBox(height: 24),

            // --- CHILDREN LIST ---
            if (children.isEmpty)
              const _EmptyChildrenState()
            else
              // OPTIMIZED: Use a standard for-loop inside the Column
              for (int i = 0; i < children.length; i++)
                _ChildCard(
                  child: children[i],
                  delay: 200 + (i * 100),
                  onEdit: () =>
                      _openChildFormSheet(user, existingChild: children[i]),
                  onDelete: () => _deleteChild(user, children[i]),
                ),

            const SizedBox(height: 24),

            // --- ADD NEW BUTTON ---
            _AddChildButton(
              delay: children.isEmpty ? 300 : 200 + (children.length * 100),
              onTap: () => _openChildFormSheet(user),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// OPTIMIZED: EXTRACTED STATELESS WIDGETS
// ==========================================

class _ChildCard extends StatelessWidget {
  final ChildModel child;
  final int delay;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ChildCard({
    required this.child,
    required this.delay,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D1617).withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              child.gender == Gender.female
                  ? Icons.face_3_rounded
                  : Icons.face_rounded,
              color: primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${child.age} yrs • ${child.gender.name[0].toUpperCase()}${child.gender.name.substring(1)}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: Icon(
                  Icons.edit_rounded,
                  color: Colors.blue.shade400,
                  size: 22,
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red.shade400,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: delay.ms).slideY(begin: 0.2, end: 0);
  }
}

class _EmptyChildrenState extends StatelessWidget {
  const _EmptyChildrenState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.child_care_rounded,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No children added yet.",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 200.ms);
  }
}

class _AddChildButton extends StatelessWidget {
  final int delay;
  final VoidCallback onTap;

  const _AddChildButton({required this.delay, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Add New Child",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(delay: delay.ms).slideY(begin: 0.2, end: 0);
  }
}
