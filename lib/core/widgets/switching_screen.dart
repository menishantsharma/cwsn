import 'package:cwsn/core/providers/user_mode_provider.dart';
import 'package:cwsn/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class SwitchingScreen extends ConsumerStatefulWidget {
  const SwitchingScreen({super.key});

  @override
  ConsumerState<SwitchingScreen> createState() => _SwitchingScreenState();
}

class _SwitchingScreenState extends ConsumerState<SwitchingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final isCaregiverMode = ref.read(userModeProvider);
        ref.read(userModeProvider.notifier).state = !isCaregiverMode;

        if (isCaregiverMode) {
          context.goNamed(AppRoutes.home);
        } else {
          context.goNamed(AppRoutes.requests);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitThreeBounce(
              color: Theme.of(context).primaryColor,
              size: 30.0,
            ),

            const SizedBox(height: 20),

            Text(
              'Switching Mode...',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
