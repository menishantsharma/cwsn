import 'package:cwsn/core/widgets/pill_header.dart';
import 'package:flutter/material.dart';

class PillScaffold extends StatelessWidget {
  final String title;
  final Widget Function(BuildContext context, EdgeInsets padding) body;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final bool? showBack;

  const PillScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actionIcon,
    this.onActionPressed,
    this.showBack,
  });

  @override
  Widget build(BuildContext context) {
    final PillHeader header = PillHeader(
      title: title,
      actionIcon: actionIcon,
      onActionPressed: onActionPressed,
      showBack: showBack,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Builder(
              builder: (context) {
                final safePadding = MediaQuery.of(context).padding;
                final double headerHeight = header.preferredSize.height;
                final calculatedPadding = EdgeInsets.only(
                  top: safePadding.top + headerHeight,
                  bottom: safePadding.bottom,
                );

                return body(context, calculatedPadding);
              },
            ),
          ),
          Positioned(top: 0, left: 0, right: 0, child: SafeArea(child: header)),
        ],
      ),
    );
  }
}
