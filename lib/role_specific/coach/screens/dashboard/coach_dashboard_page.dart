import 'package:flutter/material.dart';

class CoachDashboardPage extends StatelessWidget {
  const CoachDashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coach Dashboard')),
      body: const Center(child: Text('Welcome to Coach Dashboard')),
    );
  }
}
