import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The app's standard top bar, used across all pages.
///
/// Renders a styled [AppBar] with:
/// - The branded back-button pill (only when the route can be popped).
/// - A consistent background, elevation, and bottom divider.
/// - An optional [actions] list for right-side icon buttons.
///
/// ## Title options
/// Provide either [title] (a plain string) **or** [titleWidget] (any widget).
/// If both are given, [titleWidget] takes precedence.
///
/// ## How to extend
/// - To embed a search field (as on [ServiceSearchScreen]), pass a [TextField]
///   via [titleWidget] and set [titleSpacing] to `0` for a flush layout.
/// - To add bottom content (e.g. tabs), wrap this bar in a custom
///   [PreferredSizeWidget] that delegates to [AppTopBar] internally.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// Plain text title. Ignored when [titleWidget] is provided.
  final String title;

  /// Optional widget to replace the default [Text] title — e.g. a [TextField]
  /// for a search bar. When set, [title] is not rendered.
  final Widget? titleWidget;

  /// Optional horizontal spacing override for the title.
  /// Use `0` when [titleWidget] needs to sit flush against the leading icon.
  final double? titleSpacing;

  final List<Widget>? actions;
  final bool? showBackButton;

  const AppTopBar({
    super.key,
    this.title = '',
    this.titleWidget,
    this.titleSpacing,
    this.actions,
    this.showBackButton,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final canPop = showBackButton ?? ModalRoute.of(context)?.canPop ?? false;

    return AppBar(
      // [titleWidget] overrides [title] — allows embedding arbitrary widgets
      // (e.g. a TextField) without changing the bar's visual shell.
      title: titleWidget ??
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.black87,
              letterSpacing: -0.3,
            ),
          ),
      titleSpacing: titleSpacing,
      centerTitle: false,
      backgroundColor: const Color(0xFFFBFBFB),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,

      leading: canPop
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: Colors.black87,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () => context.pop(),
                ),
              ),
            )
          : null,

      actions: actions,

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200),
      ),
    );
  }
}
