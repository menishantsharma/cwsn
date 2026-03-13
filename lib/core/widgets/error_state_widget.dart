import 'package:flutter/material.dart';

/// Generic error-state placeholder with a retry action.
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final IconData icon;

  const ErrorStateWidget({
    super.key,
    this.message = 'Something went wrong',
    required this.onRetry,
    this.icon = Icons.wifi_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey.shade300, size: 48),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
