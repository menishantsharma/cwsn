import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late final TextEditingController _phoneController;
  late final TextEditingController _otpController;
  late final FocusNode _otpFocusNode;

  // 1. OPTIMIZED: ValueNotifiers prevent full-widget rebuilds!
  final ValueNotifier<int> _stepNotifier = ValueNotifier<int>(1);
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    // Strip out the country code and spaces for the clean initial value
    final initialPhone = widget.currentPhone
        .replaceAll('+91 ', '')
        .replaceAll(RegExp(r'[^0-9]'), '');

    _phoneController = TextEditingController(text: initialPhone);
    _otpController = TextEditingController();
    _otpFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _otpFocusNode.dispose();
    _stepNotifier.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    _isLoadingNotifier.value = true;

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      _isLoadingNotifier.value = false;
      _stepNotifier.value = 2; // Move to OTP step

      // OPTIMIZED: Auto-focus the OTP field so the keyboard stays open smoothly
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _otpFocusNode.requestFocus();
      });
    }
  }

  Future<void> _verifyOtp() async {
    _isLoadingNotifier.value = true;

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      widget.onVerified("+91 ${_phoneController.text}");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      // 2. OPTIMIZED: AnimatedSize dynamically shrinks/grows the bottom sheet
      // when swapping between the phone input and OTP input
      child: ValueListenableBuilder<int>(
        valueListenable: _stepNotifier,
        builder: (context, step, child) {
          return AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: step == 1 ? _buildPhoneStep() : _buildOtpStep(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhoneStep() {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      key: const ValueKey('phone_step'),
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
        const Text(
          "Update Phone Number",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "We will send a verification code to this number.",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 24),

        // 3. OPTIMIZED: AutofillGroup allows OS to suggest phone numbers
        AutofillGroup(
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            // Protection against pasting letters
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
            decoration: InputDecoration(
              labelText: "New Phone Number",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              prefixIcon: const Icon(Icons.phone_rounded),
              prefixText: "+91  ",
              prefixStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // 4. OPTIMIZED: Listenable.merge rebuilds ONLY the button when typing
        AnimatedBuilder(
          animation: Listenable.merge([_phoneController, _isLoadingNotifier]),
          builder: (context, child) {
            final isValid = _phoneController.text.length == 10;
            final isLoading = _isLoadingNotifier.value;

            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (isValid && !isLoading) ? _sendOtp : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  disabledBackgroundColor: Colors.grey.shade200,
                  disabledForegroundColor: Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: isValid ? 4 : 0,
                  shadowColor: primaryColor.withValues(alpha: 0.4),
                ),
                child: isLoading
                    ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                    : const Text(
                        "Send Verification Code",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      key: const ValueKey('otp_step'),
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
        Row(
          children: [
            // 5. OPTIMIZED: Allow users to fix typos in their phone number
            InkWell(
              onTap: () {
                _otpController.clear();
                _stepNotifier.value = 1;
              },
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Verify OTP",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            text: "Enter the 6-digit code sent to ",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            children: [
              TextSpan(
                text: "+91 ${_phoneController.text}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 6. OPTIMIZED: oneTimeCode allows OS to intercept SMS and show copy/paste prompt above keyboard
        AutofillGroup(
          child: TextField(
            controller: _otpController,
            focusNode: _otpFocusNode,
            keyboardType: TextInputType.number,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              letterSpacing: 12,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: "000000",
              hintStyle: TextStyle(color: Colors.grey.shade300),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
            ),
            // Auto-submit UX feature
            onChanged: (val) {
              if (val.length == 6) {
                FocusScope.of(context).unfocus();
                _verifyOtp();
              }
            },
          ),
        ),
        const SizedBox(height: 24),

        AnimatedBuilder(
          animation: Listenable.merge([_otpController, _isLoadingNotifier]),
          builder: (context, child) {
            final isValid = _otpController.text.length == 6;
            final isLoading = _isLoadingNotifier.value;

            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (isValid && !isLoading) ? _verifyOtp : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  disabledBackgroundColor: Colors.grey.shade200,
                  disabledForegroundColor: Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: isValid ? 4 : 0,
                  shadowColor: primaryColor.withValues(alpha: 0.4),
                ),
                child: isLoading
                    ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                    : const Text(
                        "Verify & Update",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {
              _otpController.clear();
              _otpFocusNode.requestFocus();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Code resent!")));
            },
            child: Text(
              "Resend Code",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
