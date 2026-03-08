import 'package:flutter/material.dart';

class CaregiverFilterSheet extends StatefulWidget {
  const CaregiverFilterSheet({super.key});

  @override
  State<CaregiverFilterSheet> createState() => _CaregiverFilterSheetState();
}

class _CaregiverFilterSheetState extends State<CaregiverFilterSheet> {
  String? _selectedGender;
  final Set<String> _selectedLanguages = {};

  final _languages = ['English', 'Hindi', 'Marathi', 'Punjabi'];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Container(
      // 1. THIS IS THE FIX: Explicit white background and rounded top corners
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wraps tightly to content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. Standard Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // 3. Header & Reset
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedGender = null;
                      _selectedLanguages.clear();
                    }),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 4. Gender (Single Selection)
              const Text(
                'Gender',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: ['Male', 'Female']
                    .map(
                      (gender) => ChoiceChip(
                        label: Text(
                          gender,
                          style: TextStyle(
                            fontWeight: _selectedGender == gender
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        selected: _selectedGender == gender,
                        selectedColor: primary.withValues(alpha:  0.1),
                        checkmarkColor: primary,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        onSelected: (selected) => setState(
                          () => _selectedGender = selected ? gender : null,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),

              // 5. Languages (Multiple Selection)
              const Text(
                'Language',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _languages
                    .map(
                      (lang) => FilterChip(
                        label: Text(
                          lang,
                          style: TextStyle(
                            fontWeight: _selectedLanguages.contains(lang)
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        selected: _selectedLanguages.contains(lang),
                        selectedColor: primary.withValues(alpha: 0.1),
                        checkmarkColor: primary,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        onSelected: (selected) => setState(
                          () => selected
                              ? _selectedLanguages.add(lang)
                              : _selectedLanguages.remove(lang),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 32),

              // 6. Apply Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    // Passes the selected filters back to the page that opened it
                    Navigator.pop(context, {
                      'gender': _selectedGender,
                      'languages': _selectedLanguages.toList(),
                    });
                  },
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
