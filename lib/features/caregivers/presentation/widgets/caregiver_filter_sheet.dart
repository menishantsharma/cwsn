import 'package:cwsn/core/constants/app_constants.dart';
import 'package:cwsn/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:cwsn/features/caregivers/models/caregiver_filter.dart';
import 'package:cwsn/features/caregivers/presentation/providers/caregiver_providers.dart';
import 'package:cwsn/features/services/presentation/providers/services_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaregiverFilterSheet extends ConsumerStatefulWidget {
  const CaregiverFilterSheet({super.key});

  @override
  ConsumerState<CaregiverFilterSheet> createState() =>
      _CaregiverFilterSheetState();
}

class _CaregiverFilterSheetState extends ConsumerState<CaregiverFilterSheet> {
  late String? _selectedGender;
  late Set<String> _selectedLanguages;
  late Set<String> _selectedServices;
  late bool? _isAvailable;

  final _languages = AppConstants.supportedLanguages.take(4).toList();

  @override
  void initState() {
    super.initState();
    final current = ref.read(caregiverFilterProvider);
    _selectedGender = current.gender;
    _selectedLanguages = current.languages.toSet();
    _selectedServices = current.services.toSet();
    _isAvailable = current.isAvailable;
  }

  void _applyFilters() {
    ref.read(caregiverFilterProvider.notifier).update(CaregiverFilter(
      gender: _selectedGender,
      languages: _selectedLanguages.toList(),
      services: _selectedServices.toList(),
      isAvailable: _isAvailable,
    ));
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _selectedGender = null;
      _selectedLanguages.clear();
      _selectedServices.clear();
      _isAvailable = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final masterNames = ref.watch(masterServiceNamesProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomSheetDragHandle(),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: _resetFilters,
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

              // Gender
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
                        selectedColor: primary.withValues(alpha: 0.1),
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

              // Language
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
              const SizedBox(height: 24),

              // Services / Specialties
              const Text(
                'Specialties',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              masterNames.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (_, _) => Text(
                  'Failed to load specialties',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
                data: (names) => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: names
                      .map(
                        (svc) => FilterChip(
                          label: Text(
                            svc,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: _selectedServices.contains(svc)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: _selectedServices.contains(svc),
                          selectedColor: primary.withValues(alpha: 0.1),
                          checkmarkColor: primary,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          onSelected: (selected) => setState(
                            () => selected
                                ? _selectedServices.add(svc)
                                : _selectedServices.remove(svc),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Availability
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile.adaptive(
                  title: const Text(
                    'Available only',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  subtitle: Text(
                    'Show only caregivers accepting requests',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  value: _isAvailable == true,
                  activeTrackColor: primary,
                  onChanged: (val) => setState(
                    () => _isAvailable = val ? true : null,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Apply button
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
                  onPressed: _applyFilters,
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
