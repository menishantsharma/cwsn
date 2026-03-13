import 'package:flutter/material.dart';

/// Standard drag handle displayed at the top of bottom sheets.
class BottomSheetDragHandle extends StatelessWidget {
  const BottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
