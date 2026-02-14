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
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  Gender? _selectedGender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingChild?.name ?? "",
    );
    _ageController = TextEditingController(
      text: widget.existingChild != null
          ? widget.existingChild!.age.toString()
          : "",
    );
    _selectedGender = widget.existingChild?.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_nameController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and select gender"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final childData = ChildModel(
      id:
          widget.existingChild?.id ??
          "temp_id", // Backend will generate real ID on ADD
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text) ?? 0,
      gender: _selectedGender!,
    );

    // Call the parent callback to handle API and State updates
    await widget.onSave(childData);

    if (mounted) {
      Navigator.pop(context); // Close sheet
    }
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
        top: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
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
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              isEditing ? "Edit Profile" : "Add New Child",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            _buildInput(
              label: "Full Name",
              controller: _nameController,
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 16),

            _buildInput(
              label: "Age (in years)",
              controller: _ageController,
              icon: Icons.cake_outlined,
              isNumber: true,
            ),
            const SizedBox(height: 24),

            // PILL GENDER SELECTOR
            _buildGenderSelector(),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
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
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isNumber = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
          prefixIconConstraints: const BoxConstraints(minWidth: 36),
        ),
      ),
    );
  }

  // Same Pill logic from Parent Edit Profile
  Widget _buildGenderSelector() {
    final primaryColor = Theme.of(context).primaryColor;

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
            final isSelected = _selectedGender == gender;
            final label =
                gender.name[0].toUpperCase() + gender.name.substring(1);

            IconData icon;
            switch (gender) {
              case Gender.male:
                icon = Icons.male_rounded;
                break;
              case Gender.female:
                icon = Icons.female_rounded;
                break;
              case Gender.other:
                icon = Icons.transgender_rounded;
                break;
            }

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  // Unfocus keyboard when selecting gender
                  FocusScope.of(context).unfocus();
                  setState(() => _selectedGender = gender);
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
