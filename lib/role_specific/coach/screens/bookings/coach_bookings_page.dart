import 'package:flutter/material.dart';
import 'package:smart_sports/bookings/screens/booking_management_screen.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';

class CoachBookingsPage extends StatelessWidget {
  const CoachBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BookingManagementScreen(
      role: UserRole.coach,
      selectedIndex: 3, // Bookings is at index 3 (courts removed)
    );
  }
}

// Navigation from sidebar now centralized via RoleNavigationManager
