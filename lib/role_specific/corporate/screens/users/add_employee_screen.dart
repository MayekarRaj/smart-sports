import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _profileTabController;

  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _roleController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _designationController = TextEditingController();
  final _departmentController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _faxController = TextEditingController();
  final _mobileController = TextEditingController();
  final _websiteController = TextEditingController();

  // Dropdown values
  String _selectedState = 'MAHARASHTRA';
  String _selectedCountry = 'INDIA';
  String _selectedTelephoneCountry = 'INDIA (+91)';
  String _selectedFaxCountry = 'INDIA (+91)';
  String _selectedMobileCountry = 'INDIA (+91)';

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _profileTabController = TabController(length: 4, vsync: this);

    // Pre-fill some sample data
    _roleController.text = 'Artist';
    _emailController.text = 'artist@ymail.com';
    _passwordController.text = '**********';
    _cityController.text = 'Nagpur';
    _postalCodeController.text = '440022';
    _companyNameController.text = 'Company Name';
    _designationController.text = 'Director';
    _departmentController.text = 'Administration';
    _telephoneController.text = '12-3456-7890';
    _faxController.text = '12-3456-7890';
    _mobileController.text = '12-3456-7890';
    _websiteController.text = 'www.xyzcompany.com';
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _profileTabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _companyNameController.dispose();
    _designationController.dispose();
    _departmentController.dispose();
    _telephoneController.dispose();
    _faxController.dispose();
    _mobileController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Add Employee',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF232534),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _mainTabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
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
        controller: _mainTabController,
        children: [_buildAdminUserView(), _buildEmployeesView()],
      ),
    );
  }

  Widget _buildAdminUserView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Tabs
          _buildProfileTabs(),

          // Profile Content
          _buildProfileContent(),
        ],
      ),
    );
  }

  Widget _buildProfileTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _profileTabController,
        indicatorColor: const Color(0xFF232534),
        labelColor: const Color(0xFF232534),
        unselectedLabelColor: Colors.grey[600],
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Profile'),
          Tab(text: 'Members'),
          Tab(text: 'Bank Details & Financials'),
          Tab(text: 'Subscriptions'),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return TabBarView(
      controller: _profileTabController,
      children: [
        _buildProfileTab(),
        _buildPlaceholderTab('Members'),
        _buildPlaceholderTab('Bank Details & Financials'),
        _buildPlaceholderTab('Subscriptions'),
      ],
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal Details Section
          _buildPersonalDetailsSection(),
          const SizedBox(height: 24),

          // Company Details Section
          _buildCompanyDetailsSection(),
        ],
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
                // Profile Picture and Name Fields
                _buildProfilePictureAndNameFields(),
                const SizedBox(height: 16),

                // Role field
                _buildFormField('Role', _roleController),
                const SizedBox(height: 16),

                // Email field
                _buildFormField('Login Email', _emailController),
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

  Widget _buildProfilePictureAndNameFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - stack vertically
          return Column(
            children: [
              _buildProfilePicture(),
              const SizedBox(height: 16),
              _buildNameFields(),
            ],
          );
        } else {
          // Tablet layout - side by side
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildNameFields()),
              const SizedBox(width: 20),
              Expanded(flex: 1, child: _buildProfilePicture()),
            ],
          );
        }
      },
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Column(
        children: [
          Container(
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
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '+ ADD PHOTO',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name',
          style: GoogleFonts.poppins(
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
                  _buildFormField('First Name', _firstNameController),
                  const SizedBox(height: 12),
                  _buildFormField('Last Name', _lastNameController),
                ],
              );
            } else {
              // Tablet layout - side by side
              return Row(
                children: [
                  Expanded(
                    child: _buildFormField('First Name', _firstNameController),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormField('Last Name', _lastNameController),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildFormField('', _passwordController)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'CHANGE PASSWORD',
                style: GoogleFonts.poppins(
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
        Text(
          'Address (Permanent)',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        _buildFormField('Address Line 1', _addressLine1Controller),
        const SizedBox(height: 12),
        _buildFormField('Address Line 2', _addressLine2Controller),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile layout - stack all fields vertically
              return Column(
                children: [
                  _buildFormField('City', _cityController),
                  const SizedBox(height: 12),
                  _buildDropdownField('State', _selectedState, (value) {
                    setState(() {
                      _selectedState = value!;
                    });
                  }),
                  const SizedBox(height: 12),
                  _buildFormField('Postal Code', _postalCodeController),
                  const SizedBox(height: 12),
                  _buildDropdownField('Country', _selectedCountry, (value) {
                    setState(() {
                      _selectedCountry = value!;
                    });
                  }),
                ],
              );
            } else {
              // Tablet layout - 2x2 grid
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildFormField('City', _cityController)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField('State', _selectedState, (
                          value,
                        ) {
                          setState(() {
                            _selectedState = value!;
                          });
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          'Postal Code',
                          _postalCodeController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField(
                          'Country',
                          _selectedCountry,
                          (value) {
                            setState(() {
                              _selectedCountry = value!;
                            });
                          },
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
                _buildFormField('Company Name', _companyNameController),
                const SizedBox(height: 16),

                // Designation and Department
                _buildDesignationDepartmentFields(),
                const SizedBox(height: 16),

                // Phone fields
                _buildPhoneFields(),
                const SizedBox(height: 16),

                // Website field
                _buildFormField('Website', _websiteController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignationDepartmentFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - stack vertically
          return Column(
            children: [
              _buildFormField('Designation', _designationController),
              const SizedBox(height: 12),
              _buildFormField('Department', _departmentController),
            ],
          );
        } else {
          // Tablet layout - side by side
          return Row(
            children: [
              Expanded(
                child: _buildFormField('Designation', _designationController),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFormField('Department', _departmentController),
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
          _selectedTelephoneCountry,
          _telephoneController,
        ),
        const SizedBox(height: 12),
        _buildPhoneField('Fax', _selectedFaxCountry, _faxController),
        const SizedBox(height: 12),
        _buildPhoneField(
          'Mobile Number',
          _selectedMobileCountry,
          _mobileController,
        ),
      ],
    );
  }

  Widget _buildPhoneField(
    String label,
    String countryCode,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
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
                  _buildDropdownField('', countryCode, (value) {
                    setState(() {
                      if (label == 'Telephone') {
                        _selectedTelephoneCountry = value!;
                      } else if (label == 'Fax') {
                        _selectedFaxCountry = value!;
                      } else if (label == 'Mobile Number') {
                        _selectedMobileCountry = value!;
                      }
                    });
                  }),
                  const SizedBox(height: 8),
                  _buildFormField('', controller),
                ],
              );
            } else {
              // Tablet layout - side by side
              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDropdownField('', countryCode, (value) {
                      setState(() {
                        if (label == 'Telephone') {
                          _selectedTelephoneCountry = value!;
                        } else if (label == 'Fax') {
                          _selectedFaxCountry = value!;
                        } else if (label == 'Mobile Number') {
                          _selectedMobileCountry = value!;
                        }
                      });
                    }),
                  ),
                  const SizedBox(width: 8),
                  Expanded(flex: 3, child: _buildFormField('', controller)),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF232534),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            hintText: label.isEmpty
                ? 'Enter ${label.toLowerCase()}'
                : 'Enter ${label.toLowerCase()}',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF232534)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: GoogleFonts.poppins(
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
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
      ],
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

  Widget _buildAddEmployeeButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF232534),
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
        label: Text(
          'Add Employee',
          style: GoogleFonts.poppins(
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
        'name': 'John Smith',
        'role': 'Manager',
        'department': 'Operations',
        'email': 'john.smith@company.com',
        'phone': '+1 234-567-8900',
        'status': 'Active',
        'avatar': 'J',
      },
      {
        'name': 'Sarah Johnson',
        'role': 'Developer',
        'department': 'IT',
        'email': 'sarah.johnson@company.com',
        'phone': '+1 234-567-8901',
        'status': 'Active',
        'avatar': 'S',
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
                color: isActive ? const Color(0xFF232534) : Colors.grey[400],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  employee['avatar']!,
                  style: GoogleFonts.poppins(
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
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${employee['role']} • ${employee['department']}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employee['email']!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
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
                          style: GoogleFonts.poppins(
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

  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '$title Tab',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This section will be implemented soon',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddEmployee() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Add Employee functionality will be implemented here',
          style: GoogleFonts.poppins(),
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
        content: Text(
          'Viewing ${employee['name']} details',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleEditEmployee(Map<String, String> employee) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Editing ${employee['name']}',
          style: GoogleFonts.poppins(),
        ),
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
          title: Text(
            'Delete Employee',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to delete ${employee['name']}?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${employee['name']} deleted successfully',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
