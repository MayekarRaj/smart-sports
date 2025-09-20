import 'package:flutter/material.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/widgets/role_sidebar_theme.dart';

class RoleSidebar extends StatelessWidget {
  final UserRole role;
  final ValueChanged<int>? onSelectIndex;
  final int selectedIndex;
  final bool edgeToEdge;
  final VoidCallback? onClose;
  final VoidCallback? onProfileTap;

  const RoleSidebar({
    super.key,
    required this.role,
    this.onSelectIndex,
    this.selectedIndex = 0,
    this.edgeToEdge = false,
    this.onClose,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = RoleSidebarThemes.of(role);

    return SizedBox(
      width: edgeToEdge ? double.infinity : 300,
      height: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: t.background,
          borderRadius: edgeToEdge ? BorderRadius.zero : BorderRadius.circular(24),
        ),
        padding: edgeToEdge ? const EdgeInsets.symmetric(horizontal: 16, vertical: 16) : const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: edgeToEdge ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
          children: [
            // Header Profile
            _ProfileHeader(textColor: t.textColor, onClose: onClose, onProfileTap: onProfileTap),
            const SizedBox(height: 16),

            // Search
            _SearchBox(textColor: t.textColor, iconColor: t.iconColor),
            const SizedBox(height: 16),

            // Menu
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: t.tileBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView(
                  children: [
                    _tile(
                      index: 0,
                      icon: Icons.dashboard_outlined,
                      label: 'Dashboard',
                      t: t,
                    ),
                    _tile(
                      index: 1,
                      icon: Icons.swap_horiz,
                      label: 'Transactions',
                      t: t,
                    ),
                    _tile(
                      index: 2,
                      icon: Icons.sports_tennis_outlined,
                      label: 'Courts',
                      t: t,
                    ),
                    _tile(
                      index: 3,
                      icon: Icons.apartment_outlined,
                      label: 'Clubs',
                      t: t,
                    ),
                    _tile(
                      index: 4,
                      icon: Icons.calendar_month_outlined,
                      label: 'Bookings',
                      t: t,
                    ),
                    _tile(
                      index: 5,
                      icon: Icons.emoji_events_outlined,
                      label: 'Events / Tournaments',
                      t: t,
                    ),
                    _tile(
                      index: 6,
                      icon: Icons.handshake_outlined,
                      label: 'Sponsorships',
                      t: t,
                    ),
                    _tile(
                      index: 7,
                      icon: Icons.group_outlined,
                      label: 'Users',
                      t: t,
                    ),
                    _tile(
                      index: 8,
                      icon: Icons.share_outlined,
                      label: 'Referrals',
                      t: t,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sign out
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: t.iconColor),
                    const SizedBox(width: 12),
                    Text(
                      'Sign Out',
                      style: TextStyle(color: t.textColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required int index,
    required IconData icon,
    required String label,
    required SidebarThemeData t,
  }) {
    final bool isSelected = index == selectedIndex;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (onSelectIndex != null) onSelectIndex!(index);
          if (onClose != null) onClose!();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: t.iconColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: t.textColor,
                    fontSize: 13.5,
                    letterSpacing: 0.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Color textColor;
  final VoidCallback? onClose;
  final VoidCallback? onProfileTap;
  const _ProfileHeader({required this.textColor, this.onClose, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.white24,
        highlightColor: Colors.white12,
        onTap: () {
          if (onProfileTap != null) onProfileTap!();
          if (onClose != null) onClose!();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withOpacity(0.15),
                child: Icon(Icons.person, color: textColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Name',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Designation', style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 12)),
                    Text('Role', style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 12)),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.chevron_right, color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final Color textColor;
  final Color iconColor;
  const _SearchBox({required this.textColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.search, color: iconColor),
        ],
      ),
    );
  }
}
