import 'package:flutter/material.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';

class SidebarThemeData {
  final Gradient background;
  final Color tileBackground;
  final Color iconColor;
  final Color textColor;
  final Color dividerColor;

  const SidebarThemeData({
    required this.background,
    required this.tileBackground,
    required this.iconColor,
    required this.textColor,
    required this.dividerColor,
  });
}

class RoleSidebarThemes {
  static SidebarThemeData of(UserRole role) {
    switch (role) {
      case UserRole.club:
        return const SidebarThemeData(
          background: LinearGradient(
            colors: [Color(0xFF232526), Color(0xFF414345)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          tileBackground: Color(0xFF18171E),
          iconColor: Colors.white,
          textColor: Colors.white,
          dividerColor: Color(0x33FFFFFF),
        );
      case UserRole.coach:
        return const SidebarThemeData(
          background: LinearGradient(
            colors: [Color(0xFF232534), Color(0xFF2C3BC5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
          ),
          tileBackground: Color(0xFF1A1B2E),
          iconColor: Colors.white,
          textColor: Colors.white,
          dividerColor: Color(0x33FFFFFF),
        );
      case UserRole.corporate:
        return const SidebarThemeData(
          background: LinearGradient(
            colors: [Color(0xFF232534), Color(0xFF414384)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          tileBackground: Color(0xFF1E1F3A),
          iconColor: Colors.white,
          textColor: Colors.white,
          dividerColor: Color(0x33FFFFFF),
        );
      case UserRole.member:
        return const SidebarThemeData(
          background: LinearGradient(
            colors: [Color(0xFF283048), Color(0xFF859398)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          tileBackground: Color(0xFF1D2230),
          iconColor: Colors.white,
          textColor: Colors.white,
          dividerColor: Color(0x33FFFFFF),
        );
      case UserRole.freelancer:
        return const SidebarThemeData(
          background: LinearGradient(
            colors: [Color(0xFF373B44), Color(0xFF4286f4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          tileBackground: Color(0xFF1B2030),
          iconColor: Colors.white,
          textColor: Colors.white,
          dividerColor: Color(0x33FFFFFF),
        );
      case UserRole.merchandiser:
        return const SidebarThemeData(
          background: LinearGradient(
            colors: [Color(0xFF009A69), Color(0xFF232534)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          tileBackground: Color(0xFF232534),
          iconColor: Colors.white,
          textColor: Colors.white,
          dividerColor: Color(0x33FFFFFF),
        );
    }
  }
}
