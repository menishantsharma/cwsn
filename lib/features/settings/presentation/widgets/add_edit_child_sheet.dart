import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddEditChildSheet extends StatefulWidget {
  final ChildModel? existingChild;
  final Function(ChildModel) onSave;

  const AddEditChildSheet({
    super.key,
    this.existingChild,
    required this.onSave,
  });

  @override
  State<AddEditChildSheet> createState() => _AddEditChildSheetState();
}

class _AddEditChildSheetState extends State<AddEditChildSheet> {
  late final TextEditingController _nameController;
  DateTime? _selectedDob;
  Gender? _selectedGender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingChild?.name)
      ..addListener(_onTextChanged);

    _selectedDob = widget.existingChild?.dateOfBirth;
    _selectedGender = widget.existingChild?.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _selectedDob != null &&
      _selectedGender != null;

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    final childData = ChildModel(
      id: widget.existingChild?.id ?? "temp_id",
      name: _nameController.text.trim(),
      dateOfBirth: _selectedDob!,
      gender: _selectedGender!,
    );

    await widget.onSave(childData);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isEditing = widget.existingChild != null;

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

              Text(
                isEditing ? "Edit Profile" : "Add New Child",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              _NameInput(controller: _nameController),
              const SizedBox(height: 16),

              _DateSelector(
                selectedDate: _selectedDob,
                onDateSelected: (date) => setState(() => _selectedDob = date),
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 24),

              _GenderSelector(
                selectedGender: _selectedGender,
                onChanged: (gender) => setState(() => _selectedGender = gender),
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isValid && !_isLoading) ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: Colors.grey.shade200,
                    disabledForegroundColor: Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: _isValid ? 4 : 0,
                    shadowColor: primaryColor.withValues(alpha: 0.4),
                  ),
                  child: _isLoading
                      ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                      : Text(
                          isEditing ? "Save Changes" : "Add Child",
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
}

class _NameInput extends StatelessWidget {
  final TextEditingController controller;

  const _NameInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: "Full Name",
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(
            Icons.person_outline_rounded,
            color: Colors.grey.shade400,
            size: 20,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 36),
        ),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final Color primaryColor;

  const _DateSelector({
    required this.selectedDate,
    required this.onDateSelected,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = selectedDate != null;
    final dateText = hasDate
        ? "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}"
        : "Tap to select";

    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
          lastDate: DateTime.now(),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.black87,
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) onDateSelected(picked);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.cake_outlined, color: Colors.grey.shade400, size: 20),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Date of Birth",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  dateText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: hasDate ? Colors.black87 : Colors.grey.shade500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final Gender? selectedGender;
  final ValueChanged<Gender?> onChanged;
  final Color primaryColor;

  const _GenderSelector({
    required this.selectedGender,
    required this.onChanged,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 10),
          child: Text(
            "Gender",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: Gender.values.map((gender) {
            final isSelected = selectedGender == gender;
            final label =
                gender.name[0].toUpperCase() + gender.name.substring(1);

            IconData icon = Icons.transgender_rounded;
            if (gender == Gender.male) icon = Icons.male_rounded;
            if (gender == Gender.female) icon = Icons.female_rounded;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();

                  // OPTIMIZED: If already selected, pass null to unselect. Otherwise, pass the gender.
                  onChanged(isSelected ? null : gender);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey.shade200,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.grey.shade400,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade600,
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
        ),
      ],
    );
  }
}
