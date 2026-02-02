import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PillHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final bool? showBack;

  // configurable sizing
  final double height;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  const PillHeader({
    super.key,
    required this.title,
    this.actionIcon,
    this.onActionPressed,
    this.showBack,

    this.height = 56.0,
    this.leftPadding = 24.0,
    this.rightPadding = 24.0,
    this.topPadding = 12.0,
    this.bottomPadding = 24.0,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(height + topPadding + bottomPadding);

  @override
  Widget build(BuildContext context) {
    final canPop = showBack ?? context.canPop();

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: leftPadding,
        right: rightPadding,
        bottom: bottomPadding,
      ),
      child: SizedBox(
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: height,
              width: 220,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(title),
            ),

            if (canPop) ...[
              Positioned(
                left: 0,
                child: _buildCircleButton(
                  icon: Icons.arrow_back,
                  onTap: () => context.pop(),
                ),
              ),
            ],

            if (actionIcon != null) ...[
              Positioned(
                right: 0,
                child: _buildCircleButton(
                  icon: actionIcon!,
                  onTap: onActionPressed,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Widget _buildCircleButton({required IconData icon, VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(50),
    child: Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Icon(icon, size: 22),
    ),
  );
}
