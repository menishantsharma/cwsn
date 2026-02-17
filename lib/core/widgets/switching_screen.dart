import 'dart:async';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/router/app_router.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SwitchingScreen extends ConsumerStatefulWidget {
  const SwitchingScreen({super.key});

  @override
  ConsumerState<SwitchingScreen> createState() => _SwitchingScreenState();
}

class _SwitchingScreenState extends ConsumerState<SwitchingScreen> {
  late bool _isSwitchingToCaregiver;

  @override
  void initState() {
    super.initState();
    _isSwitchingToCaregiver = !ref.read(isCaregiverProvider);
    _startSwitchingProcess();
  }

  Future<void> _startSwitchingProcess() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    final user = ref.read(currentUserProvider);

    if (user != null) {
      final newRole = _isSwitchingToCaregiver
          ? UserRole.caregiver
          : UserRole.parent;
      ref.read(currentUserProvider.notifier).state = user.copyWith(
        activeRole: newRole,
      );
    }

    context.goNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withValues(alpha: 0.1),
                        ),
                      )
                      .animate(onPlay: (loop) => loop.repeat())
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.5, 1.5),
                        duration: 1500.ms,
                      )
                      .fadeOut(duration: 1500.ms),

                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child:
                          Icon(
                                _isSwitchingToCaregiver
                                    ? Icons.volunteer_activism_rounded
                                    : Icons.family_restroom_rounded,
                                size: 32,
                                color: primaryColor,
                              )
                              .animate()
                              .scale(
                                duration: 400.ms,
                                curve: Curves.easeOutBack,
                              )
                              .fadeIn(duration: 400.ms),
                    ),
                  ),

                  SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                      color: primaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Text(
              _isSwitchingToCaregiver
                  ? "Switching to Caregiver..."
                  : "Switching to Parent...",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 200.ms),

            const SizedBox(height: 8),

            Text(
              "Please wait a moment",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
          ],
        ),
      ),
    );
  }
}
