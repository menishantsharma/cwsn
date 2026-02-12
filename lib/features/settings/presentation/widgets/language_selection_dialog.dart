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
  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    // Create a copy of the list so we don't modify the parent state directly until "Done" is clicked
    _tempSelected = List.from(widget.selectedLanguages);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return AlertDialog(
      title: const Text("Select Languages"),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.allLanguages.map((lang) {
            final isSelected = _tempSelected.contains(lang);
            return FilterChip(
              label: Text(lang),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _tempSelected.add(lang);
                  } else {
                    _tempSelected.remove(lang);
                  }
                });
              },
              selectedColor: primaryColor.withValues(alpha: 0.2),
              checkmarkColor: primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? primaryColor : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _tempSelected),
          child: Text(
            "Done",
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
          ),
        ),
      ],
    );
  }
}
