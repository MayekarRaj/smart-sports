import 'package:flutter/material.dart';
import 'profile_tab_components.dart';

// Profile Tab Content Builder
class ProfileTabContentBuilder extends StatelessWidget {
  final Color roleColor;
  final bool isMobile;
  final bool isEditMode;
  final ValueChanged<bool> onEditModeChanged;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController passwordController;
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController cityController;
  final TextEditingController pincodeController;
  final TextEditingController companyNameController;
  final TextEditingController designationController;
  final TextEditingController departmentController;
  final TextEditingController telephoneController;
  final TextEditingController faxController;
  final TextEditingController mobileController;
  final TextEditingController websiteController;
  final String selectedState;
  final String selectedCountry;
  final String selectedTelephoneCode;
  final String selectedFaxCode;
  final String selectedMobileCode;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onTelephoneCodeChanged;
  final ValueChanged<String> onFaxCodeChanged;
  final ValueChanged<String> onMobileCodeChanged;
  final String roleLabel;
  final String userEmail;

  const ProfileTabContentBuilder({
    super.key,
    required this.roleColor,
    required this.isMobile,
    required this.isEditMode,
    required this.onEditModeChanged,
    required this.firstNameController,
    required this.lastNameController,
    required this.passwordController,
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.cityController,
    required this.pincodeController,
    required this.companyNameController,
    required this.designationController,
    required this.departmentController,
    required this.telephoneController,
    required this.faxController,
    required this.mobileController,
    required this.websiteController,
    required this.selectedState,
    required this.selectedCountry,
    required this.selectedTelephoneCode,
    required this.selectedFaxCode,
    required this.selectedMobileCode,
    required this.onStateChanged,
    required this.onCountryChanged,
    required this.onTelephoneCodeChanged,
    required this.onFaxCodeChanged,
    required this.onMobileCodeChanged,
    required this.roleLabel,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    final states = ['New York', 'California', 'Texas', 'Florida', 'Illinois'];
    final countries = ['United States', 'Canada', 'United Kingdom', 'Australia'];
    final countryCodes = ['+1', '+44', '+91', '+61', '+86'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Edit/Save Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  onEditModeChanged(!isEditMode);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditMode ? 'Changes saved' : 'Edit mode enabled'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                icon: Icon(isEditMode ? Icons.save : Icons.edit),
                label: Text(isEditMode ? 'Save' : 'Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: roleColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Basic Profile Section
          ProfileSectionCard(
            title: 'Basic Profile',
            roleColor: roleColor,
            child: _buildBasicProfileSection(context, states, countryCodes),
          ),
          const SizedBox(height: 20),
          // Personal Details Section
          ProfileSectionCard(
            title: 'Personal Details',
            roleColor: roleColor,
            child: _buildPersonalDetailsSection(states, countries),
          ),
          const SizedBox(height: 20),
          // Company Details Section
          ProfileSectionCard(
            title: 'Company Details',
            roleColor: roleColor,
            child: _buildCompanyDetailsSection(countryCodes),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBasicProfileSection(
    BuildContext context,
    List<String> states,
    List<String> countryCodes,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileFormField(
                label: 'First Name',
                controller: firstNameController,
                enabled: isEditMode,
              ),
              const SizedBox(height: 16),
              ProfileFormField(
                label: 'Last Name',
                controller: lastNameController,
                enabled: isEditMode,
              ),
              const SizedBox(height: 16),
              ProfileFormField(
                label: 'Role',
                controller: TextEditingController(text: roleLabel),
                enabled: false,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              ProfileFormField(
                label: 'Login Email',
                controller: TextEditingController(text: userEmail),
                enabled: false,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              ProfileFormField(
                label: 'Password',
                controller: passwordController,
                enabled: isEditMode,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              if (isEditMode)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Change Password feature coming soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.lock_outline, size: 18),
                    label: const Text('Change Password'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: roleColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Profile Picture
        Column(
          children: [
            Stack(
              children: [
                Container(
                  width: isMobile ? 100 : 120,
                  height: isMobile ? 100 : 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        roleColor,
                        roleColor.withValues(alpha: 0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: roleColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: isMobile ? 50 : 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (isEditMode)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile picture update coming soon'),
                          ),
                        );
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: roleColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (isEditMode) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Upload photo feature coming soon'),
                    ),
                  );
                },
                child: const Text('Upload Photo'),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalDetailsSection(
    List<String> states,
    List<String> countries,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileFormField(
          label: 'Permanent Address',
          controller: TextEditingController(text: 'Permanent Address'),
          enabled: false,
          readOnly: true,
        ),
        const SizedBox(height: 16),
        ProfileFormField(
          label: 'Address Line 1',
          controller: addressLine1Controller,
          enabled: isEditMode,
        ),
        const SizedBox(height: 16),
        ProfileFormField(
          label: 'Address Line 2',
          controller: addressLine2Controller,
          enabled: isEditMode,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ProfileFormField(
                label: 'City',
                controller: cityController,
                enabled: isEditMode,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ProfileDropdownField(
                label: 'State',
                value: selectedState,
                items: states,
                enabled: isEditMode,
                onChanged: onStateChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ProfileFormField(
                label: 'Pincode',
                controller: pincodeController,
                enabled: isEditMode,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ProfileDropdownField(
                label: 'Country',
                value: selectedCountry,
                items: countries,
                enabled: isEditMode,
                onChanged: onCountryChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompanyDetailsSection(List<String> countryCodes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileFormField(
          label: 'Company Name',
          controller: companyNameController,
          enabled: isEditMode,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ProfileFormField(
                label: 'Designation',
                controller: designationController,
                enabled: isEditMode,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ProfileFormField(
                label: 'Department',
                controller: departmentController,
                enabled: isEditMode,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ProfilePhoneField(
          label: 'Telephone',
          controller: telephoneController,
          selectedCode: selectedTelephoneCode,
          codes: countryCodes,
          enabled: isEditMode,
          onCodeChanged: onTelephoneCodeChanged,
        ),
        const SizedBox(height: 16),
        ProfilePhoneField(
          label: 'Fax',
          controller: faxController,
          selectedCode: selectedFaxCode,
          codes: countryCodes,
          enabled: isEditMode,
          onCodeChanged: onFaxCodeChanged,
        ),
        const SizedBox(height: 16),
        ProfilePhoneField(
          label: 'Mobile Number',
          controller: mobileController,
          selectedCode: selectedMobileCode,
          codes: countryCodes,
          enabled: isEditMode,
          onCodeChanged: onMobileCodeChanged,
        ),
        const SizedBox(height: 16),
        ProfileFormField(
          label: 'Website',
          controller: websiteController,
          enabled: isEditMode,
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }
}

