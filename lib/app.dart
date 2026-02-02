import 'package:cwsn/core/router/app_router.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // App title and theme configuration
      title: 'CWSN App',
      // theme
      theme: AppTheme.lightTheme,
      // Router configuration for navigation
      routerConfig: goRouter,
    );
  }
}
