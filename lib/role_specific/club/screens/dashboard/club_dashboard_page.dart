import 'package:flutter/material.dart';

class ClubDashboardPage extends StatelessWidget {
  const ClubDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Club Dashboard')),
      body: const Center(child: Text('Welcome to Club Dashboard')),
    );
  }
}
