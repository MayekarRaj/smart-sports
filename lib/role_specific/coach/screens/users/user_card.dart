import 'package:flutter/material.dart';
import 'package:smart_sports/common/models/user.dart';
import 'package:smart_sports/role_specific/coach/screens/users/view_user_screen.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onView;

  const UserCard({super.key, required this.user, this.onTap, this.onView});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar and basic info
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: user.role.color,
                    child: Text(
                      user.userName.isNotEmpty
                          ? user.userName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.userName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.companyName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: user.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: user.status.color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      user.status.label,
                      style: TextStyle(
                        color: user.status.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // User details - Mobile responsive layout
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    // Mobile layout - stacked
                    return Column(
                      children: [
                        _buildDetailRow(
                          icon: Icons.business,
                          label: 'Department',
                          value: user.department.label,
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          icon: Icons.work,
                          label: 'Designation',
                          value: user.designation,
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          icon: Icons.badge,
                          label: 'Role',
                          value: user.role.label,
                          valueColor: user.role.color,
                        ),
                        const SizedBox(height: 12),
                        // Contact info - stacked on mobile
                        _buildContactInfo(
                          icon: Icons.phone,
                          value: user.mobile,
                        ),
                        const SizedBox(height: 8),
                        _buildContactInfo(icon: Icons.email, value: user.email),
                      ],
                    );
                  } else {
                    // Desktop layout - horizontal
                    return Column(
                      children: [
                        _buildDetailRow(
                          icon: Icons.business,
                          label: 'Department',
                          value: user.department.label,
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          icon: Icons.work,
                          label: 'Designation',
                          value: user.designation,
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          icon: Icons.badge,
                          label: 'Role',
                          value: user.role.label,
                          valueColor: user.role.color,
                        ),
                        const SizedBox(height: 12),
                        // Contact info - horizontal on desktop
                        Row(
                          children: [
                            Expanded(
                              child: _buildContactInfo(
                                icon: Icons.phone,
                                value: user.mobile,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildContactInfo(
                                icon: Icons.email,
                                value: user.email,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Action buttons - Mobile responsive
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    // Mobile layout - full width buttons
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              print('Mobile View button pressed');
                              _handleViewUser(context);
                            },
                            icon: const Icon(Icons.visibility, size: 18),
                            label: const Text('View Details'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2C3BC5),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: onTap,
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Edit User'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2C3BC5),
                              side: const BorderSide(color: Color(0xFF2C3BC5)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Desktop layout - horizontal buttons
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              print('Desktop View button pressed');
                              _handleViewUser(context);
                            },
                            icon: const Icon(Icons.visibility, size: 18),
                            label: const Text('View Details'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2C3BC5),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onTap,
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Edit User'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2C3BC5),
                              side: const BorderSide(color: Color(0xFF2C3BC5)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleViewUser(BuildContext context) {
    print('View button clicked for user: ${user.userName}');

    // Convert User model to Map for ViewUserScreen
    final userData = {
      'firstName': user.userName.split(' ').first,
      'lastName': user.userName.split(' ').length > 1
          ? user.userName.split(' ').last
          : '',
      'role': user.role.label,
      'email': user.email,
      'password': '**********',
      'profilePicture': null,
      'addressLine1': '',
      'addressLine2': '',
      'city': '',
      'state': '',
      'zipCode': '',
      'country': '',
      'companyName': user.companyName,
      'designation': user.designation,
      'department': user.department.label,
      'telephone': user.mobile,
      'fax': '',
      'mobile': user.mobile,
      'website': '',
    };

    print('Navigating to ViewUserScreen with data: $userData');

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => ViewUserScreen(userData: userData),
          ),
        )
        .then((_) {
          print('ViewUserScreen closed');
        })
        .catchError((error) {
          print('Error navigating to ViewUserScreen: $error');
        });
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? const Color(0xFF1F2937),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo({required IconData icon, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6B7280)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
