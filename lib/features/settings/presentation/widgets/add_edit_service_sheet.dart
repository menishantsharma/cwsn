import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddEditServiceSheet extends StatefulWidget {
  final String? existingService;
  final Function(String) onSave;

  const AddEditServiceSheet({
    super.key,
    this.existingService,
    required this.onSave,
  });

  @override
  State<AddEditServiceSheet> createState() => _AddEditServiceSheetState();
}

class _AddEditServiceSheetState extends State<AddEditServiceSheet> {
  late final TextEditingController _serviceController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _serviceController = TextEditingController(text: widget.existingService)
      ..addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _serviceController.dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  bool get _isValid => _serviceController.text.trim().isNotEmpty;

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    final serviceData = _serviceController.text.trim();
    await widget.onSave(serviceData);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isEditing = widget.existingService != null;

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
                isEditing ? "Edit Service" : "Add New Service",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Service Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TextField(
                  controller: _serviceController,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Service Name",
                    labelStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.medical_services_outlined,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 36),
                  ),
                ),
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
}
