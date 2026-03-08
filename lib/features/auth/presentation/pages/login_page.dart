import 'package:cwsn/features/auth/data/auth_repository.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(currentUserProvider);
    final isLoading = authState.isLoading;

    final authNotifier = ref.read(currentUserProvider.notifier);
    final authRepo = ref.read(authRepositoryProvider);

    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  CircleAvatar(
                    radius: 48,
                    backgroundColor: primaryColor.withValues(alpha: 0.08),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 48,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    "Welcome to CWSN",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Find trusted caregivers for your loved ones,\nor join us to help others.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const Spacer(),

                  IgnorePointer(
                    ignoring: isLoading,
                    child: Opacity(
                      opacity: isLoading ? 0.6 : 1.0,
                      child: Column(
                        children: [
                          _AuthButton(
                            text: "Continue with Google",
                            icon: FontAwesomeIcons.google,
                            iconColor: Colors.red,
                            isOutlined: true,
                            onTap: () =>
                                authNotifier.login(authRepo.signInWithGoogle),
                          ),
                          const SizedBox(height: 12),

                          _AuthButton(
                            text: "Continue with Apple",
                            icon: FontAwesomeIcons.apple,
                            iconColor: Colors.white,
                            bgColor: Colors.black,
                            textColor: Colors.white,
                            onTap: () =>
                                authNotifier.login(authRepo.signInWithApple),
                          ),
                          const SizedBox(height: 12),

                          _AuthButton(
                            text: "Continue with Facebook",
                            icon: FontAwesomeIcons.facebookF,
                            iconColor: Colors.white,
                            bgColor: const Color(0xFF1877F2),
                            textColor: Colors.white,
                            onTap: () =>
                                authNotifier.login(authRepo.signInWithFacebook),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => authNotifier.login(authRepo.signInAsGuest),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                    child: const Text(
                      "Skip & Browse as Guest",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white.withValues(alpha: 0.6),
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final Color bgColor;
  final Color textColor;
  final bool isOutlined;

  const _AuthButton({
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.bgColor = Colors.white,
    this.textColor = Colors.black87,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
    const padding = EdgeInsets.symmetric(vertical: 16);
    final textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: textColor,
    );

    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20, color: iconColor),
        label: Text(text, style: textStyle),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          padding: padding,
          shape: shape,
          side: BorderSide(color: Colors.grey.shade300),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20, color: iconColor),
      label: Text(text, style: textStyle),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: padding,
        shape: shape,
      ),
    );
  }
}
