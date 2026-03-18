import 'package:cwsn/core/constants/app_constants.dart';
import 'package:cwsn/features/caregivers/models/caregiver_filter.dart';
import 'package:cwsn/features/caregivers/models/caregiver_sort.dart';
import 'package:cwsn/features/caregivers/presentation/providers/caregiver_providers.dart';
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
  late bool? _isAvailable;
  late CaregiverSortOption _selectedSort;

  final _languages = AppConstants.supportedLanguages.take(5).toList();

  @override
  void initState() {
    super.initState();
    final filter = ref.read(caregiverFilterProvider);
    _selectedGender = filter.gender;
    _selectedLanguages = filter.languages.toSet();
    _isAvailable = filter.isAvailable;
    _selectedSort = ref.read(caregiverSortProvider);
  }

  void _apply() {
    ref.read(caregiverFilterProvider.notifier).update(
          CaregiverFilter(
            gender: _selectedGender,
            languages: _selectedLanguages.toList(),
            isAvailable: _isAvailable,
          ),
        );
    ref.read(caregiverSortProvider.notifier).update(_selectedSort);
    Navigator.pop(context);
  }

  void _reset() {
    setState(() {
      _selectedGender = null;
      _selectedLanguages.clear();
      _isAvailable = null;
      _selectedSort = CaregiverSortOption.recommended;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──────────────────────────────────────────
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            decoration: BoxDecoration(
              color: colors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── Header ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Sort & Filter',
                    style: text.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _reset,
                  child: Text(
                    'Reset all',
                    style: text.labelLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Scrollable body ──────────────────────────────────────
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Sort By ──────────────────────────────────────
                  _SectionLabel(label: 'Sort By', colors: colors, text: text),
                  const SizedBox(height: 12),
                  _SortGrid(
                    selected: _selectedSort,
                    onChanged: (v) => setState(() => _selectedSort = v),
                    colors: colors,
                    text: text,
                  ),
                  const SizedBox(height: 28),

                  // ── Gender ───────────────────────────────────────
                  _SectionLabel(label: 'Gender', colors: colors, text: text),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: ['Male', 'Female'].map((g) {
                      final selected = _selectedGender == g;
                      return _Chip(
                        label: g,
                        selected: selected,
                        colors: colors,
                        text: text,
                        onTap: () => setState(
                          () => _selectedGender = selected ? null : g,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // ── Language ─────────────────────────────────────
                  _SectionLabel(label: 'Language', colors: colors, text: text),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _languages.map((lang) {
                      final selected = _selectedLanguages.contains(lang);
                      return _Chip(
                        label: lang,
                        selected: selected,
                        colors: colors,
                        text: text,
                        onTap: () => setState(
                          () => selected
                              ? _selectedLanguages.remove(lang)
                              : _selectedLanguages.add(lang),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // ── Availability ─────────────────────────────────
                  _SectionLabel(
                    label: 'Availability',
                    colors: colors,
                    text: text,
                  ),
                  const SizedBox(height: 12),
                  _AvailabilityToggle(
                    value: _isAvailable == true,
                    colors: colors,
                    text: text,
                    onChanged: (v) =>
                        setState(() => _isAvailable = v ? true : null),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Apply button ─────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              0,
              24,
              24 + MediaQuery.paddingOf(context).bottom,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _apply,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: text.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('Apply'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sort grid (2×2 tappable cards) ───────────────────────────────────────────

class _SortGrid extends StatelessWidget {
  final CaregiverSortOption selected;
  final ValueChanged<CaregiverSortOption> onChanged;
  final ColorScheme colors;
  final TextTheme text;

  const _SortGrid({
    required this.selected,
    required this.onChanged,
    required this.colors,
    required this.text,
  });

  static const _options = [
    (CaregiverSortOption.recommended, Icons.thumb_up_outlined, 'Recommended'),
    (CaregiverSortOption.experience, Icons.work_history_outlined, 'Experience'),
    (CaregiverSortOption.nameAsc, Icons.sort_by_alpha_rounded, 'Name A–Z'),
    (CaregiverSortOption.nameDesc, Icons.sort_rounded, 'Name Z–A'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.8,
      children: _options.map((opt) {
        final (option, icon, label) = opt;
        final isSelected = selected == option;
        return GestureDetector(
          onTap: () => onChanged(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected ? colors.primaryContainer : colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? colors.primary : colors.outlineVariant,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected
                      ? colors.onPrimaryContainer
                      : colors.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: text.labelMedium?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? colors.onPrimaryContainer
                        : colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Shared pill chip ──────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final ColorScheme colors;
  final TextTheme text;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.colors,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? colors.primaryContainer : colors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? colors.primary : colors.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: text.labelLarge?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? colors.onPrimaryContainer : colors.onSurface,
          ),
        ),
      ),
    );
  }
}

// ── Availability toggle card ──────────────────────────────────────────────────

class _AvailabilityToggle extends StatelessWidget {
  final bool value;
  final ColorScheme colors;
  final TextTheme text;
  final ValueChanged<bool> onChanged;

  const _AvailabilityToggle({
    required this.value,
    required this.colors,
    required this.text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: value ? colors.primaryContainer : colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value ? colors.primary : colors.outlineVariant,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 20,
              color: value ? colors.primary : colors.outlineVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available only',
                    style: text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: value
                          ? colors.onPrimaryContainer
                          : colors.onSurface,
                    ),
                  ),
                  Text(
                    'Show caregivers accepting requests',
                    style: text.bodySmall?.copyWith(
                      color: value
                          ? colors.onPrimaryContainer.withValues(alpha: 0.7)
                          : colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              activeThumbColor: colors.onPrimary,
              activeTrackColor: colors.primary,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final ColorScheme colors;
  final TextTheme text;

  const _SectionLabel({
    required this.label,
    required this.colors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: text.titleSmall?.copyWith(
        fontWeight: FontWeight.w800,
        color: colors.onSurface,
        letterSpacing: 0.2,
      ),
    );
  }
}
