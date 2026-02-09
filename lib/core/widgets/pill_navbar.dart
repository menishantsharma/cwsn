import 'package:cwsn/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PillNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const PillNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // 1. Floating Margin (Lifts it off the bottom)
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 30),
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1D1617).withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              0,
              Icons.home_rounded,
              Icons.home_outlined,
              primaryColor: context.colorScheme.primary,
            ),
            _buildNavItem(
              1,
              Icons.notifications_rounded,
              Icons.notifications_outlined,
              primaryColor: context.colorScheme.primary,
            ),
            _buildNavItem(
              2,
              Icons.person_rounded,
              Icons.person_outline,
              primaryColor: context.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon, {
    Color? primaryColor,
  }) {
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          HapticFeedback.lightImpact();
          onTap(index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        height: 64,
        alignment: Alignment.center,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutQuint,
          width: isSelected ? 44 : 24,
          height: isSelected ? 44 : 24,
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isSelected ? activeIcon : inactiveIcon,
            color: isSelected ? Colors.white : Colors.grey.shade400,
            size: 22,
          ),
        ),
      ),
    );
  }
}
