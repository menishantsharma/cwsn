import 'package:flutter/material.dart';

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
    return Container(
      height: 90,
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavButton(0, Icons.home_outlined, Icons.home),
          const SizedBox(width: 24),
          _buildNavButton(1, Icons.notifications_outlined, Icons.notifications),
          const SizedBox(width: 24),
          _buildNavButton(2, Icons.person_outline, Icons.person),
        ],
      ),
    );
  }

  Widget _buildNavButton(int index, IconData icon, IconData filledIcon) {
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? filledIcon : icon,
          color: isSelected ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
    );
  }
}
