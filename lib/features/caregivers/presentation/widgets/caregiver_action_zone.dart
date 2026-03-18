import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:cwsn/features/caregivers/presentation/providers/caregiver_action_state_provider.dart';
import 'package:cwsn/features/caregivers/presentation/providers/caregiver_providers.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/report_caregiver_sheet.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/select_child_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaregiverActionZone extends ConsumerStatefulWidget {
  final String caregiverId;
  final bool isAvailable;
  const CaregiverActionZone({
    super.key,
    required this.caregiverId,
    this.isAvailable = true,
  });

  @override
  ConsumerState<CaregiverActionZone> createState() =>
      _CaregiverActionZoneState();
}

class _CaregiverActionZoneState extends ConsumerState<CaregiverActionZone> {
  bool _isUnsending = false;
  bool _isTogglingRecommend = false;

  void _openRequestSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectChildSheet(
        caregiverId: widget.caregiverId,
        onRequestSent: () {
          ref.invalidate(actionZoneStateProvider(widget.caregiverId));
        },
      ),
    );
  }

  void _showPhoneDialog(String? phoneNumber) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.phone_rounded,
                color: colors.onPrimaryContainer,
                size: 22,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Caregiver Contact',
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap copy to save the number.',
              style: text.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Text(
                phoneNumber ?? 'Not available',
                style: text.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: phoneNumber != null
                      ? colors.onSurface
                      : colors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Close'),
          ),
          FilledButton.tonal(
            onPressed: phoneNumber == null
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await Clipboard.setData(ClipboardData(text: phoneNumber));
                    if (!dialogCtx.mounted) return;
                    Navigator.pop(dialogCtx);
                    messenger.showSnackBar(
                      SnackBar(
                        content:
                            const Text('Phone number copied to clipboard.'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.copy_rounded, size: 16),
                SizedBox(width: 6),
                Text('Copy'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openReportSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReportCaregiverSheet(),
    );
  }

  Future<void> _unsendRequest() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null || _isUnsending) return;

    setState(() => _isUnsending = true);
    try {
      await ref.read(caregiverRepositoryProvider).unsendRequest(
            parentId: user.id,
            caregiverId: widget.caregiverId,
          );
      ref.invalidate(actionZoneStateProvider(widget.caregiverId));
    } finally {
      if (mounted) setState(() => _isUnsending = false);
    }
  }

  Future<void> _toggleRecommend(bool isCurrentlyRecommended) async {
    if (_isTogglingRecommend) return;

    setState(() => _isTogglingRecommend = true);
    try {
      await ref.read(caregiverRepositoryProvider).toggleRecommendation(
            caregiverId: widget.caregiverId,
            isCurrentlyRecommended: isCurrentlyRecommended,
          );
      if (mounted) {
        ref.invalidate(hasRecommendedProvider(widget.caregiverId));
        ref.invalidate(caregiverProfileProvider(widget.caregiverId));
      }
    } finally {
      if (mounted) setState(() => _isTogglingRecommend = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(actionZoneStateProvider(widget.caregiverId));
    final isRecommended =
        ref.watch(hasRecommendedProvider(widget.caregiverId)).value ?? false;
    // Pre-warmed by the profile page — zero extra cost.
    final phoneNumber = ref
        .watch(caregiverProfileProvider(widget.caregiverId))
        .value
        ?.phoneNumber;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: stateAsync.when(
            loading: () => _buildSkeleton(),
            error: (_, _) => const SizedBox.shrink(),
            data: (state) => switch (state) {
              ActionZoneState.unauthenticated => _LoginButton(
                key: const ValueKey('unauthenticated'),
                onPressed: () =>
                    ref.read(currentUserProvider.notifier).logout(),
              ),
              ActionZoneState.none => widget.isAvailable
                  ? _RequestButton(
                      key: const ValueKey('none'),
                      onPressed: _openRequestSheet,
                    )
                  : const _BusyButton(key: ValueKey('busy')),
              ActionZoneState.pending => _PendingButton(
                key: const ValueKey('pending'),
                isLoading: _isUnsending,
                onTap: _unsendRequest,
              ),
              ActionZoneState.accepted => _AcceptedActions(
                key: const ValueKey('accepted'),
                isRecommended: isRecommended,
                isTogglingRecommend: _isTogglingRecommend,
                onPhone: () => _showPhoneDialog(phoneNumber),
                onRecommend: () => _toggleRecommend(isRecommended),
                onReport: _openReportSheet,
              ),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Container(
      key: const ValueKey('loading'),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(28),
      ),
    );
  }
}

// ─── Unauthenticated ─────────────────────────────────────────────────────────

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.login_rounded),
        label: const Text('Login to Request'),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─── No request ──────────────────────────────────────────────────────────────

class _RequestButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _RequestButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onPrimary,
          elevation: 4,
          shadowColor: context.colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        child: const Text('Request Service'),
      ),
    );
  }
}

// ─── Pending (tappable to unsend) ────────────────────────────────────────────

class _PendingButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;
  const _PendingButton({
    super.key,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onTap,
        icon: isLoading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey.shade600,
                ),
              )
            : Icon(Icons.schedule_rounded, color: Colors.grey.shade600),
        label: Text(
          isLoading ? 'Cancelling...' : 'Request Sent — Tap to Cancel',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
          disabledBackgroundColor: Colors.grey.shade200,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─── Busy ────────────────────────────────────────────────────────────────────

class _BusyButton extends StatelessWidget {
  const _BusyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(
          Icons.do_not_disturb_on_rounded,
          color: Colors.grey.shade600,
        ),
        label: Text(
          'Currently Busy',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─── Accepted — 3 round icon buttons ─────────────────────────────────────────

class _AcceptedActions extends StatelessWidget {
  final bool isRecommended;
  final bool isTogglingRecommend;
  final VoidCallback onPhone;
  final VoidCallback onRecommend;
  final VoidCallback onReport;

  const _AcceptedActions({
    super.key,
    required this.isRecommended,
    required this.isTogglingRecommend,
    required this.onPhone,
    required this.onRecommend,
    required this.onReport,
  });

  static const _size = 56.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundActionButton(
          onPressed: onPhone,
          icon: Icons.phone_outlined,
          backgroundColor: colors.primaryContainer,
          foregroundColor: colors.onPrimaryContainer,
          size: _size,
        ),
        const SizedBox(width: 20),
        _RoundActionButton(
          onPressed: isTogglingRecommend ? null : onRecommend,
          icon: isRecommended
              ? Icons.thumb_up_rounded
              : Icons.thumb_up_outlined,
          backgroundColor:
              isRecommended ? colors.primary : colors.surfaceContainerHighest,
          foregroundColor: isRecommended ? colors.onPrimary : colors.onSurface,
          size: _size,
        ),
        const SizedBox(width: 20),
        _RoundActionButton(
          onPressed: onReport,
          icon: Icons.flag_outlined,
          backgroundColor: colors.errorContainer,
          foregroundColor: colors.error,
          size: _size,
        ),
      ],
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double size;

  const _RoundActionButton({
    required this.onPressed,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton.filled(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}
