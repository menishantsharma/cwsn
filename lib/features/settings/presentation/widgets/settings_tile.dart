import 'package:cwsn/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool isDestructive;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    // OPTIMIZED: Inherit primary color from the theme instead of hardcoding
    final primaryColor = Theme.of(context).primaryColor;
    final effectiveIconColor =
        iconColor ?? (isDestructive ? Colors.red : primaryColor);

    // OPTIMIZED: Padding is computationally lighter than a Container with a margin
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      // OPTIMIZED: DecoratedBox skips the heavy layout constraints of a Container
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // OPTIMIZED: 0x0A is exactly 4% alpha. This makes the shadow completely constant!
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A1D1617),
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16), // Simplified to .all
              child: Row(
                children: [
                  // --- ICON BOX ---
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: effectiveIconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(icon, color: effectiveIconColor, size: 22),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // --- LABEL ---
                  Expanded(
                    child: Text(
                      label,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? Colors.red : Colors.black87,
                      ),
                    ),
                  ),

                  // --- TRAILING ARROW ---
                  if (!isDestructive)
                    // OPTIMIZED: Replaced Colors.grey.shade300 with exact Hex so it can be const
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Color(0xFFE0E0E0),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
