import 'package:flutter/material.dart';

class AddChildPage extends StatelessWidget {
  const AddChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Child')),
      body: const Center(child: Text('Add Child Page Content Here')),
    );
  }
}
