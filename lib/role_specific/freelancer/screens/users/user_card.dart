import 'package:flutter/material.dart';
import 'package:smart_sports/common/models/user.dart';
import 'package:smart_sports/role_specific/freelancer/screens/users/view_user_screen.dart';

class FreelancerUserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onView;

  const FreelancerUserCard({super.key, required this.user, this.onTap, this.onView});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with avatar and basic info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF007BFF), // Freelancer blue
                      child: Text(
                        user.userName.isNotEmpty
                            ? user.userName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF232534),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Contact information - responsive layout
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (isWide) {
                      // Wide layout: 2 columns
                      return Row(
                        children: [
                          Expanded(
                            child: _buildContactInfo(
                              icon: Icons.phone,
                              label: 'Phone',
                              value: user.mobile,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildContactInfo(
                              icon: Icons.business,
                              label: 'Company',
                              value: user.companyName,
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Narrow layout: stacked
                      return Column(
                        children: [
                          _buildContactInfo(
                            icon: Icons.phone,
                            label: 'Phone',
                            value: user.mobile,
                          ),
                          const SizedBox(height: 8),
                          _buildContactInfo(
                            icon: Icons.business,
                            label: 'Company',
                            value: user.companyName,
                          ),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Action buttons - responsive layout
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (isWide) {
                      // Wide layout: horizontal buttons
                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _handleViewUser(context),
                              icon: const Icon(Icons.visibility, size: 18),
                              label: const Text('View Details'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007BFF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
                                foregroundColor: const Color(0xFF007BFF),
                                side: const BorderSide(
                                  color: Color(0xFF007BFF),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Narrow layout: stacked buttons
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _handleViewUser(context),
                              icon: const Icon(Icons.visibility, size: 18),
                              label: const Text('View Details'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007BFF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
                                foregroundColor: const Color(0xFF007BFF),
                                side: const BorderSide(
                                  color: Color(0xFF007BFF),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF007BFF),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF232534),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleViewUser(BuildContext context) {
    // Prepare user data for the view screen
    final userData = {
      'userName': user.userName,
      'email': user.email,
      'mobile': user.mobile,
      'companyName': user.companyName,
      'department': user.department.label,
      'status': user.status.label,
      'role': user.role.label,
      'designation': user.designation,
    };

    // Navigate to the view user screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FreelancerViewUserScreen(userData: userData),
      ),
    );
  }
}

