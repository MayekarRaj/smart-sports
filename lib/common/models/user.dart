import 'package:flutter/material.dart';

enum UserRole { admin, employee, member, coach }

enum UserStatus { active, inactive, pending, suspended }

enum Department { design, management, development, marketing, sales }

class User {
  final String id;
  final String userName;
  final String companyName;
  final Department department;
  final String designation;
  final UserRole role;
  final String mobile;
  final String email;
  final UserStatus status;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.userName,
    required this.companyName,
    required this.department,
    required this.designation,
    required this.role,
    required this.mobile,
    required this.email,
    required this.status,
    this.avatarUrl,
  });
}

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.admin => 'Admin User',
    UserRole.employee => 'Employee',
    UserRole.member => 'Member',
    UserRole.coach => 'Coach',
  };

  Color get color => switch (this) {
    UserRole.admin => const Color(0xFF3B82F6),
    UserRole.employee => const Color(0xFF10B981),
    UserRole.member => const Color(0xFF8B5CF6),
    UserRole.coach => const Color(0xFFF59E0B),
  };
}

extension UserStatusX on UserStatus {
  String get label => switch (this) {
    UserStatus.active => 'Active',
    UserStatus.inactive => 'Inactive',
    UserStatus.pending => 'Pending',
    UserStatus.suspended => 'Suspended',
  };

  Color get color => switch (this) {
    UserStatus.active => const Color(0xFF10B981),
    UserStatus.inactive => const Color(0xFF6B7280),
    UserStatus.pending => const Color(0xFFF59E0B),
    UserStatus.suspended => const Color(0xFFEF4444),
  };
}

extension DepartmentX on Department {
  String get label => switch (this) {
    Department.design => 'Design',
    Department.management => 'Management',
    Department.development => 'Development',
    Department.marketing => 'Marketing',
    Department.sales => 'Sales',
  };
}
