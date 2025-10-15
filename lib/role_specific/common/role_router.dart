import 'package:flutter/material.dart';
import '../club/screens/dashboard/club_analytics_dashboard_page.dart' as club;
import '../coach/screens/dashboard/coach_analytics_dashboard_page.dart'
    as coach;
import '../corporate/screens/dashboard/corporate_analytics_dashboard_page.dart'
    as corporate;
import '../member/screens/dashboard/member_dashboard_page.dart';
import '../freelancer/screens/dashboard/freelancer_dashboard_page.dart';
import '../merchandiser/screens/dashboard/merchandiser_dashboard_page.dart';

enum UserRole { club, coach, corporate, member, freelancer, merchandiser }

extension UserRoleX on UserRole {
  String get label => name[0].toUpperCase() + name.substring(1);
}

class RoleRouter {
  static Widget dashboardFor(UserRole role) {
    switch (role) {
      case UserRole.club:
        return const club.ClubAnalyticsDashboardPage();
      case UserRole.coach:
        return const coach.CoachAnalyticsDashboardPage();
      case UserRole.corporate:
        return const corporate.CorporateAnalyticsDashboardPage();
      case UserRole.member:
        return const MemberDashboardPage();
      case UserRole.freelancer:
        return const FreelancerDashboardPage();
      case UserRole.merchandiser:
        return const MerchandiserDashboardPage();
    }
  }
}
