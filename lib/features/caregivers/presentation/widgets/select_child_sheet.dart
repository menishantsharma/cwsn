import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/router/app_routes.dart';
import 'package:cwsn/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SelectChildSheet extends ConsumerStatefulWidget {
  final String caregiverId;
  final VoidCallback onRequestSent;

  const SelectChildSheet({
    super.key,
    required this.caregiverId,
    required this.onRequestSent,
  });

  @override
  ConsumerState<SelectChildSheet> createState() => _SelectChildSheetState();
}

class _SelectChildSheetState extends ConsumerState<SelectChildSheet> {
  ChildModel? _selectedChild;
  bool _isLoading = false;

  Future<void> _sendRequest() async {
    if (_selectedChild == null) return;

    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(caregiverRepositoryProvider)
          .sendRequest(
            parentId: currentUser.id,
            caregiverId: widget.caregiverId,
            childId: _selectedChild!.id,
          );

      if (mounted) {
        widget.onRequestSent();
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to send request. Try again."),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final user = ref.watch(currentUserProvider).value;
    final children = user?.parentProfile?.children ?? [];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomSheetDragHandle(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Request Caregiver",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Which child needs care?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.grey.shade700,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (children.isEmpty)
                        const EmptyStateWidget(
                          icon: Icons.child_care_rounded,
                          title: "You haven't added any children yet.",
                        )
                      else
                        ...children.map(
                          (child) => _buildChildTile(child, primaryColor),
                        ),

                      const SizedBox(height: 8),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade100,
                          child: Icon(
                            Icons.add_rounded,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        title: Text(
                          "Add another child",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          context.pop();
                          context.pushNamed(AppRoutes.addChild);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_selectedChild != null && !_isLoading)
                      ? _sendRequest
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _selectedChild != null
                              ? "Request Care for ${_selectedChild!.name.split(' ').first}"
                              : "Select a child",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "The caregiver will review your request.",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildTile(ChildModel child, Color primaryColor) {
    final isSelected = _selectedChild?.id == child.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor.withValues(alpha: 0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? primaryColor : Colors.transparent,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        title: Text(
          child.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle_rounded, color: primaryColor)
            : Icon(Icons.circle_outlined, color: Colors.grey.shade300),
        onTap: () => setState(() => _selectedChild = child),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
