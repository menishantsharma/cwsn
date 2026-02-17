import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/router/app_router.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class SelectChildSheet extends ConsumerStatefulWidget {
  final String caregiverId;
  final VoidCallback onRequestSent; // --- NEW: Required callback

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

  void _sendRequest() async {
    if (_selectedChild == null) return;

    final currentUser = ref.read(currentUserProvider);
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
        // 1. Trigger the callback to turn the Parent Page's button Green
        widget.onRequestSent();

        // 2. Simply close the bottom sheet (No SnackBar!)
        context.pop();
      }
    } catch (e) {
      // We still keep the error snackbar just in case the internet fails,
      // so the user knows why the sheet didn't close.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Failed to send request. Try again."),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colorScheme.primary;
    final user = ref.watch(currentUserProvider);
    final children = user?.parentProfile?.children ?? [];

    final isButtonEnabled = _selectedChild != null && !_isLoading;

    return Container(
      // Ensure the sheet only takes up a maximum of 85% of the screen height
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      // --- NEW: SingleChildScrollView makes everything inside scrollable ---
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Request Caregiver",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Which child needs care?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Children List mapped inside the scrollable column
              if (children.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.child_care_rounded,
                          size: 48,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "You haven't added any children yet.",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fade().scale()
              else
                ...children.asMap().entries.map((entry) {
                  final index = entry.key;
                  final child = entry.value;
                  final isSelected = _selectedChild?.id == child.id;

                  return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => setState(() => _selectedChild = child),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  child.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutCubic,
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF202020)
                                          : Colors.grey.shade300,
                                      width: isSelected ? 8 : 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fade(delay: (50 * index).ms)
                      .slideX(begin: 0.1, end: 0);
                }),

              const SizedBox(height: 12),

              InkWell(
                onTap: () {
                  context.pop();
                  context.pushNamed(AppRoutes.addChild);
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.grey.shade700,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Add another child",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fade(delay: 200.ms),

              const SizedBox(height: 32),

              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isButtonEnabled
                      ? [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [],
                ),
                child: ElevatedButton(
                  onPressed: isButtonEnabled ? _sendRequest : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: Colors.grey.shade200,
                    disabledForegroundColor: Colors.grey.shade500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                      : Text(
                          isButtonEnabled
                              ? "Request Care for ${_selectedChild!.name.split(' ').first}"
                              : "Select a child to continue",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ).animate().fade(delay: 300.ms).slideY(begin: 0.2, end: 0),

              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: Text(
                    "The caregiver will review your request and confirm availability.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ).animate().fade(delay: 400.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
