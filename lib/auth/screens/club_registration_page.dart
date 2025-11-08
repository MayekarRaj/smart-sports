import 'package:flutter/material.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/models/api_models.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/phone_parser.dart';
import '../widgets/sports_multi_select.dart';
import 'club_membership_plan_page.dart';

class ClubRegistrationPage extends StatefulWidget {
  const ClubRegistrationPage({super.key});

  @override
  State<ClubRegistrationPage> createState() => _ClubRegistrationPageState();
}

class _ClubRegistrationPageState extends State<ClubRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final AuthRepository _authRepository = AuthRepository();
  final StorageService _storageService = StorageService();
  bool _isLoading = false;

  // Club Details Controllers
  final _branchesController = TextEditingController(text: '1');
  bool _allSportsSameForBranches = false;

  // Branch Data - Dynamic list to store all branches
  List<Map<String, dynamic>> _branches = [];

  // All available sports
  final List<String> _allSports = const [
    'Cricket',
    'Football',
    'Basketball',
    'Hockey',
    'Tennis',
    'Badminton',
    'Volleyball',
    'Baseball',
    'Rugby',
    'Table Tennis',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize branches first
    _initializeBranches();
    // Add listener after initialization to avoid triggering during init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _branchesController.addListener(_onBranchesChanged);
      }
    });
  }

  @override
  void dispose() {
    _branchesController.removeListener(_onBranchesChanged);
    _branchesController.dispose();

    // Dispose all branch controllers
    for (var branch in _branches) {
      if (branch['nameController'] != null) {
        (branch['nameController'] as TextEditingController).dispose();
      }
      if (branch['usersController'] != null) {
        (branch['usersController'] as TextEditingController).dispose();
      }
      if (branch['addressControllers'] != null) {
        for (var controller in branch['addressControllers'].values) {
          (controller as TextEditingController).dispose();
        }
      }
      if (branch['contactControllers'] != null) {
        for (var controller in branch['contactControllers'].values) {
          (controller as TextEditingController).dispose();
        }
      }
    }

    _scrollController.dispose();
    super.dispose();
  }

  void _initializeBranches() {
    final numberOfBranches = int.tryParse(_branchesController.text) ?? 1;
    _branches.clear();

    for (int i = 0; i < numberOfBranches; i++) {
      _branches.add(_createBranchData(i + 1));
    }
  }

  Map<String, dynamic> _createBranchData(int branchNumber) {
    return {
      'branchNumber': branchNumber,
      'nameController': TextEditingController(),
      'usersController': TextEditingController(text: branchNumber == 1 ? '1' : '2'),
      'addressSameAsSignup': branchNumber == 1,
      'contactSameAsSignup': branchNumber == 1,
      'addressControllers': {
        'address1': TextEditingController(),
        'address2': TextEditingController(),
        'city': TextEditingController(),
        'state': TextEditingController(),
        'zip': TextEditingController(),
        'country': TextEditingController(),
      },
      'contactControllers': {
        'designation': TextEditingController(),
        'department': TextEditingController(),
        'officeNumber': TextEditingController(),
        'mobileNumber': TextEditingController(),
        'website': TextEditingController(),
      },
      'operationalTimes': [
        {'days': 'Weekdays', 'startTime': '09:00', 'endTime': '18:00'},
        if (branchNumber > 1)
          {'days': 'Weekend', 'startTime': '09:00', 'endTime': '18:00'},
      ],
      'sports': <String>[],
    };
  }

  void _onBranchesChanged() {
    final numberOfBranches = int.tryParse(_branchesController.text) ?? 1;

    if (numberOfBranches != _branches.length) {
      setState(() {
        if (numberOfBranches > _branches.length) {
          // Add new branches
          for (int i = _branches.length; i < numberOfBranches; i++) {
            _branches.add(_createBranchData(i + 1));
          }
          // If checkbox is checked, sync sports from first branch to new branches
          if (_allSportsSameForBranches && _branches.isNotEmpty) {
            final firstBranchSports = _branches[0]['sports'] as List<String>;
            for (int i = 1; i < _branches.length; i++) {
              _branches[i]['sports'] = List<String>.from(firstBranchSports);
            }
          }
        } else {
          // Remove excess branches
          for (int i = _branches.length - 1; i >= numberOfBranches; i--) {
            // Dispose controllers before removing
            var branch = _branches[i];
            if (branch['nameController'] != null) {
              (branch['nameController'] as TextEditingController).dispose();
            }
            if (branch['usersController'] != null) {
              (branch['usersController'] as TextEditingController).dispose();
            }
            if (branch['addressControllers'] != null) {
              for (var controller in branch['addressControllers'].values) {
                (controller as TextEditingController).dispose();
              }
            }
            if (branch['contactControllers'] != null) {
              for (var controller in branch['contactControllers'].values) {
                (controller as TextEditingController).dispose();
              }
            }
            _branches.removeAt(i);
          }
        }
      });
    }
  }

  Future<void> _submitClubRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    // Get user_id from storage (saved as String, need to parse to int)
    final userIdString = await _storageService.getString('user_id');
    if (userIdString == null || userIdString.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User ID not found. Please sign up first.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    final userId = int.tryParse(userIdString);
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid user ID. Please sign up again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final numberOfBranches = int.tryParse(_branchesController.text) ?? 1;
      final firstBranch = _branches[0];
      
      // Get signup data from storage (we'll need to fetch this or pass it)
      // For now, we'll use the first branch's data for the main club
      final nameController = firstBranch['nameController'] as TextEditingController;
      final usersController = firstBranch['usersController'] as TextEditingController;
      final addressControllers = firstBranch['addressControllers'] as Map<String, TextEditingController>;
      final contactControllers = firstBranch['contactControllers'] as Map<String, TextEditingController>;
      final operationalTimes = firstBranch['operationalTimes'] as List<Map<String, String>>;
      final sports = firstBranch['sports'] as List<String>;

      // Validate required fields
      if (nameController.text.trim().isEmpty) {
        throw ValidationException('Club name is required');
      }
      if (sports.isEmpty) {
        throw ValidationException('Please select at least one sport');
      }
      if (operationalTimes.isEmpty) {
        throw ValidationException('Please add at least one operational time slot');
      }

      // Parse phone numbers
      final officePhoneParsed = PhoneParser.parsePhoneNumber(contactControllers['officeNumber']!.text);
      final mobilePhoneParsed = PhoneParser.parsePhoneNumber(contactControllers['mobileNumber']!.text);

      // Build operational details
      final operationalDetails = operationalTimes.map((time) {
        return ClubOperationalDetail(
          openDays: time['days']!,
          clubStartTime: time['startTime']!,
          clubEndTime: time['endTime']!,
        );
      }).toList();

      if (numberOfBranches == 1) {
        // Single branch - use signup-club API
        final isAddressSame = firstBranch['addressSameAsSignup'] as bool;
        final isContactSame = firstBranch['contactSameAsSignup'] as bool;
        
        final request = ClubSignupRequest(
          userRole: 'club',
          clubName: nameController.text.trim(),
          noOfUsers: int.tryParse(usersController.text) ?? 1,
          isAddressIsSameAsUser: isAddressSame ? 1 : 0,
          addressLine1: addressControllers['address1']!.text.trim(),
          addressLine2: addressControllers['address2']!.text.trim(),
          city: addressControllers['city']!.text.trim(),
          state: addressControllers['state']!.text.trim(),
          zipcode: addressControllers['zip']!.text.trim(),
          country: addressControllers['country']!.text.trim(),
          isContactDetailsIsSameUser: isContactSame ? 1 : 0,
          designation: contactControllers['designation']!.text.trim(),
          department: contactControllers['department']!.text.trim(),
          officePhoneExt: officePhoneParsed['ext'] ?? '',
          officePhone: officePhoneParsed['number'] ?? '',
          mobilePhoneExt: mobilePhoneParsed['ext'] ?? '',
          mobilePhone: mobilePhoneParsed['number'] ?? '',
          companyWebsite: contactControllers['website']!.text.trim(),
          sportsIsSameAsUser: 0, // We're providing sports
          sportsNames: sports,
          operationalDetails: operationalDetails,
        );

        final response = await _authRepository.clubSignup(request);
        
        // Save club_id to storage
        await _storageService.saveInt('club_id', response.clubId);

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClubMembershipPlanPage()),
          );
        }
      } else {
        // Multiple branches - use signup-club for first, then signup-club-branch for rest
        // Step 1: Create main club
        final isAddressSame = firstBranch['addressSameAsSignup'] as bool;
        final isContactSame = firstBranch['contactSameAsSignup'] as bool;
        
        final step1Request = ClubSignupRequest(
          userRole: 'club',
          clubName: nameController.text.trim(),
          noOfUsers: int.tryParse(usersController.text) ?? 1,
          isAddressIsSameAsUser: isAddressSame ? 1 : 0,
          addressLine1: addressControllers['address1']!.text.trim(),
          addressLine2: addressControllers['address2']!.text.trim(),
          city: addressControllers['city']!.text.trim(),
          state: addressControllers['state']!.text.trim(),
          zipcode: addressControllers['zip']!.text.trim(),
          country: addressControllers['country']!.text.trim(),
          isContactDetailsIsSameUser: isContactSame ? 1 : 0,
          designation: contactControllers['designation']!.text.trim(),
          department: contactControllers['department']!.text.trim(),
          officePhoneExt: officePhoneParsed['ext'] ?? '',
          officePhone: officePhoneParsed['number'] ?? '',
          mobilePhoneExt: mobilePhoneParsed['ext'] ?? '',
          mobilePhone: mobilePhoneParsed['number'] ?? '',
          companyWebsite: contactControllers['website']!.text.trim(),
          sportsIsSameAsUser: 0,
          sportsNames: sports,
          operationalDetails: operationalDetails,
        );

        final step1Response = await _authRepository.clubSignup(step1Request);
        
        // Save club_id to storage
        await _storageService.saveInt('club_id', step1Response.clubId);

        // Step 2: Create additional branches
        final additionalBranches = _branches.skip(1).map((branch) {
          final branchNameController = branch['nameController'] as TextEditingController;
          final branchUsersController = branch['usersController'] as TextEditingController;
          final branchAddressControllers = branch['addressControllers'] as Map<String, TextEditingController>;
          final branchContactControllers = branch['contactControllers'] as Map<String, TextEditingController>;
          final branchOperationalTimes = branch['operationalTimes'] as List<Map<String, String>>;
          final isAddressSame = branch['addressSameAsSignup'] as bool;
          final isContactSame = branch['contactSameAsSignup'] as bool;

          // Parse phone numbers
          final branchOfficePhoneParsed = PhoneParser.parsePhoneNumber(branchContactControllers['officeNumber']!.text);
          final branchMobilePhoneParsed = PhoneParser.parsePhoneNumber(branchContactControllers['mobileNumber']!.text);

          // Build operational details
          final branchOperationalDetails = branchOperationalTimes.map((time) {
            return ClubOperationalDetail(
              openDays: time['days']!,
              clubStartTime: time['startTime']!,
              clubEndTime: time['endTime']!,
            );
          }).toList();

          return ClubBranchData(
            clubName: branchNameController.text.trim(),
            numberOfUsers: int.tryParse(branchUsersController.text) ?? 1,
            isAddressSameAsUser: isAddressSame ? 1 : 0,
            addressLine1: isAddressSame ? null : branchAddressControllers['address1']!.text.trim().isEmpty ? null : branchAddressControllers['address1']!.text.trim(),
            addressLine2: isAddressSame ? null : (branchAddressControllers['address2']!.text.trim().isEmpty ? null : branchAddressControllers['address2']!.text.trim()),
            city: isAddressSame ? null : (branchAddressControllers['city']!.text.trim().isEmpty ? null : branchAddressControllers['city']!.text.trim()),
            state: isAddressSame ? null : (branchAddressControllers['state']!.text.trim().isEmpty ? null : branchAddressControllers['state']!.text.trim()),
            zipCode: isAddressSame ? null : (branchAddressControllers['zip']!.text.trim().isEmpty ? null : branchAddressControllers['zip']!.text.trim()),
            country: isAddressSame ? null : (branchAddressControllers['country']!.text.trim().isEmpty ? null : branchAddressControllers['country']!.text.trim()),
            isContactSameAsUser: isContactSame ? 1 : 0,
            designation: isContactSame ? null : (branchContactControllers['designation']!.text.trim().isEmpty ? null : branchContactControllers['designation']!.text.trim()),
            department: isContactSame ? null : (branchContactControllers['department']!.text.trim().isEmpty ? null : branchContactControllers['department']!.text.trim()),
            officePhoneExt: isContactSame ? null : ((branchOfficePhoneParsed['ext'] ?? '').isEmpty ? null : branchOfficePhoneParsed['ext']),
            officePhone: isContactSame ? null : ((branchOfficePhoneParsed['number'] ?? '').isEmpty ? null : branchOfficePhoneParsed['number']),
            mobilePhoneExt: isContactSame ? null : ((branchMobilePhoneParsed['ext'] ?? '').isEmpty ? null : branchMobilePhoneParsed['ext']),
            mobilePhone: isContactSame ? null : ((branchMobilePhoneParsed['number'] ?? '').isEmpty ? null : branchMobilePhoneParsed['number']),
            companyWebsite: isContactSame ? null : (branchContactControllers['website']!.text.trim().isEmpty ? null : branchContactControllers['website']!.text.trim()),
            operationalDetails: branchOperationalDetails,
          );
        }).toList();

        final step2Request = ClubBranchSignupRequest(branches: additionalBranches);
        await _authRepository.clubBranchSignup(step2Request);

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClubMembershipPlanPage()),
          );
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on ValidationException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
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
          'Club Registration',
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

              // Club Details Section
              _buildSectionCard(
                title: 'Club Details',
                titleColor: Colors.white,
                titleBackground: const Color(0xFF8BB6D9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _branchesController,
                      label: 'Number Of Branches',
                      hint: '2',
                      keyboardType: TextInputType.number,
                      suffixText:
                          '(It Will Be Paid Service To Use This Platform For More Than 1 Branch)',
                    ),
                    const SizedBox(height: 20),
                    _buildCheckboxOption(
                      'All Sports Are Same For Each Branch',
                      _allSportsSameForBranches,
                      (value) {
                        setState(() {
                          _allSportsSameForBranches = value!;
                          // If checked, sync sports from first branch to all other branches
                          if (_allSportsSameForBranches && _branches.isNotEmpty) {
                            final firstBranchSports = _branches[0]['sports'] as List<String>;
                            for (int i = 1; i < _branches.length; i++) {
                              _branches[i]['sports'] = List<String>.from(firstBranchSports);
                            }
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dynamic Branch Sections
              if (_branches.isNotEmpty)
                ..._branches.asMap().entries.map((entry) {
                  final index = entry.key;
                  final branch = entry.value;
                  // Ensure branch has required controllers before building
                  if (branch['nameController'] == null || 
                      branch['usersController'] == null ||
                      branch['addressControllers'] == null ||
                      branch['contactControllers'] == null) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      _buildBranchSection(branch),
                      if (index < _branches.length - 1)
                        const SizedBox(height: 16),
                    ],
                  );
                }).toList(),

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
    switch (title) {
      case 'Club Details':
        return Icons.business;
      case 'Branch 1 Details':
      case 'Branch 2 Details':
        return Icons.account_tree;
      default:
        return Icons.info;
    }
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
          activeColor: const Color(0xFF667EEA),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
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
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
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

  Widget _buildBranchSection(Map<String, dynamic> branchData) {
    final branchNumber = branchData['branchNumber'] as int;
    final nameController = branchData['nameController'] as TextEditingController?;
    final usersController = branchData['usersController'] as TextEditingController?;
    final addressControllers =
        branchData['addressControllers'] as Map<String, TextEditingController>?;
    final contactControllers =
        branchData['contactControllers'] as Map<String, TextEditingController>?;

    // Safety check - if controllers are null, return empty container
    if (nameController == null || usersController == null || 
        addressControllers == null || contactControllers == null) {
      return const SizedBox.shrink();
    }

    return _buildSectionCard(
      title: 'Branch $branchNumber Details',
      titleColor: Colors.white,
      titleBackground: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: nameController,
            label: 'Club Name',
            hint: 'Enter club name',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: usersController,
            label: 'Number Of Users',
            hint: 'Enter number of users',
            keyboardType: TextInputType.number,
            suffixText: branchNumber > 1
                ? '(It Is A Paid Service For More Than 1 User/Branch. You Will Be Allowed To Add Users From Your Admin Panel After Subscription.)'
                : null,
          ),
          const SizedBox(height: 16),
          // Address Section with checkbox
          _buildCheckboxOption(
            'Address Is Same As Sign Up Address?',
            branchData['addressSameAsSignup'] as bool,
            (value) => setState(() {
              branchData['addressSameAsSignup'] = value!;
            }),
          ),
          if (!(branchData['addressSameAsSignup'] as bool)) ...[
            const SizedBox(height: 16),
            _buildAddressSubSection(addressControllers),
          ],
          const SizedBox(height: 16),
          // Contact Details Section with checkbox
          _buildCheckboxOption(
            'Contact Details Is Same As Sign Up Contact Details?',
            branchData['contactSameAsSignup'] as bool,
            (value) => setState(() {
              branchData['contactSameAsSignup'] = value!;
            }),
          ),
          if (!(branchData['contactSameAsSignup'] as bool)) ...[
            const SizedBox(height: 16),
            _buildContactDetailsSubSection(contactControllers),
          ],
          const SizedBox(height: 16),
          _buildClubOperationalDetailsSubSection(branchData),
          const SizedBox(height: 16),
          _buildSportsSubSection(branchData),
        ],
      ),
    );
  }

  Widget _buildAddressSubSection(
    Map<String, TextEditingController> controllers,
  ) {
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
          controller: controllers['address1']!,
          label: 'Address 1',
          hint: 'Enter address line 1',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: controllers['address2']!,
          label: 'Address 2',
          hint: 'Enter address line 2',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                label: 'City',
                value: controllers['city']!.text,
                items: ['Xyz', 'City 1', 'City 2'],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      controllers['city']!.text = value;
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdownField(
                label: 'State',
                value: controllers['state']!.text,
                items: ['Xyz', 'State 1', 'State 2'],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      controllers['state']!.text = value;
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
                controller: controllers['zip']!,
                label: 'Zip Code',
                hint: 'Enter zip code',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdownField(
                label: 'Country',
                value: controllers['country']!.text,
                items: ['Xyz', 'Country 1', 'Country 2'],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      controllers['country']!.text = value;
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

  Widget _buildContactDetailsSubSection(
    Map<String, TextEditingController> controllers,
  ) {
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
                controller: controllers['designation']!,
                label: 'Designation',
                hint: 'Enter designation',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: controllers['department']!,
                label: 'Department',
                hint: 'Enter department',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: controllers['officeNumber']!,
                label: 'Office Number',
                hint: '+91 - 1234567890',
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: controllers['mobileNumber']!,
                label: 'Mobile Number',
                hint: '+91 - 9876543210',
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: controllers['website']!,
          label: 'Company Website',
          hint: 'Enter website URL',
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _buildClubOperationalDetailsSubSection(
    Map<String, dynamic> branchData,
  ) {
    final operationalTimes =
        branchData['operationalTimes'] as List<Map<String, String>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Club Operational Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      (branchData['operationalTimes'] as List<Map<String, String>>)
                        .add({'days': 'Weekdays', 'startTime': '00:00', 'endTime': '00:00'});
                    });
                  },
                child: const Text(
                  '+ Days & Time',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Time slots
        ...operationalTimes.asMap().entries.map((entry) {
          final index = entry.key;
          final timeSlot = entry.value;
          return Column(
            children: [
              _buildTimeSlotCard(
                branchData,
                index,
                'Time ${index + 1}',
                timeSlot['days']!,
                timeSlot['startTime']!,
                timeSlot['endTime']!,
              ),
              if (index < operationalTimes.length - 1)
                const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTimeSlotCard(
    Map<String, dynamic> branchData,
    int timeSlotIndex,
    String timeLabel,
    String openDays,
    String startTime,
    String endTime,
  ) {
    final operationalTimes =
        branchData['operationalTimes'] as List<Map<String, String>>;
    final timeSlot = operationalTimes[timeSlotIndex];
    final dayOptions = ['Weekdays', 'Weekend', 'All Days', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    // Parse times for display
    final startTimeParts = startTime.split(':');
    final startTimeOfDay = TimeOfDay(
      hour: int.tryParse(startTimeParts[0]) ?? 9,
      minute: int.tryParse(startTimeParts[1]) ?? 0,
    );
    final endTimeParts = endTime.split(':');
    final endTimeOfDay = TimeOfDay(
      hour: int.tryParse(endTimeParts[0]) ?? 18,
      minute: int.tryParse(endTimeParts[1]) ?? 0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with label and delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  timeLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (operationalTimes.length > 1)
                InkWell(
                  onTap: () {
                    setState(() {
                      operationalTimes.removeAt(timeSlotIndex);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // First Row: Day Selection
          _buildDropdownField(
            label: 'Open Days',
            value: openDays,
            items: dayOptions,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  timeSlot['days'] = value;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          // Second Row: Time Selection
          Row(
            children: [
              Expanded(
                child: _buildTimePickerField(
                  label: 'Start Time',
                  time: startTimeOfDay,
                  onTimeSelected: (time) {
                    if (time != null && mounted) {
                      setState(() {
                        final timeString =
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                        timeSlot['startTime'] = timeString;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimePickerField(
                  label: 'End Time',
                  time: endTimeOfDay,
                  onTimeSelected: (time) {
                    if (time != null && mounted) {
                      setState(() {
                        final timeString =
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                        timeSlot['endTime'] = timeString;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerField({
    required String label,
    required TimeOfDay time,
    required Function(TimeOfDay?) onTimeSelected,
  }) {
    final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked != null && mounted) {
              onTimeSelected(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeString,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  size: 18,
                  color: Color(0xFF64748B),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildSportsSubSection(Map<String, dynamic> branchData) {
    final sports = branchData['sports'] as List<String>;
    final branchNumber = branchData['branchNumber'] as int;
    final isDisabled = _allSportsSameForBranches && branchNumber > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Sports',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isDisabled) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Synced with Branch 1',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: isDisabled
              ? null
              : () async {
                  final result = await showDialog<List<String>>(
                    context: context,
                    builder: (ctx) => SportsMultiSelect(
                      allSports: _allSports,
                      initialSelected: sports,
                    ),
                  );
                  if (result != null && mounted) {
                    setState(() {
                      branchData['sports'] = result;
                      // If checkbox is checked and this is branch 1, sync to all other branches
                      if (_allSportsSameForBranches && branchNumber == 1) {
                        for (int i = 1; i < _branches.length; i++) {
                          _branches[i]['sports'] = List<String>.from(result);
                        }
                      }
                    });
                  }
                },
          child: Opacity(
            opacity: isDisabled ? 0.6 : 1.0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDisabled
                      ? const Color(0xFFE2E8F0).withOpacity(0.5)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: sports.isNotEmpty
                          ? sports.map((sport) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF667EEA).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF667EEA)),
                                ),
                                child: Text(
                                  sport,
                                  style: const TextStyle(
                                    color: Color(0xFF667EEA),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }).toList()
                          : [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Select sports',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: isDisabled
                        ? const Color(0xFF64748B).withOpacity(0.5)
                        : const Color(0xFF64748B),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    // Validate value - must be non-empty and exist in items list
    final String? validValue = (value.isNotEmpty && items.contains(value)) ? value : null;
    
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
            hint: const Text(
              'Select',
              style: TextStyle(color: Colors.grey),
            ),
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
              onPressed: _isLoading ? null : () => Navigator.pop(context),
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
              onPressed: _isLoading ? null : () => Navigator.pop(context),
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
              onPressed: _isLoading ? null : _submitClubRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
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
                      height: 20,
                      width: 20,
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
                        Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
