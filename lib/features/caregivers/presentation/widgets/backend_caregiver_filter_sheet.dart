import 'package:cwsn/features/caregivers/models/backend_caregiver_filter.dart';
import 'package:cwsn/features/services/presentation/providers/services_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackendCaregiverFilterSheet extends ConsumerStatefulWidget {
  const BackendCaregiverFilterSheet({super.key});

  @override
  ConsumerState<BackendCaregiverFilterSheet> createState() =>
      _BackendCaregiverFilterSheetState();
}

class _BackendCaregiverFilterSheetState
    extends ConsumerState<BackendCaregiverFilterSheet> {
  late String? _serviceType;
  late String? _paymentType;
  late String? _gender;
  late BackendCaregiverSort _sort;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(backendCaregiverFilterProvider);
    _serviceType = filter.serviceType;
    _paymentType = filter.paymentType;
    _gender = filter.gender;
    _sort = filter.sort;
  }

  void _apply() {
    ref.read(backendCaregiverFilterProvider.notifier).update(
          BackendCaregiverFilter(
            serviceType: _serviceType,
            paymentType: _paymentType,
            gender: _gender,
            sort: _sort,
          ),
        );
    Navigator.pop(context);
  }

  void _reset() {
    setState(() {
      _serviceType = null;
      _paymentType = null;
      _gender = null;
      _sort = BackendCaregiverSort.recommended;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
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
                    style: text.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
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
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.8,
                    children: [
                      (
                        BackendCaregiverSort.recommended,
                        Icons.thumb_up_outlined,
                        'Recommended'
                      ),
                      (
                        BackendCaregiverSort.nameAsc,
                        Icons.sort_by_alpha_rounded,
                        'Name A–Z'
                      ),
                      (
                        BackendCaregiverSort.nameDesc,
                        Icons.sort_rounded,
                        'Name Z–A'
                      ),
                    ].map((opt) {
                      final (option, icon, label) = opt;
                      final isSelected = _sort == option;
                      return GestureDetector(
                        onTap: () => setState(() => _sort = option),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colors.primaryContainer
                                : colors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? colors.primary
                                  : colors.outlineVariant,
                              width: 1.5,
                            ),
                          ),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
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
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
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
                  ),
                  const SizedBox(height: 28),

                  // ── Service Type ─────────────────────────────────
                  _SectionLabel(
                    label: 'Service Type',
                    colors: colors,
                    text: text,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: ['Online', 'Offline', 'Hybrid'].map((type) {
                      final selected = _serviceType == type;
                      return _Chip(
                        label: type,
                        selected: selected,
                        colors: colors,
                        text: text,
                        onTap: () => setState(
                          () => _serviceType = selected ? null : type,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // ── Payment Type ─────────────────────────────────
                  _SectionLabel(
                    label: 'Payment',
                    colors: colors,
                    text: text,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: ['Paid', 'Unpaid'].map((type) {
                      final selected = _paymentType == type;
                      return _Chip(
                        label: type,
                        selected: selected,
                        colors: colors,
                        text: text,
                        onTap: () => setState(
                          () => _paymentType = selected ? null : type,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // ── Caregiver Gender ─────────────────────────────
                  _SectionLabel(
                    label: 'Caregiver Gender',
                    colors: colors,
                    text: text,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: ['Male', 'Female', 'Any'].map((g) {
                      final selected = _gender == g;
                      return _Chip(
                        label: g,
                        selected: selected,
                        colors: colors,
                        text: text,
                        onTap: () =>
                            setState(() => _gender = selected ? null : g),
                      );
                    }).toList(),
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
                  textStyle: text.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
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
  Widget build(BuildContext context) => Text(
        label,
        style: text.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: colors.onSurface,
          letterSpacing: 0.2,
        ),
      );
}

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
  Widget build(BuildContext context) => GestureDetector(
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
              color: selected
                  ? colors.onPrimaryContainer
                  : colors.onSurface,
            ),
          ),
        ),
      );
}
