import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter/material.dart';

/// Reusable gender selection row with animated toggle buttons.
class GenderSelector extends StatelessWidget {
  final Gender? selectedGender;
  final ValueChanged<Gender?> onChanged;

  /// When true, tapping the selected gender deselects it.
  final bool allowDeselect;

  /// When true, uses filled primary color for the selected state
  /// (as in the add-child sheet). When false, uses a lighter outline style
  /// (as in the edit-profile page).
  final bool useFilled;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
    this.allowDeselect = false,
    this.useFilled = false,
  });

  static IconData _iconFor(Gender gender) {
    switch (gender) {
      case Gender.male:
        return Icons.male_rounded;
      case Gender.female:
        return Icons.female_rounded;
      case Gender.other:
        return Icons.transgender_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Row(
      children: Gender.values.map((gender) {
        final isSelected = selectedGender == gender;
        final label = gender.name[0].toUpperCase() + gender.name.substring(1);

        return Expanded(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              if (allowDeselect) {
                onChanged(isSelected ? null : gender);
              } else {
                onChanged(gender);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _backgroundColor(isSelected, primaryColor),
                borderRadius: BorderRadius.circular(useFilled ? 20 : 12),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey.shade200,
                  width: useFilled ? 2 : 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _iconFor(gender),
                    color: _foregroundColor(isSelected, primaryColor),
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: _foregroundColor(isSelected, primaryColor),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _backgroundColor(bool isSelected, Color primaryColor) {
    if (!isSelected) {
      return useFilled ? Colors.grey.shade50 : Colors.white;
    }
    return useFilled ? primaryColor : primaryColor.withValues(alpha: 0.1);
  }

  Color _foregroundColor(bool isSelected, Color primaryColor) {
    if (!isSelected) {
      return useFilled ? Colors.grey.shade400 : Colors.grey.shade400;
    }
    return useFilled ? Colors.white : primaryColor;
  }
}
