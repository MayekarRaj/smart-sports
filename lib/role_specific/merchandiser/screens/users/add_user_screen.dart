import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/users/view_user_screen.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Form controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _faxController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  // Form state
  String _selectedState = 'MAHARASHTRA';
  String _selectedCountry = 'INDIA';
  String _selectedTelephoneCountry = 'INDIA (+91)';
  String _selectedFaxCountry = 'INDIA (+91)';
  String _selectedMobileCountry = 'INDIA (+91)';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Pre-fill some fields as shown in the image
    _roleController.text = 'Admin';
    _emailController.text = 'admin@ymail.com';
    _cityController.text = 'Nagpur';
    _postalCodeController.text = '440022';
    _designationController.text = 'Director';
    _departmentController.text = 'Administration';
    _telephoneController.text = '12-3456-7890';
    _faxController.text = '12-3456-7890';
    _mobileController.text = '12-3456-7890';
    _websiteController.text = 'www.xyzcompany.com';
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          'Add User',
          style: GoogleFonts.poppins(
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
              colors: [Color(0xFF009A69), Color(0xFF232534)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
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
        controller: _tabController,
        children: [_buildAdminUserForm(), _buildEmployeesForm()],
      ),
    );
  }

  Widget _buildAdminUserForm() {
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
          const SizedBox(height: 32),

          // Save Button
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildEmployeesForm() {
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
          const SizedBox(height: 32),

          // Save Button
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - center the profile picture
          return Center(
            child: Column(
              children: [
                _buildProfilePicture(),
                const SizedBox(height: 12),
                _buildAddPhotoButton(),
              ],
            ),
          );
        } else {
          // Tablet layout - align to right
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  _buildProfilePicture(),
                  const SizedBox(height: 12),
                  _buildAddPhotoButton(),
                ],
              ),
            ],
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

  Widget _buildAddPhotoButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            'ADD PHOTO',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
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
                // Name fields
                _buildNameFields(),
                const SizedBox(height: 16),

                // Role field
                _buildFormField('Role', _roleController, enabled: false),
                const SizedBox(height: 16),

                // Email field
                _buildFormField('Login Email', _emailController),
                const SizedBox(height: 16),

                // Password fields
                _buildPasswordFields(),
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

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF009A69),
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

  Widget _buildNameFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
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
    );
  }

  Widget _buildPasswordFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - stack vertically
          return Column(
            children: [
              _buildFormField(
                'Password',
                _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 12),
              _buildFormField(
                'Confirm Password',
                _confirmPasswordController,
                isPassword: true,
              ),
            ],
          );
        } else {
          // Tablet layout - side by side
          return Row(
            children: [
              Expanded(
                child: _buildFormField(
                  'Password',
                  _passwordController,
                  isPassword: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFormField(
                  'Confirm Password',
                  _confirmPasswordController,
                  isPassword: true,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildAddressFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address* (Permanent)',
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
                  _buildDropdownField('State', _selectedState, [
                    'MAHARASHTRA',
                    'KARNATAKA',
                    'TAMIL NADU',
                  ]),
                  const SizedBox(height: 12),
                  _buildFormField('Postal Code', _postalCodeController),
                  const SizedBox(height: 12),
                  _buildDropdownField('Country', _selectedCountry, [
                    'INDIA',
                    'USA',
                    'UK',
                  ]),
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
                        child: _buildDropdownField('State', _selectedState, [
                          'MAHARASHTRA',
                          'KARNATAKA',
                          'TAMIL NADU',
                        ]),
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
                          ['INDIA', 'USA', 'UK'],
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
          'Telephone*',
          _selectedTelephoneCountry,
          _telephoneController,
        ),
        const SizedBox(height: 12),
        _buildPhoneField('Fax', _selectedFaxCountry, _faxController),
        const SizedBox(height: 12),
        _buildPhoneField(
          'Mobile Number*',
          _selectedMobileCountry,
          _mobileController,
        ),
      ],
    );
  }

  Widget _buildPhoneField(
    String label,
    String selectedCountry,
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
                  _buildDropdownField('', selectedCountry, [
                    'INDIA (+91)',
                    'USA (+1)',
                    'UK (+44)',
                  ]),
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
                    child: _buildDropdownField('', selectedCountry, [
                      'INDIA (+91)',
                      'USA (+1)',
                      'UK (+44)',
                    ]),
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

  Widget _buildFormField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    bool isPassword = false,
  }) {
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
          enabled: enabled,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: isPassword ? 'Editable' : 'Enter ${label.toLowerCase()}',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[400],
            ),
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
              borderSide: const BorderSide(color: Color(0xFF009A69)),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items) {
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
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    if (label == 'State') {
                      _selectedState = newValue;
                    } else if (label == 'Country') {
                      _selectedCountry = newValue;
                    } else if (label == '') {
                      // Handle phone country codes
                      if (value == _selectedTelephoneCountry) {
                        _selectedTelephoneCountry = newValue;
                      } else if (value == _selectedFaxCountry) {
                        _selectedFaxCountry = newValue;
                      } else if (value == _selectedMobileCountry) {
                        _selectedMobileCountry = newValue;
                      }
                    }
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF009A69),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: () {
          // Collect all form data
          final userData = {
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'role': _roleController.text,
            'email': _emailController.text,
            'addressLine1': _addressLine1Controller.text,
            'addressLine2': _addressLine2Controller.text,
            'city': _cityController.text,
            'state': _selectedState,
            'postalCode': _postalCodeController.text,
            'country': _selectedCountry,
            'companyName': _companyNameController.text,
            'designation': _designationController.text,
            'department': _departmentController.text,
            'telephoneCountry': _selectedTelephoneCountry,
            'telephone': _telephoneController.text,
            'faxCountry': _selectedFaxCountry,
            'fax': _faxController.text,
            'mobileCountry': _selectedMobileCountry,
            'mobile': _mobileController.text,
            'website': _websiteController.text,
          };

          // Navigate to View User screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ViewUserScreen(userData: userData),
            ),
          );
        },
        child: Text(
          'Save User',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
