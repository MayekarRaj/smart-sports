import 'package:flutter/material.dart';
import 'package:smart_sports/role_specific/coach/screens/courts/coach_courts_page.dart';
import 'package:smart_sports/role_specific/coach/screens/dashboard/coach_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/coach/screens/transactions/coach_transactions_page.dart';
import 'package:smart_sports/role_specific/coach/screens/bookings/coach_bookings_page.dart';
import 'package:smart_sports/role_specific/coach/screens/events/coach_events_page.dart';
import 'package:smart_sports/role_specific/coach/screens/referrals/coach_referrals_page.dart';

class CoachDashboardPage extends StatefulWidget {
  const CoachDashboardPage({super.key});

  @override
  State<CoachDashboardPage> createState() => _CoachDashboardPageState();
}

class _CoachDashboardPageState extends State<CoachDashboardPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _getPageForIndex(selectedIndex),
      ),
    );
  }

  Widget _getPageForIndex(int index) {
    switch (index) {
      case 0:
        return const CoachAnalyticsDashboardPage();
      case 1:
        return const CoachTransactionsPage();
      case 2:
        return const CoachCourtsPage();
      case 3:
        return const _PlaceholderPage(title: 'Clubs');
      case 4:
        return const CoachBookingsPage();
      case 5:
        return const CoachEventsPage();
      case 6:
        return const _PlaceholderPage(title: 'Sponsorships');
      case 7:
        return const _PlaceholderPage(title: 'Users');
      case 8:
        return const CoachReferralsPage();
      default:
        return const Center(child: Text('Unknown section'));
    }
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('$title screen coming soon'));
  }
}
