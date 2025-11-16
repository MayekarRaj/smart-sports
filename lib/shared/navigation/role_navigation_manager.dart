import 'package:flutter/material.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';

// Club imports
import 'package:smart_sports/role_specific/club/screens/dashboard/club_analytics_dashboard_page.dart'
    as club_dashboard;
import 'package:smart_sports/role_specific/club/screens/transactions/club_transactions_page.dart'
    as club_transactions;
import 'package:smart_sports/role_specific/club/screens/courts/courts_page.dart'
    as club_courts;
import 'package:smart_sports/role_specific/club/screens/bookings/club_bookings_page.dart'
    as club_bookings;
import 'package:smart_sports/role_specific/club/screens/events/club_events_page.dart'
    as club_events;
import 'package:smart_sports/role_specific/club/screens/users/club_users_page.dart'
    as club_users;
import 'package:smart_sports/role_specific/club/screens/referrals/club_referrals_page.dart'
    as club_referrals;
import 'package:smart_sports/role_specific/club/screens/customer_support/club_customer_support_page.dart'
    as club_support;
import 'package:smart_sports/role_specific/club/screens/settings/club_settings_page.dart'
    as club_settings;
import 'package:smart_sports/role_specific/club/screens/profile/club_profile_page.dart'
    as club_profile;
import 'package:smart_sports/role_specific/club/screens/sponsorships/club_sponsorships_page.dart'
    as club_sponsorships;
import 'package:smart_sports/role_specific/club/screens/clubs/clubs_page.dart'
    as club_clubs;
import 'package:smart_sports/role_specific/coach/screens/clubs/coach_page.dart'
    as coach_clubs;

// Coach imports
import 'package:smart_sports/role_specific/coach/screens/dashboard/coach_analytics_dashboard_page.dart'
    as coach_dashboard;
import 'package:smart_sports/role_specific/coach/screens/transactions/coach_transactions_page.dart'
    as coach_transactions;
import 'package:smart_sports/role_specific/coach/screens/bookings/coach_bookings_page.dart'
    as coach_bookings;
import 'package:smart_sports/role_specific/coach/screens/events/coach_events_page.dart'
    as coach_events;
import 'package:smart_sports/role_specific/coach/screens/users/coach_users_page.dart'
    as coach_users;
import 'package:smart_sports/role_specific/coach/screens/referrals/coach_referrals_page.dart'
    as coach_referrals;
import 'package:smart_sports/role_specific/coach/screens/customer_support/coach_customer_support_page.dart'
    as coach_support;
import 'package:smart_sports/role_specific/coach/screens/settings/coach_settings_page.dart'
    as coach_settings;
import 'package:smart_sports/role_specific/coach/screens/profile/coach_profile_page.dart'
    as coach_profile;
import 'package:smart_sports/role_specific/coach/screens/sponsorships/coach_sponsorships_page.dart'
    as coach_sponsorships;

// Corporate imports
import 'package:smart_sports/role_specific/corporate/screens/dashboard/corporate_analytics_dashboard_page.dart'
    as corporate_dashboard;
import 'package:smart_sports/role_specific/corporate/screens/transactions/corporate_transactions_page.dart'
    as corporate_transactions;
import 'package:smart_sports/role_specific/corporate/screens/clubs/corporate_page.dart'
    as corporate_clubs;
import 'package:smart_sports/role_specific/corporate/screens/bookings/corporate_bookings_page.dart'
    as corporate_bookings;
import 'package:smart_sports/role_specific/corporate/screens/events/corporate_events_page.dart'
    as corporate_events;
import 'package:smart_sports/role_specific/corporate/screens/sponsorships/corporate_sponsorships_page.dart'
    as corporate_sponsorships;
import 'package:smart_sports/role_specific/corporate/screens/users/corporate_users_page.dart'
    as corporate_users;
import 'package:smart_sports/role_specific/corporate/screens/referrals/corporate_referrals_page.dart'
    as corporate_referrals;
import 'package:smart_sports/role_specific/corporate/screens/customer_support/corporate_customer_support_page.dart'
    as corporate_support;
import 'package:smart_sports/role_specific/corporate/screens/profile/corporate_profile_page.dart'
    as corporate_profile;

// Merchandiser imports
import 'package:smart_sports/role_specific/merchandiser/screens/dashboard/merchandiser_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/transactions/merchandiser_transactions_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/bookings/merchandiser_bookings_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/events/merchandiser_events_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/users/merchandiser_users_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/referrals/merchandiser_referrals_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/customer_support/merchandiser_customer_support_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/settings/merchandiser_settings_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/inventory/merchandiser_inventory_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/profile/merchandiser_profile_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/sponsorships/merchandiser_sponsorships_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/clubs/merchandiser_page.dart';

// Freelancer imports
import 'package:smart_sports/role_specific/freelancer/screens/dashboard/freelancer_dashboard_page.dart';
import 'package:smart_sports/role_specific/freelancer/screens/transaction/freelancer_transactions_page.dart';
import 'package:smart_sports/role_specific/freelancer/screens/service/freelancer_service_page.dart';
import 'package:smart_sports/role_specific/freelancer/screens/clubs/freelancer_clubs_page.dart';
import 'package:smart_sports/role_specific/freelancer/screens/bookings/freelancer_bookings_page.dart';
import 'package:smart_sports/role_specific/freelancer/screens/event_tournament/freelancer_events_page.dart';
import 'package:smart_sports/role_specific/freelancer/screens/sponsorships/freelancer_sponsorships_page.dart';
import 'package:smart_sports/role_specific/freelancer/screens/membership_plan/freelancer_membership_plan_page.dart';
import 'package:smart_sports/role_specific/freelancer/screens/users/freelancer_users_page.dart';
import 'package:smart_sports/role_specific/freelancer/screens/customer_support/freelancer_customer_support_page.dart';
import 'package:smart_sports/role_specific/freelancer/screens/profile/freelancer_profile_page.dart'
    as freelancer_profile;

// Member imports
import 'package:smart_sports/role_specific/member/screens/dashboard/member_dashboard_page.dart';
import 'package:smart_sports/role_specific/member/screens/transactions/member_transactions_page.dart';
import 'package:smart_sports/role_specific/member/screens/clubs/member_clubs_page.dart';
import 'package:smart_sports/role_specific/member/screens/bookings/member_bookings_page.dart';
import 'package:smart_sports/role_specific/member/screens/events/member_events_page.dart';
import 'package:smart_sports/role_specific/member/screens/sponsorships/member_sponsorships_page.dart';
import 'package:smart_sports/role_specific/member/screens/referrals/member_referrals_page.dart';
import 'package:smart_sports/role_specific/member/screens/customer_support/member_customer_support_page.dart';
import 'package:smart_sports/role_specific/member/screens/settings/member_settings_page.dart';
import 'package:smart_sports/role_specific/member/screens/profile/member_profile_page.dart';

/// Centralized navigation manager for role-specific screens
/// Handles consistent navigation behavior across all role screens
class RoleNavigationManager {
  static void navigateToScreen(
    BuildContext context,
    UserRole role,
    int index, {
    bool closeDrawer = true,
  }) {
    if (closeDrawer) {
      Navigator.of(context).pop(); // Close drawer first
    }

    // Small delay to ensure drawer closes before navigation
    Future.delayed(const Duration(milliseconds: 100), () {
      _performNavigation(context, role, index);
    });
  }

  static void _performNavigation(
    BuildContext context,
    UserRole role,
    int index,
  ) {
    switch (role) {
      case UserRole.club:
        _navigateClubScreen(context, index);
        break;
      case UserRole.coach:
        _navigateCoachScreen(context, index);
        break;
      case UserRole.corporate:
        _navigateCorporateScreen(context, index);
        break;
      case UserRole.merchandiser:
        _navigateMerchandiserScreen(context, index);
        break;
      case UserRole.member:
        _navigateMemberScreen(context, index);
        break;
      case UserRole.freelancer:
        _navigateFreelancerScreen(context, index);
        break;
    }
  }

  static void _navigateClubScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Dashboard - always navigate to dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const club_dashboard.ClubAnalyticsDashboardPage(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const club_transactions.ClubTransactionsPage(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const club_courts.ClubCourtsPage()),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const club_clubs.ClubsPage()),
        );
        break;
      case 4:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const club_bookings.ClubBookingsPage(),
          ),
        );
        break;
      case 5:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const club_events.ClubEventsPage()),
        );
        break;
      case 6:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const club_sponsorships.ClubSponsorshipsPage(),
          ),
        );
        break;
      case 7:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const club_users.ClubUsersPage()),
        );
        break;
      case 8:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const club_referrals.ClubReferralsPage(),
          ),
        );
        break;
      case 9:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const club_support.ClubCustomerSupportPage(),
          ),
        );
        break;
      case 10:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const club_settings.ClubSettingsPage(),
          ),
        );
        break;
    }
  }

  static void _navigateCoachScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const coach_dashboard.CoachAnalyticsDashboardPage(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const coach_transactions.CoachTransactionsPage(),
          ),
        );
        break;
      // Courts removed - commented out
      // case 2:
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(
      //       builder: (_) => const coach_courts.ClubCourtsPage(),
      //     ),
      //   );
      //   break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const coach_clubs.ClubsPage()),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const coach_bookings.CoachBookingsPage(),
          ),
        );
        break;
      case 4:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const coach_events.CoachEventsPage(),
          ),
        );
        break;
      case 5:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const coach_sponsorships.ClubSponsorshipsPage(),
          ),
        );
        break;
      case 6:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const coach_users.CoachUsersPage()),
        );
        break;
      case 7:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const coach_referrals.CoachReferralsPage(),
          ),
        );
        break;
      case 8:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const coach_support.CoachCustomerSupportPage(),
          ),
        );
        break;
      case 9:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const coach_settings.CoachSettingsPage(),
          ),
        );
        break;
    }
  }

  static void _navigateCorporateScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const corporate_dashboard.CorporateAnalyticsDashboardPage(),
          ),
        );
        break;
      case 1:
        // Transactions
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const corporate_transactions.CorporateTransactionsPage(),
          ),
        );
        break;
      case 2:
        // Clubs
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const corporate_clubs.ClubsPage()),
        );
        break;
      case 3:
        // Bookings
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const corporate_bookings.CorporateBookingsPage(),
          ),
        );
        break;
      case 4:
        // Events / Tournaments
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const corporate_events.CorporateEventsPage(),
          ),
        );
        break;
      case 5:
        // Sponsorships
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const corporate_sponsorships.CorporateSponsorshipsPage(),
          ),
        );
        break;
      case 6:
        // Membership Plan (placeholder - no screen exists yet)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const _CorporatePlaceholder(
              title: 'Membership Plan',
              currentIndex: 6,
            ),
          ),
        );
        break;
      case 7:
        // Users
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const corporate_users.CorporateUsersPage(),
          ),
        );
        break;
      case 8:
        // Referrals
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const corporate_referrals.CorporateReferralsPage(),
          ),
        );
        break;
      case 9:
        // Customer Support
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const corporate_support.CorporateCustomerSupportPage(),
          ),
        );
        break;
    }
  }

  static void _navigateMerchandiserScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MerchandiserAnalyticsDashboardPage(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MerchandiserTransactionsPage(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MerchandiserInventoryPage()),
        );
        break;
      case 3:
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const ClubsPage()));
        break;
      case 4:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MerchandiserBookingsPage()),
        );
        break;
      case 5:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MerchandiserEventsPage()),
        );
        break;
      case 6:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MerchandiserSponsorshipsPage(),
          ),
        );
        break;
      case 7:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MerchandiserUsersPage()),
        );
        break;
      case 8:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MerchandiserReferralsPage()),
        );
        break;
      case 9:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MerchandiserCustomerSupportPage(),
          ),
        );
        break;
      case 10:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MerchandiserSettingsPage()),
        );
        break;
    }
  }

  static void _navigateMemberScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MemberDashboardPage(),
          ),
        );
        break;
      case 1:
        // Transactions
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MemberTransactionsPage(),
          ),
        );
        break;
      case 2:
        // My Clubs
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MemberClubsPage(),
          ),
        );
        break;
      case 3:
        // Bookings
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MemberBookingsPage(),
          ),
        );
        break;
      case 4:
        // Events / Tournaments
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MemberEventsPage(),
          ),
        );
        break;
      case 5:
        // Sponsorships
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MemberSponsorshipsPage(),
          ),
        );
        break;
      case 6:
        // Referrals
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MemberReferralsPage(),
          ),
        );
        break;
      case 7:
        // Customer Support
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MemberCustomerSupportPage(),
          ),
        );
        break;
      case 8:
        // Settings
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MemberSettingsPage(),
          ),
        );
        break;
    }
  }

  static void _navigateFreelancerScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const FreelancerDashboardPage(),
          ),
        );
        break;
      case 1:
        // Transactions
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const FreelancerTransactionsPage(),
          ),
        );
        break;
      case 2:
        // Service
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const FreelancerServicePage(),
          ),
        );
        break;
      case 3:
        // Clubs
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const FreelancerClubsPage(),
          ),
        );
        break;
      case 4:
        // Bookings
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const FreelancerBookingsPage(),
          ),
        );
        break;
      case 5:
        // Events / Tournaments
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const FreelancerEventsPage(),
          ),
        );
        break;
      case 6:
        // Sponsorships
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const FreelancerSponsorshipsPage(),
          ),
        );
        break;
      case 7:
        // Membership Plan
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const FreelancerMembershipPlanPage(),
          ),
        );
        break;
      case 8:
        // Users
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const FreelancerUsersPage(),
          ),
        );
        break;
      case 9:
        // Customer Support
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const FreelancerCustomerSupportPage(),
          ),
        );
        break;
    }
  }

  /// Navigate to profile page
  static void navigateToProfile(BuildContext context, UserRole role) {
    Navigator.of(context).pop(); // Close drawer first

    Future.delayed(const Duration(milliseconds: 100), () {
      switch (role) {
        case UserRole.club:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const club_profile.ClubProfilePage(),
            ),
          );
          break;
        case UserRole.coach:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const coach_profile.CoachProfilePage(),
            ),
          );
          break;
        case UserRole.corporate:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const corporate_profile.CorporateProfilePage(),
            ),
          );
          break;
        case UserRole.merchandiser:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MerchandiserProfilePage()),
          );
          break;
        case UserRole.member:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MemberProfilePage()),
          );
          break;
        case UserRole.freelancer:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const freelancer_profile.FreelancerProfilePage(),
            ),
          );
          break;
      }
    });
  }
}

// Placeholder widgets for other roles


class _CorporatePlaceholder extends StatelessWidget {
  final String title;
  final int currentIndex;

  const _CorporatePlaceholder({
    required this.title,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.corporate,
            selectedIndex: currentIndex,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.corporate,
              i,
            ),
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.corporate,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              '$title Screen',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
