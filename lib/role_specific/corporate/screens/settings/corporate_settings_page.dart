import 'package:flutter/material.dart';
import 'package:smart_sports/auth/screens/auth_shell.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/coach/screens/profile/coach_profile_page.dart';
import 'package:smart_sports/role_specific/coach/screens/customer_support/coach_customer_support_page.dart';

class CorporateSettingsPage extends StatefulWidget {
  const CorporateSettingsPage({super.key});

  @override
  State<CorporateSettingsPage> createState() => _CorporateSettingsPageState();
}

class _CorporateSettingsPageState extends State<CorporateSettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkMode = false;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'System';

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
  ];
  final List<String> _themes = ['System', 'Light', 'Dark'];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.corporate,
            selectedIndex: 10, // Settings is index 10
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
            onSignOut: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthShell()),
                (route) => false,
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF232534), Color(0xFF414384)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: isMobile,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            _buildSectionCard(
              title: 'Account Settings',
              icon: Icons.person_outline,
              isMobile: isMobile,
              children: [
                _buildSettingsTile(
                  icon: Icons.person,
                  title: 'Profile Information',
                  subtitle: 'Manage your personal details',
                  isMobile: isMobile,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CoachProfilePage(),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.security,
                  title: 'Security',
                  subtitle: 'Password, 2FA, and security settings',
                  isMobile: isMobile,
                  onTap: () {
                    _showComingSoonDialog('Security Settings');
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy',
                  subtitle: 'Control your privacy settings',
                  isMobile: isMobile,
                  onTap: () {
                    _showComingSoonDialog('Privacy Settings');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Notifications
            _buildSectionCard(
              title: 'Notifications',
              icon: Icons.notifications_outlined,
              isMobile: isMobile,
              children: [
                _buildSwitchTile(
                  icon: Icons.notifications,
                  title: 'Push Notifications',
                  subtitle: 'Receive notifications on your device',
                  value: _pushNotifications,
                  isMobile: isMobile,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.email,
                  title: 'Email Notifications',
                  subtitle: 'Receive notifications via email',
                  value: _emailNotifications,
                  isMobile: isMobile,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.notifications_active,
                  title: 'All Notifications',
                  subtitle: 'Enable or disable all notifications',
                  value: _notificationsEnabled,
                  isMobile: isMobile,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                      if (!value) {
                        _pushNotifications = false;
                        _emailNotifications = false;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Appearance
            _buildSectionCard(
              title: 'Appearance',
              icon: Icons.palette_outlined,
              isMobile: isMobile,
              children: [
                _buildDropdownTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'Choose your preferred language',
                  value: _selectedLanguage,
                  items: _languages,
                  isMobile: isMobile,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                  },
                ),
                _buildDropdownTile(
                  icon: Icons.brightness_6,
                  title: 'Theme',
                  subtitle: 'Choose your preferred theme',
                  value: _selectedTheme,
                  items: _themes,
                  isMobile: isMobile,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value!;
                    });
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: 'Switch between light and dark themes',
                  value: _darkMode,
                  isMobile: isMobile,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // App Settings
            _buildSectionCard(
              title: 'App Settings',
              icon: Icons.settings_outlined,
              isMobile: isMobile,
              children: [
                _buildSettingsTile(
                  icon: Icons.storage,
                  title: 'Storage',
                  subtitle: 'Manage app storage and cache',
                  isMobile: isMobile,
                  onTap: () {
                    _showComingSoonDialog('Storage Settings');
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.update,
                  title: 'Updates',
                  subtitle: 'Check for app updates',
                  isMobile: isMobile,
                  onTap: () {
                    _showComingSoonDialog('App Updates');
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help and contact support',
                  isMobile: isMobile,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CoachCustomerSupportPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // About
            _buildSectionCard(
              title: 'About',
              icon: Icons.info_outline,
              isMobile: isMobile,
              children: [
                _buildSettingsTile(
                  icon: Icons.info,
                  title: 'About App',
                  subtitle: 'Version 1.0.0',
                  isMobile: isMobile,
                  onTap: () {
                    _showAboutDialog();
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.description,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                  isMobile: isMobile,
                  onTap: () {
                    _showComingSoonDialog('Terms of Service');
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.shield,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  isMobile: isMobile,
                  onTap: () {
                    _showComingSoonDialog('Privacy Policy');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sign Out Button
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  _showSignOutDialog();
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    bool isMobile = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF232534),
                  size: 20,
                ), // Coach gradient start
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 10 : 12,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(
                  0xFF232534,
                ).withValues(alpha: 0.1), // Coach gradient start
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF1E40AF), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 13,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isMobile = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 10 : 12,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1E40AF), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 13,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF232534), // Coach gradient start
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isMobile = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 10 : 12,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1E40AF), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 13,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            underline: const SizedBox(),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: const Text('This feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Smart Sports',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.sports,
        size: 48,
        color: Color(0xFF232534), // Coach gradient start
      ),
      children: [const Text('A comprehensive sports management platform.')],
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthShell()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
