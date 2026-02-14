import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/settings/data/parent_repository.dart'; // Import repo
import 'package:cwsn/features/settings/presentation/widgets/add_edit_child_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddChildPage extends ConsumerStatefulWidget {
  const AddChildPage({super.key});

  @override
  ConsumerState<AddChildPage> createState() => _AddChildPageState();
}

class _AddChildPageState extends ConsumerState<AddChildPage> {
  final ParentRepository _repository = ParentRepository();

  // --- ACTIONS ---

  void _deleteChild(User user, ChildModel child) async {
    // 1. Show loading/confirmation (simplified here)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Deleting ${child.name}...")));

    // 2. Call Backend API
    await _repository.deleteChild(parentId: user.id, childId: child.id);

    // 3. Update Local State (Provider)
    final updatedChildren = user.parentProfile!.children
        .where((c) => c.id != child.id)
        .toList();
    final updatedProfile = user.parentProfile!.copyWith(
      children: updatedChildren,
    );

    ref.read(currentUserProvider.notifier).state = user.copyWith(
      parentProfile: updatedProfile,
    );
  }

  void _openChildFormSheet(User user, {ChildModel? existingChild}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditChildSheet(
        existingChild: existingChild,
        onSave: (childData) async {
          // This callback runs when the user clicks 'Save' in the bottom sheet

          if (existingChild == null) {
            // ADD LOGIC
            final savedChild = await _repository.addChild(
              parentId: user.id,
              child: childData,
            );

            // Update State
            final updatedChildren = <ChildModel>[
              ...(user.parentProfile?.children ?? <ChildModel>[]),
              savedChild,
            ];
            final updatedProfile = (user.parentProfile ?? ParentModel())
                .copyWith(children: updatedChildren);
            ref.read(currentUserProvider.notifier).state = user.copyWith(
              parentProfile: updatedProfile,
            );
          } else {
            // EDIT LOGIC
            final updatedChild = await _repository.updateChild(
              parentId: user.id,
              child: childData,
            );

            // Update State
            final updatedChildren = user.parentProfile!.children
                .map((c) => c.id == updatedChild.id ? updatedChild : c)
                .toList();
            final updatedProfile = user.parentProfile!.copyWith(
              children: updatedChildren,
            );
            ref.read(currentUserProvider.notifier).state = user.copyWith(
              parentProfile: updatedProfile,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final children = user?.parentProfile?.children ?? [];

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
              _buildEmptyState()
            else
              ...children.asMap().entries.map((entry) {
                final index = entry.key;
                final child = entry.value;
                return _buildChildCard(
                  user!,
                  child,
                  delay: 200 + (index * 100),
                );
              }),

            const SizedBox(height: 24),

            // --- ADD NEW BUTTON ---
            if (user != null)
              _buildAddButton(
                user,
                delay: children.isEmpty ? 300 : 200 + (children.length * 100),
              ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildChildCard(User user, ChildModel child, {required int delay}) {
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
                onPressed: () =>
                    _openChildFormSheet(user, existingChild: child),
                icon: Icon(
                  Icons.edit_rounded,
                  color: Colors.blue.shade400,
                  size: 22,
                ),
              ),
              IconButton(
                onPressed: () => _deleteChild(user, child),
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

  Widget _buildEmptyState() {
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

  Widget _buildAddButton(User user, {required int delay}) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => _openChildFormSheet(user),
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
