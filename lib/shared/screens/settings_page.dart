import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String title;
  final List<SettingsSection> sections;
  final VoidCallback? onSignOut;

  const SettingsPage({
    super.key,
    this.title = 'Settings',
    required this.sections,
    this.onSignOut,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), elevation: 0),
      body: ListView(
        children: widget.sections
            .map((section) => _buildSection(section))
            .toList(),
      ),
    );
  }

  Widget _buildSection(SettingsSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              section.title!,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        ...section.items.map((item) => _buildSettingsItem(item)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSettingsItem(SettingsItem item) {
    return ListTile(
      leading: item.icon != null
          ? Icon(item.icon, color: item.iconColor)
          : null,
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      trailing:
          item.trailing ??
          (item.onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: item.onTap,
      enabled: item.enabled,
    );
  }
}

class SettingsSection {
  final String? title;
  final List<SettingsItem> items;

  const SettingsSection({this.title, required this.items});
}

class SettingsItem {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  const SettingsItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });
}

// Predefined settings items for common functionality
class CommonSettingsItems {
  static SettingsItem profile({required VoidCallback onTap, String? subtitle}) {
    return SettingsItem(
      title: 'Profile',
      subtitle: subtitle,
      icon: Icons.person_outline,
      onTap: onTap,
    );
  }

  static SettingsItem notifications({
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return SettingsItem(
      title: 'Notifications',
      subtitle: 'Manage your notification preferences',
      icon: Icons.notifications_outlined,
      onTap: onTap,
      enabled: enabled,
    );
  }

  static SettingsItem privacy({required VoidCallback onTap}) {
    return SettingsItem(
      title: 'Privacy & Security',
      subtitle: 'Manage your privacy settings',
      icon: Icons.security_outlined,
      onTap: onTap,
    );
  }

  static SettingsItem help({required VoidCallback onTap}) {
    return SettingsItem(
      title: 'Help & Support',
      subtitle: 'Get help and contact support',
      icon: Icons.help_outline,
      onTap: onTap,
    );
  }

  static SettingsItem about({required VoidCallback onTap, String? version}) {
    return SettingsItem(
      title: 'About',
      subtitle: version != null ? 'Version $version' : null,
      icon: Icons.info_outline,
      onTap: onTap,
    );
  }

  static SettingsItem signOut({required VoidCallback onTap}) {
    return SettingsItem(
      title: 'Sign Out',
      icon: Icons.logout,
      iconColor: Colors.red,
      onTap: onTap,
    );
  }

  static SettingsItem theme({
    required VoidCallback onTap,
    String? currentTheme,
  }) {
    return SettingsItem(
      title: 'Theme',
      subtitle: currentTheme ?? 'System',
      icon: Icons.palette_outlined,
      onTap: onTap,
    );
  }

  static SettingsItem language({
    required VoidCallback onTap,
    String? currentLanguage,
  }) {
    return SettingsItem(
      title: 'Language',
      subtitle: currentLanguage ?? 'English',
      icon: Icons.language_outlined,
      onTap: onTap,
    );
  }
}
