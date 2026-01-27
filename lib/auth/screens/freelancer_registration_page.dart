import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/api_models.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/exceptions/api_exception.dart';
import 'freelancer_membership_plan_page.dart';
import '../widgets/city_search_field.dart';
import '../widgets/phone_code_dropdown.dart';

class FreelancerRegistrationPage extends ConsumerStatefulWidget {
  const FreelancerRegistrationPage({super.key});

  @override
  ConsumerState<FreelancerRegistrationPage> createState() =>
      _FreelancerRegistrationPageState();
}

class _FreelancerRegistrationPageState
    extends ConsumerState<FreelancerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

  // Number of Users
  final TextEditingController _numberOfUsersController = TextEditingController(
    text: '1',
  );

  // Address Options
  bool _companyAddressSameAsSignup = true;
  bool _contactDetailsSameAsSignup = true;

  // Company Address Controllers
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

  // Contact Details Controllers
  final _designationController = TextEditingController();
  final _departmentController = TextEditingController();
  final _officeNumberController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _websiteController = TextEditingController();
  String _officeCountryCode = '+91';
  String _mobileCountryCode = '+91';

  final FocusNode _officePhoneFocus = FocusNode();
  final FocusNode _mobilePhoneFocus = FocusNode();

  @override
  void dispose() {
    _numberOfUsersController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _designationController.dispose();
    _departmentController.dispose();
    _officeNumberController.dispose();
    _mobileNumberController.dispose();
    _websiteController.dispose();
    _officePhoneFocus.dispose();
    _mobilePhoneFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      // Build request
      final request = FreelancerSignupRequest(
        userRole: 'freelancer',
        noOfUsers: int.tryParse(_numberOfUsersController.text) ?? 1,
        isAddressIsSameAsUser: _companyAddressSameAsSignup ? 1 : 0,
        addressLine1: _companyAddressSameAsSignup
            ? null
            : _address1Controller.text.trim().isNotEmpty
            ? _address1Controller.text.trim()
            : null,
        addressLine2: _companyAddressSameAsSignup
            ? null
            : _address2Controller.text.trim().isNotEmpty
            ? _address2Controller.text.trim()
            : null,
        addressLine3: null, // Not in current form
        city: _companyAddressSameAsSignup
            ? null
            : _cityController.text.trim().isNotEmpty
            ? _cityController.text.trim()
            : null,
        state: _companyAddressSameAsSignup
            ? null
            : _stateController.text.trim().isNotEmpty
            ? _stateController.text.trim()
            : null,
        zipcode: _companyAddressSameAsSignup
            ? null
            : _zipController.text.trim().isNotEmpty
            ? _zipController.text.trim()
            : null,
        country: _companyAddressSameAsSignup
            ? null
            : _countryController.text.trim().isNotEmpty
            ? _countryController.text.trim()
            : null,
        isContactDetailsIsSameUser: _contactDetailsSameAsSignup ? 1 : 0,
        designation: _contactDetailsSameAsSignup
            ? null
            : _designationController.text.trim().isNotEmpty
            ? _designationController.text.trim()
            : null,
        department: _contactDetailsSameAsSignup
            ? null
            : _departmentController.text.trim().isNotEmpty
            ? _departmentController.text.trim()
            : null,
        officePhoneExt: _contactDetailsSameAsSignup
            ? null
            : _officeNumberController.text.trim().isNotEmpty
            ? _officeCountryCode
            : null,
        officePhone: _contactDetailsSameAsSignup
            ? null
            : _officeNumberController.text.trim().isNotEmpty
            ? _officeNumberController.text.trim()
            : null,
        mobilePhoneExt: _contactDetailsSameAsSignup
            ? null
            : _mobileNumberController.text.trim().isNotEmpty
            ? _mobileCountryCode
            : null,
        mobilePhone: _contactDetailsSameAsSignup
            ? null
            : _mobileNumberController.text.trim().isNotEmpty
            ? _mobileNumberController.text.trim()
            : null,
        companyWebsite: _contactDetailsSameAsSignup
            ? null
            : _websiteController.text.trim().isNotEmpty
            ? _websiteController.text.trim()
            : null,
      );

      // Call API
      await _authRepository.freelancerSignup(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Freelancer registration successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to membership plan page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FreelancerMembershipPlanPage(),
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8BB6D9), Color(0xFF6BA3D1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Freelancer Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Number Of Users Section
              _buildSectionCard(
                title: 'Freelancer Details',
                titleColor: Colors.white,
                titleBackground: const Color(0xFF8BB6D9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _numberOfUsersController,
                      label: 'Number Of Users',
                      hint: '1',
                      keyboardType: TextInputType.number,
                      suffixText:
                          '(You Will Be Allowed To Add Users From Your Admin Panel After Subscription.)',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Company Address Checkbox
              _buildCheckboxSection(
                'Company Address Is Same As Sign Up Address?',
                _companyAddressSameAsSignup,
                (value) {
                  setState(() {
                    _companyAddressSameAsSignup = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Company Address Section
              if (!_companyAddressSameAsSignup) _buildAddressSection(),
              if (!_companyAddressSameAsSignup) const SizedBox(height: 16),

              // Contact Details Checkbox
              _buildCheckboxSection(
                'Contact Details Is Same As Sign Up Contact Details?',
                _contactDetailsSameAsSignup,
                (value) {
                  setState(() {
                    _contactDetailsSameAsSignup = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Contact Details Section
              if (!_contactDetailsSameAsSignup) _buildContactDetailsSection(),
              if (!_contactDetailsSameAsSignup) const SizedBox(height: 16),

              const SizedBox(height: 32),
              _buildBottomNavigation(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Color titleColor,
    required Color titleBackground,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: titleBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: titleBackground.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getSectionIcon(title),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(24), child: child),
        ],
      ),
    );
  }

  IconData _getSectionIcon(String title) {
    if (title.contains('Freelancer') || title.contains('Details')) {
      return Icons.person_outline;
    } else if (title.contains('Address')) {
      return Icons.location_on;
    } else if (title.contains('Contact')) {
      return Icons.contact_phone;
    }
    return Icons.info_outline;
  }

  Widget _buildCheckboxSection(
    String label,
    bool value,
    Function(bool?) onChanged,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value
              ? const Color(0xFF8BB6D9).withOpacity(0.3)
              : Colors.grey[200]!,
          width: value ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: value
                ? const Color(0xFF8BB6D9).withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            blurRadius: value ? 12 : 8,
            offset: Offset(0, value ? 4 : 2),
            spreadRadius: value ? 1 : 0,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onChanged(!value);
        },
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? const Color(0xFF8BB6D9) : Colors.transparent,
                border: Border.all(
                  color: value ? const Color(0xFF8BB6D9) : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: value
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : const SizedBox(width: 20, height: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: value ? FontWeight.w600 : FontWeight.w500,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return AnimatedOpacity(
      opacity: _companyAddressSameAsSignup ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: _buildSectionCard(
          title: 'Company Address',
          titleColor: Colors.white,
          titleBackground: Colors.black,
          child: Column(
            children: [
              _buildTextField(
                controller: _address1Controller,
                label: 'Address 1',
                hint: 'Enter address line 1',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _address2Controller,
                label: 'Address 2',
                hint: 'Enter address line 2',
              ),
              const SizedBox(height: 16),
              CitySearchField(
                cityController: _cityController,
                stateController: _stateController,
                countryController: _countryController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _zipController,
                label: 'Zip Code',
                hint: 'Enter zip code',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactDetailsSection() {
    return AnimatedOpacity(
      opacity: _contactDetailsSameAsSignup ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: _buildSectionCard(
          title: 'Contact Details',
          titleColor: Colors.white,
          titleBackground: const Color(0xFF11998E),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _designationController,
                      label: 'Designation',
                      hint: 'Designation',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _departmentController,
                      label: 'Department',
                      hint: 'Department',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: PhoneCodeDropdown(
                      value: _officeCountryCode,
                      onChanged: (code) {
                        if (code != null) {
                          setState(() {
                            _officeCountryCode = code;
                          });
                          _officePhoneFocus.requestFocus();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _officeNumberController,
                      focusNode: _officePhoneFocus,
                      label: 'Office Number',
                      hint: '9876543210',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: PhoneCodeDropdown(
                      value: _mobileCountryCode,
                      onChanged: (code) {
                        if (code != null) {
                          setState(() {
                            _mobileCountryCode = code;
                          });
                          _mobilePhoneFocus.requestFocus();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _mobileNumberController,
                      focusNode: _mobilePhoneFocus,
                      label: 'Mobile Number',
                      hint: '9876543210',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _websiteController,
                label: 'Company Website',
                hint: 'https://abc.com',
                keyboardType: TextInputType.url,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    FocusNode? focusNode,
    String? suffixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1.5),
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            enabled: !_isLoading,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
            onChanged: (value) {
              if (label == 'Number Of Users') {
                setState(() {});
              }
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (suffixText != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.orange[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    suffixText,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[900],
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    // Ensure value is in items list, otherwise use null
    final validValue =
        value != null && value.isNotEmpty && items.contains(value)
        ? value
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1.5),
          ),
          child: DropdownButtonFormField<String>(
            value: validValue,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: 'Select',
            ),
            hint: label.isEmpty
                ? null
                : Text('Select', style: TextStyle(color: Colors.grey[400])),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF64748B),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        HapticFeedback.mediumImpact();
                        _submitRegistration();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
