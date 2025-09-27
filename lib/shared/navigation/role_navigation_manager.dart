import 'package:flutter/material.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';

// Club imports
import 'package:smart_sports/role_specific/club/screens/dashboard/club_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/club/screens/transactions/club_transactions_page.dart';
import 'package:smart_sports/role_specific/club/screens/courts/courts_page.dart';
import 'package:smart_sports/role_specific/club/screens/bookings/club_bookings_page.dart';
import 'package:smart_sports/role_specific/club/screens/events/club_events_page.dart';
import 'package:smart_sports/role_specific/club/screens/users/club_users_page.dart';
import 'package:smart_sports/role_specific/club/screens/referrals/club_referrals_page.dart';
import 'package:smart_sports/role_specific/club/screens/customer_support/club_customer_support_page.dart';
import 'package:smart_sports/role_specific/club/screens/settings/club_settings_page.dart';
import 'package:smart_sports/role_specific/club/screens/profile/club_profile_page.dart';
import 'package:smart_sports/role_specific/club/screens/sponsorships/club_sponsorships_page.dart';

// Coach imports
import 'package:smart_sports/role_specific/coach/screens/dashboard/coach_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/coach/screens/transactions/coach_transactions_page.dart';
import 'package:smart_sports/role_specific/coach/screens/courts/coach_courts_page.dart';
import 'package:smart_sports/role_specific/coach/screens/bookings/coach_bookings_page.dart';
import 'package:smart_sports/role_specific/coach/screens/events/coach_events_page.dart';
import 'package:smart_sports/role_specific/coach/screens/users/coach_users_page.dart';
import 'package:smart_sports/role_specific/coach/screens/referrals/coach_referrals_page.dart';
import 'package:smart_sports/role_specific/coach/screens/customer_support/coach_customer_support_page.dart';
import 'package:smart_sports/role_specific/coach/screens/settings/coach_settings_page.dart';
import 'package:smart_sports/role_specific/coach/screens/profile/coach_profile_page.dart';
import 'package:smart_sports/role_specific/coach/screens/sponsorships/coach_sponsorships_page.dart';

// Corporate imports
import 'package:smart_sports/role_specific/corporate/screens/dashboard/corporate_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/transactions/corporate_transactions_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/courts/corporate_courts_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/bookings/corporate_bookings_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/events/corporate_events_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/users/corporate_users_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/referrals/corporate_referrals_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/customer_support/corporate_customer_support_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/settings/corporate_settings_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/profile/corporate_profile_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/sponsorships/corporate_sponsorships_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/billing/corporate_billing_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/my_bookings/corporate_my_bookings_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/my_clubs/corporate_my_clubs_page.dart';

// Merchandiser imports
import 'package:smart_sports/role_specific/merchandiser/screens/dashboard/merchandiser_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/transactions/merchandiser_transactions_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/courts/merchandiser_courts_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/bookings/merchandiser_bookings_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/events/merchandiser_events_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/users/merchandiser_users_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/referrals/merchandiser_referrals_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/customer_support/merchandiser_customer_support_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/settings/merchandiser_settings_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/profile/merchandiser_profile_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/sponsorships/merchandiser_sponsorships_page.dart';

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
          MaterialPageRoute(builder: (_) => const ClubAnalyticsDashboardPage()),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ClubTransactionsPage()),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ClubCourtsPage()),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const _ClubPlaceholder(title: 'Clubs', currentIndex: 3),
          ),
        );
        break;
      case 4:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ClubBookingsPage()),
        );
        break;
      case 5:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ClubEventsPage()),
        );
        break;
      case 6:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ClubSponsorshipsPage()),
        );
        break;
      case 7:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ClubUsersPage()),
        );
        break;
      case 8:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ClubReferralsPage()),
        );
        break;
      case 9:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ClubCustomerSupportPage()),
        );
        break;
      case 10:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ClubSettingsPage()),
        );
        break;
    }
  }

  static void _navigateCoachScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const CoachAnalyticsDashboardPage(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachTransactionsPage()),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachCourtsPage()),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const _CoachPlaceholder(title: 'Clubs', currentIndex: 3),
          ),
        );
        break;
      case 4:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachBookingsPage()),
        );
        break;
      case 5:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachEventsPage()),
        );
        break;
      case 6:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachSponsorshipsPage()),
        );
        break;
      case 7:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachUsersPage()),
        );
        break;
      case 8:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachReferralsPage()),
        );
        break;
      case 9:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachCustomerSupportPage()),
        );
        break;
      case 10:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachSettingsPage()),
        );
        break;
    }
  }

  static void _navigateCorporateScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const CorporateAnalyticsDashboardPage(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateTransactionsPage()),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateCourtsPage()),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateMyClubsPage()),
        );
        break;
      case 4:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateBookingsPage()),
        );
        break;
      case 5:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateEventsPage()),
        );
        break;
      case 6:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateSponsorshipsPage()),
        );
        break;
      case 7:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateUsersPage()),
        );
        break;
      case 8:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateReferralsPage()),
        );
        break;
      case 9:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const CorporateCustomerSupportPage(),
          ),
        );
        break;
      case 10:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateSettingsPage()),
        );
        break;
      case 11:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateBillingPage()),
        );
        break;
      case 12:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateMyBookingsPage()),
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
          MaterialPageRoute(builder: (_) => const MerchandiserCourtsPage()),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const _MerchandiserPlaceholder(title: 'Clubs', currentIndex: 3),
          ),
        );
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
    // Member navigation logic can be added here when needed
  }

  static void _navigateFreelancerScreen(BuildContext context, int index) {
    // Freelancer navigation logic can be added here when needed
  }

  /// Navigate to profile page
  static void navigateToProfile(BuildContext context, UserRole role) {
    Navigator.of(context).pop(); // Close drawer first

    Future.delayed(const Duration(milliseconds: 100), () {
      switch (role) {
        case UserRole.club:
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const ClubProfilePage()));
          break;
        case UserRole.coach:
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const CoachProfilePage()));
          break;
        case UserRole.corporate:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CorporateProfilePage()),
          );
          break;
        case UserRole.merchandiser:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MerchandiserProfilePage()),
          );
          break;
        case UserRole.member:
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const _MemberProfilePage()));
          break;
        case UserRole.freelancer:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const _FreelancerProfilePage()),
          );
          break;
      }
    });
  }
}

// Placeholder widgets for each role
class _ClubPlaceholder extends StatelessWidget {
  final String title;
  final int currentIndex;
  const _ClubPlaceholder({required this.title, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.club,
            selectedIndex: currentIndex,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.club,
              i,
            ),
            onProfileTap: () =>
                RoleNavigationManager.navigateToProfile(context, UserRole.club),
          ),
        ),
      ),
      body: Center(child: Text('$title screen coming soon')),
    );
  }
}

class _CoachPlaceholder extends StatelessWidget {
  final String title;
  final int currentIndex;
  const _CoachPlaceholder({required this.title, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.coach,
            selectedIndex: currentIndex,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.coach,
              i,
            ),
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.coach,
            ),
          ),
        ),
      ),
      body: Center(child: Text('$title screen coming soon')),
    );
  }
}

class _MerchandiserPlaceholder extends StatelessWidget {
  final String title;
  final int currentIndex;
  const _MerchandiserPlaceholder({
    required this.title,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.merchandiser,
            selectedIndex: currentIndex,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.merchandiser,
              i,
            ),
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.merchandiser,
            ),
          ),
        ),
      ),
      body: Center(child: Text('$title screen coming soon')),
    );
  }
}

class _MemberProfilePage extends StatelessWidget {
  const _MemberProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Profile'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.member,
            selectedIndex: 10,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.member,
              i,
            ),
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.member,
            ),
          ),
        ),
      ),
      body: const Center(child: Text('Member Profile screen coming soon')),
    );
  }
}

class _FreelancerProfilePage extends StatelessWidget {
  const _FreelancerProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freelancer Profile'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.freelancer,
            selectedIndex: 10,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.freelancer,
              i,
            ),
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.freelancer,
            ),
          ),
        ),
      ),
      body: const Center(child: Text('Freelancer Profile screen coming soon')),
    );
  }
}
