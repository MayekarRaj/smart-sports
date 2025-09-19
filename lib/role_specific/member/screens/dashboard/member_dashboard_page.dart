import 'package:flutter/material.dart';

class MemberDashboardPage extends StatelessWidget {
  const MemberDashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Member Dashboard')),
      body: const Center(child: Text('Welcome to Member Dashboard')),
    );
  }
}
