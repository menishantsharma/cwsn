import 'package:flutter/material.dart';

class Setting {
  final IconData icon;
  final String label;
  
  final VoidCallback onTap;

  Setting({required this.icon, required this.label, required this.onTap});
}
