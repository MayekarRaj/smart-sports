import 'package:flutter/material.dart';
import 'package:smart_sports/common/models/user.dart';
import 'package:smart_sports/role_specific/club/screens/users/user_data_service.dart';
import 'package:smart_sports/role_specific/club/screens/users/view_user_screen.dart';

/// Simplified version of the users page for testing
class SimpleUsersPage extends StatefulWidget {
  const SimpleUsersPage({super.key});

  @override
  State<SimpleUsersPage> createState() => _SimpleUsersPageState();
}

class _SimpleUsersPageState extends State<SimpleUsersPage> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _users = UserDataService.getMockUsers();
    });
  }

  void _handleViewUser(User user) {
    final userData = _convertUserToViewData(user);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewUserScreen(userData: userData),
      ),
    );
  }

  Map<String, dynamic> _convertUserToViewData(User user) {
    return {
      'firstName': user.userName.split(' ').isNotEmpty
          ? user.userName.split(' ')[0]
          : '',
      'lastName': user.userName.split(' ').length > 1
          ? user.userName.split(' ').sublist(1).join(' ')
          : '',
      'role': user.role.label,
      'email': user.email,
      'addressLine1': '',
      'addressLine2': '',
      'city': '',
      'state': '',
      'postalCode': '',
      'country': '',
      'companyName': user.companyName,
      'designation': user.designation,
      'department': user.department.label,
      'telephoneCountry': 'INDIA (+91)',
      'telephone': '',
      'faxCountry': 'INDIA (+91)',
      'fax': '',
      'mobileCountry': 'INDIA (+91)',
      'mobile': user.mobile,
      'website': '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Users Test'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _users.isEmpty
          ? const Center(child: Text('Loading users...'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: user.role.color,
                      child: Text(
                        user.userName[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(user.userName),
                    subtitle: Text(
                      '${user.companyName} - ${user.department.label}',
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: user.status.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
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
                    onTap: () => _handleViewUser(user),
                  ),
                );
              },
            ),
    );
  }
}
