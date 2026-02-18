import 'package:flutter/material.dart';

class LanguageSelectionDialog extends StatefulWidget {
  final List<String> allLanguages;
  final List<String> selectedLanguages;

  const LanguageSelectionDialog({
    super.key,
    required this.allLanguages,
    required this.selectedLanguages,
  });

  @override
  State<LanguageSelectionDialog> createState() =>
      _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  // 1. OPTIMIZED: Use a Set for O(1) lookups and guaranteed uniqueness instead of an O(N) List.
  late final Set<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = Set.from(widget.selectedLanguages);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return AlertDialog(
      // 2. OPTIMIZED: Modern production UI styling to match the app's theme
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titlePadding: const EdgeInsets.only(
        left: 24,
        top: 24,
        right: 24,
        bottom: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 16, top: 8),

      title: const Text(
        "Select Languages",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: -0.5,
        ),
      ),

      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Wrap(
          spacing: 8,
          runSpacing: 12, // Slightly more vertical breathing room
          // 3. OPTIMIZED: Using a 'for' loop is more memory efficient than .map().toList()
          children: [
            for (final lang in widget.allLanguages)
              _LanguageChip(
                lang: lang,
                isSelected: _tempSelected.contains(lang),
                primaryColor: primaryColor,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _tempSelected.add(lang);
                    } else {
                      _tempSelected.remove(lang);
                    }
                  });
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          // 4. OPTIMIZED: Convert the Set back to a List to fulfill the expected return type
          onPressed: () => Navigator.pop(context, _tempSelected.toList()),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text(
            "Done",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// OPTIMIZED: EXTRACTED STATELESS WIDGETS
// ==========================================

class _LanguageChip extends StatelessWidget {
  final String lang;
  final bool isSelected;
  final Color primaryColor;
  final ValueChanged<bool> onSelected;

  const _LanguageChip({
    required this.lang,
    required this.isSelected,
    required this.primaryColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(lang),
      selected: isSelected,
      onSelected: onSelected,
      showCheckmark:
          false, // Cleaner look without the native checkmark shifting the text
      selectedColor: primaryColor.withValues(alpha: 0.1),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(
        color: isSelected ? primaryColor : Colors.transparent,
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: TextStyle(
        color: isSelected ? primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      ),
    );
  }
}
