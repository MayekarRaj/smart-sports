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
    print('ViewUserScreen initState called with userData: ${widget.userData}');
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('ViewUserScreen build method called');
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF232534), Color(0xFF2C3BC5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
              backgroundColor: const Color(0xFF232534),
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
            Tab(text: 'Internal User'),
            Tab(text: 'Privilege User'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildInternalUserView(), _buildPrivilegeUserView()],
      ),
    );
  }

  Widget _buildInternalUserView() {
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

  Widget _buildPrivilegeUserView() {
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
        color: Colors.grey[200],
      ),
      child: const Icon(Icons.person, size: 60, color: Colors.grey),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF232534),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF232534),
              ),
            ),
          ),
          const Expanded(
            child: Divider(color: Colors.white30, thickness: 1, indent: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNameFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - stacked
          return Column(
            children: [
              _buildReadOnlyField(
                'First Name',
                widget.userData['firstName'] ?? 'John',
              ),
              const SizedBox(height: 16),
              _buildReadOnlyField(
                'Last Name',
                widget.userData['lastName'] ?? 'Doe',
              ),
            ],
          );
        } else {
          // Desktop layout - horizontal
          return Row(
            children: [
              Expanded(
                child: _buildReadOnlyField(
                  'First Name',
                  widget.userData['firstName'] ?? 'John',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildReadOnlyField(
                  'Last Name',
                  widget.userData['lastName'] ?? 'Doe',
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
        Text(
          'Password',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
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
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  '**********',
                  style: const TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _handleChangePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: Text(
                'CHANGE PASSWORD',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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
        Text(
          'Address (Permanent)',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        _buildReadOnlyField(
          'Address Line 1',
          widget.userData['addressLine1'] ?? '123 Main Street',
        ),
        const SizedBox(height: 16),
        _buildReadOnlyField(
          'Address Line 2',
          widget.userData['addressLine2'] ?? 'Apt 4B',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile layout - stacked
              return Column(
                children: [
                  _buildReadOnlyField(
                    'City',
                    widget.userData['city'] ?? 'Nagpur',
                  ),
                  const SizedBox(height: 16),
                  _buildReadOnlyField(
                    'State',
                    widget.userData['state'] ?? 'MAHARASHTRA',
                    hasDropdown: true,
                  ),
                  const SizedBox(height: 16),
                  _buildReadOnlyField(
                    'Zip Code',
                    widget.userData['zipCode'] ?? '440022',
                  ),
                  const SizedBox(height: 16),
                  _buildReadOnlyField(
                    'Country',
                    widget.userData['country'] ?? 'INDIA',
                    hasDropdown: true,
                  ),
                ],
              );
            } else {
              // Desktop layout - horizontal
              return Row(
                children: [
                  Expanded(
                    child: _buildReadOnlyField(
                      'City',
                      widget.userData['city'] ?? 'Nagpur',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildReadOnlyField(
                      'State',
                      widget.userData['state'] ?? 'MAHARASHTRA',
                      hasDropdown: true,
                    ),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile layout - stacked
              return Column(
                children: [
                  _buildReadOnlyField(
                    'Zip Code',
                    widget.userData['zipCode'] ?? '440022',
                  ),
                  const SizedBox(height: 16),
                  _buildReadOnlyField(
                    'Country',
                    widget.userData['country'] ?? 'INDIA',
                    hasDropdown: true,
                  ),
                ],
              );
            } else {
              // Desktop layout - horizontal
              return Row(
                children: [
                  Expanded(
                    child: _buildReadOnlyField(
                      'Zip Code',
                      widget.userData['zipCode'] ?? '440022',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildReadOnlyField(
                      'Country',
                      widget.userData['country'] ?? 'INDIA',
                      hasDropdown: true,
                    ),
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
          // Mobile layout - stacked
          return Column(
            children: [
              _buildReadOnlyField(
                'Designation',
                widget.userData['designation'] ?? 'Director',
              ),
              const SizedBox(height: 16),
              _buildReadOnlyField(
                'Department',
                widget.userData['department'] ?? 'Administration',
              ),
            ],
          );
        } else {
          // Desktop layout - horizontal
          return Row(
            children: [
              Expanded(
                child: _buildReadOnlyField(
                  'Designation',
                  widget.userData['designation'] ?? 'Director',
                ),
              ),
              const SizedBox(width: 16),
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
          'Telephone',
          widget.userData['telephone'] ?? '12-3456-7890',
        ),
        const SizedBox(height: 16),
        _buildPhoneField('Fax', widget.userData['fax'] ?? '12-3456-7890'),
        const SizedBox(height: 16),
        _buildPhoneField(
          'Mobile Number',
          widget.userData['mobile'] ?? '12-3456-7890',
        ),
      ],
    );
  }

  Widget _buildPhoneField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'INDIA (+91)',
                    style: const TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 16),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(
    String label,
    String value, {
    bool hasDropdown = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
              if (hasDropdown) const Icon(Icons.keyboard_arrow_down, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddEmployeeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _handleAddEmployee,
        icon: const Icon(Icons.person_add),
        label: const Text('Add Employee'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF232534),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildEmployeesList() {
    return Column(
      children: List.generate(5, (index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF232534),
              child: Text(
                'E${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text('Employee ${index + 1}'),
            subtitle: Text('employee${index + 1}@company.com'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Viewing Employee ${index + 1}'),
                  backgroundColor: const Color(0xFF232534),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _handleEditUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit user functionality'),
        backgroundColor: Color(0xFF232534),
      ),
    );
  }

  void _handleChangePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Change password functionality'),
        backgroundColor: Color(0xFF8B5CF6),
      ),
    );
  }

  void _handleAddEmployee() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add employee functionality'),
        backgroundColor: Color(0xFF232534),
      ),
    );
  }
}
