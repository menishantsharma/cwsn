import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/settings/data/parent_repository.dart';
import 'package:cwsn/features/settings/presentation/widgets/add_edit_child_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final parentRepositoryProvider = Provider((ref) => ParentRepository());

class AddChildPage extends ConsumerWidget {
  const AddChildPage({super.key});

  // --- ACTIONS ---

  Future<void> _deleteChild(
    BuildContext context,
    WidgetRef ref,
    User user,
    ChildModel child,
  ) async {
    final scaffold = ScaffoldMessenger.of(context);
    final previousProfile = user.parentProfile!;

    // 1. OPTIMISTIC UPDATE: Instantly remove child from UI
    final optimisticChildren = previousProfile.children
        .where((c) => c.id != child.id)
        .toList();
    ref
        .read(currentUserProvider.notifier)
        .updateParentProfile(
          previousProfile.copyWith(children: optimisticChildren),
        );

    try {
      // 2. Call Backend API (Silent on success)
      await ref
          .read(parentRepositoryProvider)
          .deleteChild(parentId: user.id, childId: child.id);
    } catch (e) {
      // 3. ROLLBACK: If API fails, put the child back instantly & show error
      ref
          .read(currentUserProvider.notifier)
          .updateParentProfile(previousProfile);

      if (context.mounted) {
        scaffold.showSnackBar(
          const SnackBar(content: Text("Failed to delete child. Restoring...")),
        );
      }
    }
  }

  void _openChildFormSheet(
    BuildContext context,
    WidgetRef ref,
    User user, {
    ChildModel? existingChild,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddEditChildSheet(
        existingChild: existingChild,
        onSave: (childData) async {
          final repo = ref.read(parentRepositoryProvider);

          try {
            List<ChildModel> updatedChildren;

            if (existingChild == null) {
              final savedChild = await repo.addChild(
                parentId: user.id,
                child: childData,
              );
              updatedChildren = [
                ...(user.parentProfile?.children ?? <ChildModel>[]),
                savedChild,
              ];
            } else {
              final updatedChild = await repo.updateChild(
                parentId: user.id,
                child: childData,
              );
              updatedChildren = user.parentProfile!.children
                  .map((c) => c.id == updatedChild.id ? updatedChild : c)
                  .toList();
            }

            final updatedProfile = (user.parentProfile ?? const ParentModel())
                .copyWith(children: updatedChildren);
            ref
                .read(currentUserProvider.notifier)
                .updateParentProfile(updatedProfile);
          } catch (e) {
            if (sheetContext.mounted) {
              ScaffoldMessenger.of(sheetContext).showSnackBar(
                const SnackBar(content: Text("Failed to save child profile.")),
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
            ),
            const SizedBox(height: 8),
            Text(
              "Add basic details about your children.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // --- SMOOTH CHILDREN LIST & EMPTY STATE ---
            // OPTIMIZED: AnimatedSize smoothly collapses the empty space when a child is removed
            AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: children.isEmpty
                  ? const _EmptyChildrenState()
                  : Column(
                      children: children.asMap().entries.map((entry) {
                        final index = entry.key;
                        final child = entry.value;

                        return Padding(
                          key: ValueKey(
                            child.id,
                          ), // Crucial: Locks the animation state so it doesn't replay on delete!
                          padding: const EdgeInsets.only(bottom: 16),
                          child:
                              _ChildCard(
                                    child: child,
                                    onEdit: () => _openChildFormSheet(
                                      context,
                                      ref,
                                      user,
                                      existingChild: child,
                                    ),
                                    onDelete: () =>
                                        _deleteChild(context, ref, user, child),
                                  )
                                  // Staggered Entrance Animation
                                  .animate()
                                  .fade(
                                    duration: 400.ms,
                                    delay: (100 * index).ms,
                                  )
                                  .slideY(
                                    begin: 0.1,
                                    end: 0,
                                    duration: 400.ms,
                                    delay: (100 * index).ms,
                                    curve: Curves.easeOutQuad,
                                  ),
                        );
                      }).toList(),
                    ),
            ),

            const SizedBox(height: 8),

            // --- ADD NEW BUTTON ---
            // Fades in slightly after the list finishes loading
            _AddChildButton(
                  onTap: () => _openChildFormSheet(context, ref, user),
                )
                .animate()
                .fade(delay: 300.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
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
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ChildCard({
    required this.child,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
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
    );
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
        )
        .animate()
        .fade(duration: 400.ms)
        .slideY(begin: 0.1, end: 0); // Entrance animation for empty state
  }
}

class _AddChildButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddChildButton({required this.onTap});

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
    );
  }
}
