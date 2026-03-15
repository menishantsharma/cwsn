import 'package:cwsn/core/models/caregiver_service_model.dart';
import 'package:cwsn/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:cwsn/features/services/presentation/providers/services_provider.dart';
import 'package:cwsn/features/special_needs/presentation/providers/special_needs_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddEditServiceSheet extends ConsumerStatefulWidget {
  final CaregiverService? existingService;
  final Future<void> Function(CaregiverService) onSave;

  const AddEditServiceSheet({
    super.key,
    this.existingService,
    required this.onSave,
  });

  @override
  ConsumerState<AddEditServiceSheet> createState() =>
      _AddEditServiceSheetState();
}

class _AddEditServiceSheetState extends ConsumerState<AddEditServiceSheet> {
  String? _selectedServiceName;
  final Set<String> _selectedSpecialNeeds = {};
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingService != null) {
      _selectedServiceName = widget.existingService!.name;
      _selectedSpecialNeeds.addAll(widget.existingService!.specialNeeds);
      _isActive = widget.existingService!.isActive;
    }
  }

  bool get _isValid =>
      _selectedServiceName != null &&
      _selectedServiceName!.isNotEmpty &&
      _selectedSpecialNeeds.isNotEmpty;

  void _onServiceChanged(String? val) {
    if (val == _selectedServiceName) return;
    setState(() {
      _selectedServiceName = val;
      _selectedSpecialNeeds.clear();
    });
  }

  Future<void> _submit() async {
    if (!_isValid) return;
    setState(() => _isLoading = true);

    final service = CaregiverService(
      id: widget.existingService?.id ?? '',
      name: _selectedServiceName!,
      specialNeeds: _selectedSpecialNeeds.toList(),
      isActive: _isActive,
    );

    await widget.onSave(service);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final isEditing = widget.existingService != null;
    final masterNames = ref.watch(masterServiceNamesProvider);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomSheetDragHandle(),

              Text(
                isEditing ? "Edit Service" : "Add New Service",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // ── Service name picker ─────────────────────────────────
              const Text(
                'Service',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              masterNames.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
                error: (_, _) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Failed to load services'),
                ),
                data: (names) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedServiceName,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.medical_services_outlined,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                    ),
                    hint: Text(
                      'Select a service',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    items: names
                        .map(
                          (n) => DropdownMenuItem(value: n, child: Text(n)),
                        )
                        .toList(),
                    onChanged: _onServiceChanged,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Special needs multi-select (service-dependent) ──────
              const Text(
                'Special Needs Covered',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                _selectedServiceName == null
                    ? 'Select a service first'
                    : 'Select conditions this service supports',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              _buildSpecialNeedsSection(primary),
              const SizedBox(height: 24),

              // ── Active toggle ───────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile.adaptive(
                  title: const Text(
                    'Active',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  subtitle: Text(
                    'Clients can see this service when active',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  value: _isActive,
                  activeTrackColor: primary,
                  onChanged: (val) => setState(() => _isActive = val),
                ),
              ),
              const SizedBox(height: 32),

              // ── Submit button ───────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isValid && !_isLoading) ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    disabledBackgroundColor: Colors.grey.shade200,
                    disabledForegroundColor: Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: _isValid ? 4 : 0,
                    shadowColor: primary.withValues(alpha: 0.4),
                  ),
                  child: _isLoading
                      ? const SpinKitThreeBounce(
                          color: Colors.white, size: 20)
                      : Text(
                          isEditing ? "Save Changes" : "Add Service",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialNeedsSection(Color primary) {
    if (_selectedServiceName == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 16, color: Colors.grey.shade400),
            const SizedBox(width: 8),
            Text(
              'Select a service to see available options',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
    }

    final asyncNeeds =
        ref.watch(specialNeedsByServiceProvider(_selectedServiceName!));

    return asyncNeeds.when(
      loading: () => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, _) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Failed to load special needs'),
      ),
      data: (needs) {
        if (needs.isEmpty) {
          return Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              'No special needs mapped to this service yet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          );
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: needs
              .map(
                (need) => FilterChip(
                  label: Text(
                    need,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: _selectedSpecialNeeds.contains(need)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: _selectedSpecialNeeds.contains(need),
                  selectedColor: primary.withValues(alpha: 0.1),
                  checkmarkColor: primary,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  onSelected: (selected) => setState(
                    () => selected
                        ? _selectedSpecialNeeds.add(need)
                        : _selectedSpecialNeeds.remove(need),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
