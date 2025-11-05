import 'package:flutter/material.dart';

class ViewUserScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ViewUserScreen({super.key, required this.userData});

  @override
  State<ViewUserScreen> createState() => _ViewUserScreenState();
}

class _ViewUserScreenState extends State<ViewUserScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    print(
      'Club ViewUserScreen: initState called with userData: ${widget.userData}',
    );
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Club ViewUserScreen: build called');
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'VIEW USER',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _handleEditUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E40AF),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(color: Colors.white),
              ),
            ),
            child: const Text(
              'Edit',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Admin User'),
            Tab(text: 'Employees'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildAdminUserView(), _buildEmployeesView()],
      ),
    );
  }

  Widget _buildAdminUserView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture Section
          _buildProfilePictureSection(),
          const SizedBox(height: 24),

          // Personal Details Section
          _buildPersonalDetailsSection(),
          const SizedBox(height: 24),

          // Company Details Section
          _buildCompanyDetailsSection(),
        ],
      ),
    );
  }

  Widget _buildEmployeesView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Employee Button
          _buildAddEmployeeButton(),
          const SizedBox(height: 16),

          // Employees List
          _buildEmployeesList(),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - center the profile picture
          return Center(child: Column(children: [_buildProfilePicture()]));
        } else {
          // Tablet layout - align to right
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_buildProfilePicture()],
          );
        }
      },
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!, width: 2),
        image: const DecorationImage(
          image: AssetImage('assets/images/profile_placeholder.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.3),
        ),
        child: const Icon(Icons.person, size: 60, color: Colors.white),
      ),
    );
  }

  Widget _buildPersonalDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Personal Details'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Name fields
                _buildNameFields(),
                const SizedBox(height: 16),

                // Role field
                _buildReadOnlyField(
                  'Role',
                  widget.userData['role'] ?? 'Artist',
                ),
                const SizedBox(height: 16),

                // Email field
                _buildReadOnlyField(
                  'Login Email',
                  widget.userData['email'] ?? 'artist@ymail.com',
                ),
                const SizedBox(height: 16),

                // Password field with Change Password button
                _buildPasswordField(),
                const SizedBox(height: 16),

                // Address fields
                _buildAddressFields(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Company Details'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Company name
                _buildReadOnlyField(
                  'Company Name',
                  widget.userData['companyName'] ?? 'Company Name',
                ),
                const SizedBox(height: 16),

                // Designation and Department
                _buildDesignationDepartmentFields(),
                const SizedBox(height: 16),

                // Phone fields
                _buildPhoneFields(),
                const SizedBox(height: 16),

                // Website field
                _buildReadOnlyField(
                  'Website',
                  widget.userData['website'] ?? 'www.xyzcompany.com',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E40AF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNameFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - stack vertically
          return Column(
            children: [
              _buildReadOnlyField(
                'First Name',
                widget.userData['firstName'] ?? '',
              ),
              const SizedBox(height: 12),
              _buildReadOnlyField(
                'Last Name',
                widget.userData['lastName'] ?? '',
              ),
            ],
          );
        } else {
          // Tablet layout - side by side
          return Row(
            children: [
              Expanded(
                child: _buildReadOnlyField(
                  'First Name',
                  widget.userData['firstName'] ?? '',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReadOnlyField(
                  'Last Name',
                  widget.userData['lastName'] ?? '',
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: const Text(
                  '**********',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'CHANGE PASSWORD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address* (Permanent)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        _buildReadOnlyField(
          'Address Line 1',
          widget.userData['addressLine1'] ?? '',
        ),
        const SizedBox(height: 12),
        _buildReadOnlyField(
          'Address Line 2',
          widget.userData['addressLine2'] ?? '',
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile layout - stack all fields vertically
              return Column(
                children: [
                  _buildReadOnlyField(
                    'City',
                    widget.userData['city'] ?? 'Nagpur',
                  ),
                  const SizedBox(height: 12),
                  _buildDropdownField(
                    'State',
                    widget.userData['state'] ?? 'MAHARASHTRA',
                  ),
                  const SizedBox(height: 12),
                  _buildReadOnlyField(
                    'Postal Code',
                    widget.userData['postalCode'] ?? '440022',
                  ),
                  const SizedBox(height: 12),
                  _buildDropdownField(
                    'Country',
                    widget.userData['country'] ?? 'INDIA',
                  ),
                ],
              );
            } else {
              // Tablet layout - 2x2 grid
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildReadOnlyField(
                          'City',
                          widget.userData['city'] ?? 'Nagpur',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField(
                          'State',
                          widget.userData['state'] ?? 'MAHARASHTRA',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildReadOnlyField(
                          'Postal Code',
                          widget.userData['postalCode'] ?? '440022',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField(
                          'Country',
                          widget.userData['country'] ?? 'INDIA',
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildDesignationDepartmentFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - stack vertically
          return Column(
            children: [
              _buildReadOnlyField(
                'Designation',
                widget.userData['designation'] ?? 'Director',
              ),
              const SizedBox(height: 12),
              _buildReadOnlyField(
                'Department',
                widget.userData['department'] ?? 'Administration',
              ),
            ],
          );
        } else {
          // Tablet layout - side by side
          return Row(
            children: [
              Expanded(
                child: _buildReadOnlyField(
                  'Designation',
                  widget.userData['designation'] ?? 'Director',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReadOnlyField(
                  'Department',
                  widget.userData['department'] ?? 'Administration',
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildPhoneFields() {
    return Column(
      children: [
        _buildPhoneField(
          'Telephone*',
          widget.userData['telephoneCountry'] ?? 'INDIA (+91)',
          widget.userData['telephone'] ?? '12-3456-7890',
        ),
        const SizedBox(height: 12),
        _buildPhoneField(
          'Fax',
          widget.userData['faxCountry'] ?? 'INDIA (+91)',
          widget.userData['fax'] ?? '12-3456-7890',
        ),
        const SizedBox(height: 12),
        _buildPhoneField(
          'Mobile Number*',
          widget.userData['mobileCountry'] ?? 'INDIA (+91)',
          widget.userData['mobile'] ?? '12-3456-7890',
        ),
      ],
    );
  }

  Widget _buildPhoneField(String label, String countryCode, String number) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 400) {
              // Mobile layout - stack vertically
              return Column(
                children: [
                  _buildDropdownField('', countryCode),
                  const SizedBox(height: 8),
                  _buildReadOnlyField('', number),
                ],
              );
            } else {
              // Tablet layout - side by side
              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDropdownField('', countryCode),
                  ),
                  const SizedBox(width: 8),
                  Expanded(flex: 3, child: _buildReadOnlyField('', number)),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddEmployeeButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1E40AF),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextButton.icon(
        onPressed: _handleAddEmployee,
        icon: const Icon(Icons.person_add, color: Colors.white, size: 20),
        label: const Text(
          'Add Employee',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeesList() {
    // Sample employee data
    final employees = [
      {
        'name': 'Alex Thompson',
        'role': 'Coach',
        'department': 'Training',
        'email': 'alex.thompson@club.com',
        'phone': '+1 234-567-8900',
        'status': 'Active',
        'avatar': 'A',
      },
      {
        'name': 'Maria Garcia',
        'role': 'Manager',
        'department': 'Operations',
        'email': 'maria.garcia@club.com',
        'phone': '+1 234-567-8901',
        'status': 'Active',
        'avatar': 'M',
      },
      {
        'name': 'David Lee',
        'role': 'Trainer',
        'department': 'Fitness',
        'email': 'david.lee@club.com',
        'phone': '+1 234-567-8902',
        'status': 'Inactive',
        'avatar': 'D',
      },
      {
        'name': 'Lisa Chen',
        'role': 'Coordinator',
        'department': 'Events',
        'email': 'lisa.chen@club.com',
        'phone': '+1 234-567-8903',
        'status': 'Active',
        'avatar': 'L',
      },
    ];

    return Column(
      children: employees
          .map((employee) => _buildEmployeeCard(employee))
          .toList(),
    );
  }

  Widget _buildEmployeeCard(Map<String, String> employee) {
    final isActive = employee['status'] == 'Active';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF1E40AF) : Colors.grey[400],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  employee['avatar']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Employee Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee['name']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${employee['role']} • ${employee['department']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employee['email']!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green[100] : Colors.red[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          employee['status']!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isActive
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Buttons
            Column(
              children: [
                IconButton(
                  onPressed: () => _handleViewEmployee(employee),
                  icon: const Icon(
                    Icons.visibility,
                    color: Colors.blue,
                    size: 20,
                  ),
                  tooltip: 'View Details',
                ),
                IconButton(
                  onPressed: () => _handleEditEmployee(employee),
                  icon: const Icon(Icons.edit, color: Colors.orange, size: 20),
                  tooltip: 'Edit Employee',
                ),
                IconButton(
                  onPressed: () => _handleDeleteEmployee(employee),
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  tooltip: 'Delete Employee',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddEmployee() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Add Employee functionality will be implemented here',
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleViewEmployee(Map<String, String> employee) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${employee['name']} details'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleEditEmployee(Map<String, String> employee) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${employee['name']}'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleDeleteEmployee(Map<String, String> employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete Employee',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Text('Are you sure you want to delete ${employee['name']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${employee['name']} deleted successfully'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _handleEditUser() {
    // Navigate back to Add User screen with current data for editing
    Navigator.of(context).pop();
    // You can navigate to edit screen here if needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Edit functionality will be implemented here'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
