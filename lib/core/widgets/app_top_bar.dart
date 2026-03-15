import 'package:cwsn/core/widgets/user_avatar.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool? showBackButton;
  final bool showProfileAvatar;

  const AppTopBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton,
    this.showProfileAvatar = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = showBackButton ?? ModalRoute.of(context)?.canPop ?? false;

    final effectiveActions = <Widget>[
      ...?actions,
      if (showProfileAvatar) _buildAvatar(ref),
    ];

    return AppBar(
      title: Text(title),
      leading: canPop
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            )
          : null,
      actions: effectiveActions.isEmpty ? null : effectiveActions,
    );
  }

  Widget _buildAvatar(WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    if (user == null || user.isGuest) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: UserAvatar(
        imageUrl: user.imageUrl,
        name: user.firstName,
        size: 32,
        isCircle: true,
      ),
    );
  }
}
