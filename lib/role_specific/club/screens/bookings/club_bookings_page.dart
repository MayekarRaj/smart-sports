import 'package:flutter/material.dart';
import 'package:smart_sports/bookings/screens/booking_management_screen.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';

class ClubBookingsPage extends StatelessWidget {
  const ClubBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BookingManagementScreen(role: UserRole.club, selectedIndex: 4);
  }
}

// Navigation from sidebar now centralized via RoleNavigationManager
