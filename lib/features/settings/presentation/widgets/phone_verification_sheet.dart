import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PhoneVerificationSheet extends StatefulWidget {
  final String currentPhone;
  final Function(String) onVerified;

  const PhoneVerificationSheet({
    super.key,
    required this.currentPhone,
    required this.onVerified,
  });

  @override
  State<PhoneVerificationSheet> createState() => _PhoneVerificationSheetState();
}

class _PhoneVerificationSheetState extends State<PhoneVerificationSheet> {
  final _newPhoneController = TextEditingController();
  final _otpController = TextEditingController();

  int _step = 1; // 1: Phone, 2: OTP
  bool _isLoading = false;

  // Validation State
  bool _isPhoneValid = false;
  bool _isOtpValid = false;

  @override
  void initState() {
    super.initState();

    // Listen to Phone Input Changes
    _newPhoneController.addListener(() {
      final text = _newPhoneController.text;
      // Check if exactly 10 digits
      final isValid = text.length == 10 && int.tryParse(text) != null;
      if (_isPhoneValid != isValid) {
        setState(() => _isPhoneValid = isValid);
      }
    });

    // Listen to OTP Input Changes
    _otpController.addListener(() {
      final text = _otpController.text;
      // Check if 6 digits (standard OTP length)
      final isValid = text.length == 6 && int.tryParse(text) != null;
      if (_isOtpValid != isValid) {
        setState(() => _isOtpValid = isValid);
      }
    });
  }

  @override
  void dispose() {
    _newPhoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    if (!_isPhoneValid) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate API

    if (mounted) {
      setState(() {
        _isLoading = false;
        _step = 2;
      });
    }
  }

  void _verifyOtp() async {
    if (!_isOtpValid) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate API

    if (mounted) {
      // Return format: +91 XXXXX XXXXX
      widget.onVerified("+91 ${_newPhoneController.text}");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // Determine if button is enabled based on current step
    final isButtonEnabled = _step == 1 ? _isPhoneValid : _isOtpValid;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _step == 1 ? "Update Phone Number" : "Verify OTP",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          if (_step == 1) ...[
            // STEP 1: PHONE INPUT
            TextField(
              controller: _newPhoneController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
              decoration: InputDecoration(
                labelText: "New Phone Number",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),
                prefixText: "+91 ",
                prefixStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                counterText: "",
                // Add explicit red border when valid
                focusedBorder: _isPhoneValid
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_isLoading || !isButtonEnabled) ? null : _sendOtp,
                style: ElevatedButton.styleFrom(
                  // 1. Background Color Logic
                  backgroundColor: isButtonEnabled
                      ? primaryColor
                      : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isButtonEnabled ? 4 : 0,
                ),
                child: _isLoading
                    ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                    : const Text(
                        "Send Verification Code",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ] else ...[
            // STEP 2: OTP INPUT
            Text(
              "Enter the 6-digit code sent to +91 ${_newPhoneController.text}",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
              maxLength: 6,
              decoration: InputDecoration(
                hintText: "000000",
                counterText: "",
                border: const OutlineInputBorder(),
                focusedBorder: _isOtpValid
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_isLoading || !isButtonEnabled) ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled
                      ? primaryColor
                      : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isButtonEnabled ? 4 : 0,
                ),
                child: _isLoading
                    ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                    : const Text(
                        "Verify & Update",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
