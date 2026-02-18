import 'package:cwsn/features/auth/data/auth_repository.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Efficiently watch the AsyncValue state directly
    final authState = ref.watch(currentUserProvider);
    final isLoading = authState.isLoading;

    // 2. Read the notifier and repository once for cleaner button callbacks
    final authNotifier = ref.read(currentUserProvider.notifier);
    final authRepo = ref.read(authRepositoryProvider);

    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- BACKGROUND DECORATIONS ---
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // --- MAIN CONTENT ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // HERO ICON
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 80,
                      color: primaryColor,
                    ),
                  ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Welcome to CWSN",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ).animate().fade().slideY(begin: 0.3, end: 0, delay: 100.ms),

                  const SizedBox(height: 12),
                  Text(
                    "Find trusted caregivers for your loved ones,\nor join us to help others.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey.shade600,
                    ),
                  ).animate().fade(delay: 200.ms).slideY(begin: 0.3, end: 0),

                  const Spacer(),

                  // --- LOGIN BUTTONS STACK ---
                  // Use IgnorePointer to disable clicks while loading, and fade the buttons
                  IgnorePointer(
                    ignoring: isLoading,
                    child: AnimatedOpacity(
                      opacity: isLoading ? 0.5 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        children: [
                          // 1. GOOGLE
                          _SocialLoginButton(
                            text: "Continue with Google",
                            icon: FontAwesomeIcons.google,
                            iconColor: Colors.red,
                            onTap: () =>
                                authNotifier.login(authRepo.signInWithGoogle),
                            delay: 400,
                          ),
                          const SizedBox(height: 16),

                          // 2. APPLE (Black Theme)
                          _SocialLoginButton(
                            text: "Continue with Apple",
                            icon: FontAwesomeIcons.apple,
                            iconColor: Colors.white,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            onTap: () =>
                                authNotifier.login(authRepo.signInWithApple),
                            delay: 500,
                          ),
                          const SizedBox(height: 16),

                          // 3. FACEBOOK (Blue Theme)
                          _SocialLoginButton(
                            text: "Continue with Facebook",
                            icon: FontAwesomeIcons.facebookF,
                            iconColor: Colors.white,
                            backgroundColor: const Color(0xFF1877F2),
                            textColor: Colors.white,
                            onTap: () =>
                                authNotifier.login(authRepo.signInWithFacebook),
                            delay: 600,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Guest Button
                  IgnorePointer(
                    ignoring: isLoading,
                    child: AnimatedOpacity(
                      opacity: isLoading ? 0.5 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: TextButton(
                        onPressed: () =>
                            authNotifier.login(authRepo.signInAsGuest),
                        child: Text(
                          "Skip & Browse as Guest",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ).animate().fade(delay: 700.ms),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // --- FULL SCREEN LOADING OVERLAY ---
          if (isLoading)
            Container(
              color: Colors.white.withValues(alpha: 0.5),
              child: Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}

// --- REUSABLE SOCIAL BUTTON (Unchanged) ---
class _SocialLoginButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final int delay;

  const _SocialLoginButton({
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: backgroundColor == Colors.white
            ? Border.all(color: Colors.grey.shade200)
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D1617).withValues(alpha: 0.06),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(delay: delay.ms).slideY(begin: 0.5, end: 0);
  }
}
