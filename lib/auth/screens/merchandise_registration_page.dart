import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/models/api_models.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/utils/phone_parser.dart';
import '../../core/services/storage_service.dart';
import '../widgets/sports_multi_select.dart';
import 'merchandiser_membership_plan_page.dart';

// Helper class for branch data
class BranchData {
  final TextEditingController branchNameController;
  final TextEditingController numberOfUsersController;
  bool addressSameAsSignup;
  bool contactSameAsSignup;

  // Address Controllers (per branch)
  final TextEditingController address1Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipController;
  final TextEditingController countryController;

  // Contact Details Controllers (per branch)
  final TextEditingController officePhoneController;
  final TextEditingController mobilePhoneController;
  final TextEditingController websiteController;

  // Sports selection (per branch)
  List<String> selectedSports;

  BranchData({
    required this.branchNameController,
    required this.numberOfUsersController,
    this.addressSameAsSignup = true,
    this.contactSameAsSignup = true,
    required this.address1Controller,
    required this.cityController,
    required this.stateController,
    required this.zipController,
    required this.countryController,
    required this.officePhoneController,
    required this.mobilePhoneController,
    required this.websiteController,
    this.selectedSports = const [],
  });

  void dispose() {
    branchNameController.dispose();
    numberOfUsersController.dispose();
    address1Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    countryController.dispose();
    officePhoneController.dispose();
    mobilePhoneController.dispose();
    websiteController.dispose();
  }
}

class MerchandiseRegistrationPage extends ConsumerStatefulWidget {
  const MerchandiseRegistrationPage({super.key});

  @override
  ConsumerState<MerchandiseRegistrationPage> createState() =>
      _MerchandiseRegistrationPageState();
}

class _MerchandiseRegistrationPageState
    extends ConsumerState<MerchandiseRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

  // Company Details Controllers
  final _branchesController = TextEditingController(text: '1');

  // Branch Data - Dynamic structure
  final List<BranchData> _branches = [];

  // Sports data
  List<Sport> _allSports = [];
  bool _isLoadingSports = false;

  @override
  void initState() {
    super.initState();
    // Add one initial branch
    _addBranch();
    _loadSports();
  }

  Future<void> _loadSports() async {
    if (!mounted) return;

    setState(() {
      _isLoadingSports = true;
    });

    try {
      final response = await _authRepository.getSportsList(
        orderBy: 'id|ASC',
        isActive: 1,
      );

      if (mounted) {
        setState(() {
          _allSports = response.data;
          _isLoadingSports = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSports = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load sports: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _branchesController.dispose();
    // Dispose all branches
    for (var branch in _branches) {
      branch.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _addBranch() {
    setState(() {
      _branches.add(
        BranchData(
          branchNameController: TextEditingController(),
          numberOfUsersController: TextEditingController(text: '1'),
          addressSameAsSignup: true,
          contactSameAsSignup: true,
          address1Controller: TextEditingController(),
          cityController: TextEditingController(),
          stateController: TextEditingController(),
          zipController: TextEditingController(),
          countryController: TextEditingController(),
          officePhoneController: TextEditingController(),
          mobilePhoneController: TextEditingController(),
          websiteController: TextEditingController(),
          selectedSports: [],
        ),
      );
    });
  }

  void _removeBranch(int index) {
    if (_branches.length > 1) {
      setState(() {
        _branches[index].dispose();
        _branches.removeAt(index);
        // Update number of branches controller
        _branchesController.text = _branches.length.toString();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one branch is required'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    // Validate branches
    if (_branches.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one branch'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validate first branch (required for step 1)
    final firstBranch = _branches[0];
    if (firstBranch.branchNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter branch name for Branch 1'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Step 1: Submit first branch
      final firstBranchData = _branches[0];

      // Parse phone numbers for first branch
      final officePhone = PhoneParser.parsePhoneNumber(
        firstBranchData.officePhoneController.text,
      );
      final mobilePhone = PhoneParser.parsePhoneNumber(
        firstBranchData.mobilePhoneController.text,
      );

      final step1Request = MerchandizerSignupRequest(
        userRole: 'merchandizer',
        branchName: firstBranchData.branchNameController.text.trim(),
        noOfUsers:
            int.tryParse(firstBranchData.numberOfUsersController.text) ?? 1,
        isAddressIsSameAsUser: firstBranchData.addressSameAsSignup ? 1 : 0,
        addressLine1: firstBranchData.addressSameAsSignup
            ? null
            : firstBranchData.address1Controller.text.trim().isNotEmpty
            ? firstBranchData.address1Controller.text.trim()
            : null,
        addressLine2: null, // Not in API request
        city: firstBranchData.addressSameAsSignup
            ? null
            : firstBranchData.cityController.text.trim().isNotEmpty
            ? firstBranchData.cityController.text.trim()
            : null,
        state: firstBranchData.addressSameAsSignup
            ? null
            : firstBranchData.stateController.text.trim().isNotEmpty
            ? firstBranchData.stateController.text.trim()
            : null,
        zipcode: firstBranchData.addressSameAsSignup
            ? null
            : firstBranchData.zipController.text.trim().isNotEmpty
            ? firstBranchData.zipController.text.trim()
            : null,
        country: firstBranchData.addressSameAsSignup
            ? null
            : firstBranchData.countryController.text.trim().isNotEmpty
            ? firstBranchData.countryController.text.trim()
            : null,
        isContactDetailsIsSameUser: firstBranchData.contactSameAsSignup ? 1 : 0,
        designation: null, // Not in API request
        department: null, // Not in API request
        officePhoneExt: firstBranchData.contactSameAsSignup
            ? null
            : officePhone['ext']?.isNotEmpty == true
            ? officePhone['ext']
            : null,
        officePhone: firstBranchData.contactSameAsSignup
            ? null
            : officePhone['number']?.isNotEmpty == true
            ? officePhone['number']
            : null,
        mobilePhoneExt: firstBranchData.contactSameAsSignup
            ? null
            : mobilePhone['ext']?.isNotEmpty == true
            ? mobilePhone['ext']
            : null,
        mobilePhone: firstBranchData.contactSameAsSignup
            ? null
            : mobilePhone['number']?.isNotEmpty == true
            ? mobilePhone['number']
            : null,
        companyWebsite: firstBranchData.contactSameAsSignup
            ? null
            : firstBranchData.websiteController.text.trim().isNotEmpty
            ? firstBranchData.websiteController.text.trim()
            : null,
      );

      final step1Response = await _authRepository.merchandizerSignup(
        step1Request,
      );

      // Save merchandizer ID for later use (e.g., fetching branches)
      final storageService = StorageService();
      await storageService.saveInt(
        'merchandizer_id',
        step1Response.merchandizerId,
      );

      // Step 2: Submit additional branches (if any)
      if (_branches.length > 1) {
        final additionalBranches = _branches.sublist(1).map((branch) {
          // Parse phone numbers
          final officePhone = PhoneParser.parsePhoneNumber(
            branch.officePhoneController.text,
          );
          final mobilePhone = PhoneParser.parsePhoneNumber(
            branch.mobilePhoneController.text,
          );

          // Validate branch name
          if (branch.branchNameController.text.trim().isEmpty) {
            throw Exception('Please enter branch name for all branches');
          }

          // Validate sports selection
          if (branch.selectedSports.isEmpty) {
            throw Exception(
              'Please select at least one sport for all branches',
            );
          }

          return MerchandizerBranch(
            branchName: branch.branchNameController.text.trim(),
            noOfUsers: int.tryParse(branch.numberOfUsersController.text) ?? 1,
            isAddressSameAsUser: branch.addressSameAsSignup ? 1 : 0,
            addressLine1: branch.addressSameAsSignup
                ? null
                : branch.address1Controller.text.trim().isNotEmpty
                ? branch.address1Controller.text.trim()
                : null,
            city: branch.addressSameAsSignup
                ? null
                : branch.cityController.text.trim().isNotEmpty
                ? branch.cityController.text.trim()
                : null,
            state: branch.addressSameAsSignup
                ? null
                : branch.stateController.text.trim().isNotEmpty
                ? branch.stateController.text.trim()
                : null,
            zipCode: branch.addressSameAsSignup
                ? null
                : branch.zipController.text.trim().isNotEmpty
                ? branch.zipController.text.trim()
                : null,
            country: branch.addressSameAsSignup
                ? null
                : branch.countryController.text.trim().isNotEmpty
                ? branch.countryController.text.trim()
                : null,
            isContactSameAsUser: branch.contactSameAsSignup ? 1 : 0,
            officePhone: branch.contactSameAsSignup
                ? null
                : officePhone['number']?.isNotEmpty == true
                ? officePhone['number']
                : null,
            mobilePhone: branch.contactSameAsSignup
                ? null
                : mobilePhone['number']?.isNotEmpty == true
                ? mobilePhone['number']
                : null,
            companyWebsite: branch.contactSameAsSignup
                ? null
                : branch.websiteController.text.trim().isNotEmpty
                ? branch.websiteController.text.trim()
                : null,
            sportsNames: branch.selectedSports,
          );
        }).toList();

        final step2Request = MerchandizerBranchSignupRequest(
          branches: additionalBranches,
        );
        await _authRepository.merchandizerBranchSignup(step2Request);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Merchandizer registration successful!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MerchandiserMembershipPlanPage(),
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        // Handle validation errors
        if (e.isValidationError && e.errors != null) {
          final errorMessages = <String>[];
          e.errors!.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              errorMessages.addAll(value.map((v) => v.toString()));
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessages.isNotEmpty ? errorMessages.first : e.message,
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
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
        backgroundColor: const Color(0xFF7C3AED),
        elevation: 2,
        shadowColor: Colors.black26,
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
        title: const Text(
          'Merchandise Registration',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
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

              // Company Details Section
              _buildSectionCard(
                title: 'Company Details',
                titleColor: Colors.white,
                titleBackground: const Color(0xFF8BB6D9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _branchesController,
                      label: 'Number Of Branches',
                      hint: '1',
                      keyboardType: TextInputType.number,
                      suffixText:
                          '(It Will Be Paid Service To Use This Platform For More Than 1 Branch)',
                      onChanged: (value) {
                        final numBranches = int.tryParse(value) ?? 1;
                        setState(() {
                          while (_branches.length < numBranches) {
                            _addBranch();
                          }
                          while (_branches.length > numBranches &&
                              _branches.length > 1) {
                            _removeBranch(_branches.length - 1);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dynamic Branch Sections
              ...List.generate(_branches.length, (index) {
                return Column(
                  children: [
                    _buildBranchSection(index),
                    const SizedBox(height: 16),
                  ],
                );
              }),

              const SizedBox(height: 32),

              // Bottom Navigation
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
    if (title == 'Company Details') {
      return Icons.shopping_bag;
    } else if (title.startsWith('Branch')) {
      return Icons.account_tree;
    }
    return Icons.info;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? suffixText,
    ValueChanged<String>? onChanged,
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
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            enabled: !_isLoading,
            onChanged: onChanged,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                vertical: 14,
              ),
            ),
          ),
        ),
        if (suffixText != null) ...[
          const SizedBox(height: 4),
          Text(
            suffixText,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCheckboxOption(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF8E2DE2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchSection(int index) {
    final branchData = _branches[index];
    final branchNumber = index + 1;

    return _buildSectionCard(
      title: 'Branch $branchNumber Details',
      titleColor: Colors.white,
      titleBackground: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: branchData.branchNameController,
                  label: 'Branch Name',
                  hint: 'Enter branch name',
                ),
              ),
              if (_branches.length > 1) ...[
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => _removeBranch(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Remove Branch',
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: branchData.numberOfUsersController,
            label: 'Number Of Users',
            hint: 'Enter number of users',
            keyboardType: TextInputType.number,
            suffixText: branchNumber > 1
                ? '(It Is A Paid Service For More Than 1 User/Branch. You Will Be Allowed To Add Users From Your Admin Panel After Subscription.)'
                : null,
          ),
          const SizedBox(height: 16),
          _buildCheckboxOption(
            'Address Is Same As Sign Up Address?',
            branchData.addressSameAsSignup,
            (value) => setState(() {
              branchData.addressSameAsSignup = value ?? false;
            }),
          ),

          // Address Section (if not same as signup)
          if (!branchData.addressSameAsSignup) ...[
            const SizedBox(height: 16),
            _buildAddressSubSection(branchData),
          ],

          const SizedBox(height: 16),
          _buildCheckboxOption(
            'Contact Details Is Same As Sign Up Contact Details?',
            branchData.contactSameAsSignup,
            (value) => setState(() {
              branchData.contactSameAsSignup = value ?? false;
            }),
          ),

          // Contact Details Section (if not same as signup)
          if (!branchData.contactSameAsSignup) ...[
            const SizedBox(height: 16),
            _buildContactDetailsSubSection(branchData),
          ],

          // Sports Section (for all branches)
          const SizedBox(height: 16),
          _buildSportsSubSection(branchData),
        ],
      ),
    );
  }

  Widget _buildAddressSubSection(BranchData branchData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Address',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: branchData.address1Controller,
          label: 'Address 1',
          hint: 'Enter address line 1',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                label: 'City',
                value: branchData.cityController.text.isNotEmpty
                    ? branchData.cityController.text
                    : null,
                items: const [
                  'Mumbai',
                  'Delhi',
                  'Bangalore',
                  'Chennai',
                  'Kolkata',
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      branchData.cityController.text = value;
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdownField(
                label: 'State',
                value: branchData.stateController.text.isNotEmpty
                    ? branchData.stateController.text
                    : null,
                items: const [
                  'Maharashtra',
                  'Delhi',
                  'Karnataka',
                  'Tamil Nadu',
                  'West Bengal',
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      branchData.stateController.text = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: branchData.zipController,
                label: 'Zip Code',
                hint: 'Enter zip code',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdownField(
                label: 'Country',
                value: branchData.countryController.text.isNotEmpty
                    ? branchData.countryController.text
                    : null,
                items: const ['India', 'USA', 'UK', 'Canada', 'Australia'],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      branchData.countryController.text = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactDetailsSubSection(BranchData branchData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Contact Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: branchData.officePhoneController,
                label: 'Office Number',
                hint: 'Enter office number',
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: branchData.mobilePhoneController,
                label: 'Mobile Number',
                hint: 'Enter mobile number',
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: branchData.websiteController,
          label: 'Company Website',
          hint: 'Enter website URL',
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _buildSportsSubSection(BranchData branchData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sports',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _isLoadingSports
              ? null
              : () async {
                  if (_allSports.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No sports available. Please try again later.',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
                  final result = await showDialog<List<String>>(
                    context: context,
                    builder: (ctx) => SportsMultiSelect(
                      allSports: _allSports,
                      initialSelected: branchData.selectedSports,
                    ),
                  );
                  if (result != null && mounted) {
                    setState(() {
                      branchData.selectedSports = result;
                    });
                  }
                },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _isLoadingSports
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Loading sports...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: branchData.selectedSports.isEmpty
                              ? [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      'Select sports',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ]
                              : branchData.selectedSports.map((sport) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF8E2DE2,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFF8E2DE2),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          sport,
                                          style: const TextStyle(
                                            color: Color(0xFF8E2DE2),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              branchData.selectedSports.remove(
                                                sport,
                                              );
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                        ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
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
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: DropdownButtonFormField<String>(
            value: validValue,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintText: 'Select',
            ),
            hint: const Text('Select', style: TextStyle(color: Colors.grey)),
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                backgroundColor: Colors.grey[50],
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                backgroundColor: Colors.grey[50],
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                shadowColor: Colors.black26,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
