import 'package:flutter/material.dart';

class CorporateDashboardPage extends StatelessWidget {
  const CorporateDashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Corporate Dashboard')),
      body: const Center(child: Text('Welcome to Corporate Dashboard')),
    );
  }
}
