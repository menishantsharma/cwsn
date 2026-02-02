import 'package:cwsn/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

// Overlay sheet widget for filtering caregivers on caregivers list page
class CaregiverFilterSheet extends StatelessWidget {
  const CaregiverFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return
    // Container with padding and rounded corners for filter options, width is infinite to take full width of the screen and height is determined by content
    Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child:
          // Column layout for filter options
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: context.textTheme.titleSmall),
                  // Close button to dismiss the filter sheet
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, size: 24),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Gender filter
              _buildFilterSection('Gender', ['Male', 'Female'], context),

              const SizedBox(height: 24),

              // Language filter
              _buildFilterSection('Language', [
                'English',
                'Hindi',
                'Marathi',
                'Punjabi',
              ], context),
            ],
          ),
    );
  }
}

Widget _buildFilterSection(
  String title,
  List<String> options,
  BuildContext context,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: context.textTheme.titleMedium),
      const SizedBox(height: 12),
      Wrap(
        spacing: 12,
        children: options
            .map((option) => _filterChip(option, context))
            .toList(),
      ),
    ],
  );
}

Widget _filterChip(String label, BuildContext context) {
  return OutlinedButton(
    onPressed: () {},
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: context.colorScheme.outlineVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    child: Text(label, style: context.textTheme.bodyMedium),
  );
}
