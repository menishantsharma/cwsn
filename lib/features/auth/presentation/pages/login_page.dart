import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _agreedToTerms = false;

  void _showTermsSheet() => _showLegalSheet(
        title: 'Terms of Service',
        sections: const [
          ('1. Acceptance of Terms',
              'By accessing or using the CWSN application, you agree to be bound by these Terms of Service. If you do not agree, please do not use the app.'),
          ('2. Description of Service',
              'CWSN connects parents of children with special needs to qualified caregivers and service providers. We facilitate discovery and communication but are not a party to any arrangement between users.'),
          ('3. User Accounts',
              'You are responsible for maintaining the confidentiality of your account credentials. You agree to provide accurate information and to update it as needed. You must be at least 18 years old to create an account.'),
          ('4. User Conduct',
              'You agree not to misuse the platform, post false information, harass other users, or engage in any activity that violates applicable laws or regulations.'),
          ('5. Privacy Policy',
              'Your use of the app is also governed by our Privacy Policy. We collect and process personal data as described therein, including name, contact information, and location data to provide our services.'),
          ('6. Limitation of Liability',
              'CWSN is provided "as is" without warranties of any kind. We are not liable for any damages arising from your use of the service or interactions with other users.'),
          ('7. Changes to Terms',
              'We reserve the right to modify these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.'),
        ],
        onAgree: () => setState(() => _agreedToTerms = true),
      );

  void _showPrivacySheet() => _showLegalSheet(
        title: 'Privacy Policy',
        sections: const [
          ('1. Information We Collect',
              'We collect information you provide directly (name, email, phone number, profile photo) and information generated through your use of the app (search history, preferences, device information).'),
          ('2. How We Use Your Information',
              'We use your information to provide and improve our services, match parents with caregivers, send notifications, and ensure platform safety.'),
          ('3. Information Sharing',
              'We do not sell your personal information. We may share information with service providers who assist in operating the platform, or when required by law.'),
          ('4. Data Security',
              'We implement appropriate security measures to protect your personal information. However, no method of transmission over the internet is 100% secure.'),
          ('5. Your Rights',
              'You may access, update, or delete your personal information at any time through your profile settings. You may also contact us to exercise your data protection rights.'),
        ],
      );

  void _showLegalSheet({
    required String title,
    required List<(String, String)> sections,
    VoidCallback? onAgree,
  }) {
    final primary = Theme.of(context).primaryColor;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  for (final (heading, body) in sections)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(heading,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Text(body,
                              style: TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onAgree?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      onAgree != null ? 'I Agree' : 'Close',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(currentUserProvider);
    final isLoading = authState.isLoading;
    final primary = Theme.of(context).primaryColor;
    final notifier = ref.read(currentUserProvider.notifier);
    final enabled = _agreedToTerms && !isLoading;

    ref.listen<AsyncValue>(currentUserProvider, (_, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Authentication failed. Please try again.'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(Icons.favorite_rounded, size: 40, color: primary),
              ),
              const SizedBox(height: 28),

              // Title
              const Text(
                'Welcome to CWSN',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Find trusted caregivers or offer\nyour services to families in need.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.grey.shade500,
                ),
              ),

              const Spacer(flex: 3),

              // Social icon buttons
              AnimatedOpacity(
                opacity: enabled ? 1.0 : 0.35,
                duration: const Duration(milliseconds: 250),
                child: IgnorePointer(
                  ignoring: !enabled,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _IconCircle(
                        icon: FontAwesomeIcons.google,
                        color: Colors.red,
                        onTap: notifier.loginWithGoogle,
                      ),
                      const SizedBox(width: 24),
                      _IconCircle(
                        icon: FontAwesomeIcons.apple,
                        color: Colors.white,
                        fill: Colors.black,
                        onTap: notifier.loginWithApple,
                      ),
                      const SizedBox(width: 24),
                      _IconCircle(
                        icon: FontAwesomeIcons.facebookF,
                        color: Colors.white,
                        fill: const Color(0xFF1877F2),
                        onTap: notifier.loginWithFacebook,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AnimatedOpacity(
                opacity: enabled ? 1.0 : 0.4,
                duration: const Duration(milliseconds: 250),
                child: Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                ),
              ),

              const SizedBox(height: 32),

              // Terms checkbox
              GestureDetector(
                onTap: () =>
                    setState(() => _agreedToTerms = !_agreedToTerms),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _agreedToTerms,
                        onChanged: (v) =>
                            setState(() => _agreedToTerms = v ?? false),
                        activeColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'I agree to the ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          children: [
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _showTermsSheet,
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _showPrivacySheet,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Guest
              TextButton(
                onPressed: enabled
                    ? notifier.loginAsGuest
                    : null,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade500,
                ),
                child: const Text(
                  'Skip & Browse as Guest',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? fill;
  final VoidCallback onTap;

  const _IconCircle({
    required this.icon,
    required this.color,
    required this.onTap,
    this.fill,
  });

  @override
  Widget build(BuildContext context) {
    final hasFill = fill != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: hasFill ? fill : Colors.white,
          shape: BoxShape.circle,
          border: hasFill ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 22, color: color),
      ),
    );
  }
}
