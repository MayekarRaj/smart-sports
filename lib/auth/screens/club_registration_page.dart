import 'package:flutter/material.dart';
import 'membership_plan_page.dart';
import '../widgets/sports_multi_select.dart';
import '../widgets/city_search_field.dart';
import '../widgets/phone_code_dropdown.dart';
import '../widgets/rounded_text_field.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/models/api_models.dart';

class ClubRegistrationPage extends StatefulWidget {
  const ClubRegistrationPage({super.key});

  @override
  State<ClubRegistrationPage> createState() => _ClubRegistrationPageState();
}

class _ClubRegistrationPageState extends State<ClubRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Club Details Controllers
  final _branchesController = TextEditingController(text: '1');
  bool _allSportsSameForBranches = false;

  // Branch Data - Dynamic list to store all branches
  List<Map<String, dynamic>> _branches = [];

  // Sports data
  List<String> _selectedSports = [];
  List<String> _allSports = [];
  bool _isLoadingSports = false;
  final AuthRepository _authRepository = AuthRepository();

  // Club days data
  List<MstClubDay> _clubDays = [];
  bool _isLoadingClubDays = false;

  // Default Address Controllers (for signup address)
  final _defaultAddress1Controller = TextEditingController();
  final _defaultAddress2Controller = TextEditingController();
  final _defaultCityController = TextEditingController();
  final _defaultStateController = TextEditingController();
  final _defaultZipController = TextEditingController();
  final _defaultCountryController = TextEditingController();

  // Default Contact Details Controllers (for signup contact)
  final _defaultDesignationController = TextEditingController();
  final _defaultDepartmentController = TextEditingController();
  final _defaultOfficePhoneCodeController = TextEditingController();
  final _defaultOfficeNumberController = TextEditingController();
  final _defaultMobilePhoneCodeController = TextEditingController();
  final _defaultMobileNumberController = TextEditingController();
  final _defaultWebsiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeBranches();
    _migrateBranchesToNewStructure(); // Ensure all branches have new controllers
    _branchesController.addListener(_onBranchesChanged);
    _loadSports();
    _loadClubDays();
  }

  /// Migrate existing branches to include new phone code controllers
  void _migrateBranchesToNewStructure() {
    for (var branch in _branches) {
      final contactControllers = branch['contactControllers'] as Map<String, TextEditingController>?;
      if (contactControllers != null) {
        // Add phone code controllers if they don't exist
        if (!contactControllers.containsKey('officePhoneCode')) {
          contactControllers['officePhoneCode'] = TextEditingController();
        }
        if (!contactControllers.containsKey('mobilePhoneCode')) {
          contactControllers['mobilePhoneCode'] = TextEditingController();
        }
        // Update existing phone number controllers if they have old format
        if (contactControllers.containsKey('officeNumber')) {
          final officeNumber = contactControllers['officeNumber']!;
          if (officeNumber.text.contains('+') && officeNumber.text.contains('-')) {
            // Extract phone code from old format like "+91 - 9876543210"
            final parts = officeNumber.text.split(' - ');
            if (parts.length == 2) {
              contactControllers['officePhoneCode']!.text = parts[0].replaceAll('+', '');
              officeNumber.text = parts[1];
            }
          }
        }
        if (contactControllers.containsKey('mobileNumber')) {
          final mobileNumber = contactControllers['mobileNumber']!;
          if (mobileNumber.text.contains('+') && mobileNumber.text.contains('-')) {
            // Extract phone code from old format like "+91 - 9876543210"
            final parts = mobileNumber.text.split(' - ');
            if (parts.length == 2) {
              contactControllers['mobilePhoneCode']!.text = parts[0].replaceAll('+', '');
              mobileNumber.text = parts[1];
            }
          }
        }
      }
      // Add cityId if it doesn't exist
      if (!branch.containsKey('cityId')) {
        branch['cityId'] = null;
      }
    }
  }

  Future<void> _loadClubDays() async {
    if (!mounted) return;
    
    setState(() {
      _isLoadingClubDays = true;
    });

    try {
      final response = await _authRepository.getClubDays(
        perPage: 1000,
        orderBy: 'id|ASC',
        isActive: 1,
        page: 1,
      );

      if (mounted) {
        setState(() {
          _clubDays = response.data.data;
          _isLoadingClubDays = false;
          // Update default days in existing branches if they're still using hardcoded values
          for (var branch in _branches) {
            final operationalTimes = branch['operationalTimes'] as List<Map<String, dynamic>>;
            for (var timeSlot in operationalTimes) {
              if (timeSlot['day'] is String) {
                final dayStr = timeSlot['day'] as String;
                if (dayStr == 'Weekdays' || dayStr == 'Weekend' || dayStr == 'Monday') {
                  if (_clubDays.isNotEmpty) {
                    timeSlot['day'] = _clubDays.first.name;
                  }
                }
              }
              // Migrate old string-based times to TimeOfDay if needed
              if (timeSlot['startTime'] is String) {
                final timeStr = timeSlot['startTime'] as String;
                final parts = timeStr.split(':');
                if (parts.length == 2) {
                  timeSlot['startTime'] = TimeOfDay(
                    hour: int.tryParse(parts[0]) ?? 9,
                    minute: int.tryParse(parts[1]) ?? 0,
                  );
                } else {
                  timeSlot['startTime'] = const TimeOfDay(hour: 9, minute: 0);
                }
              }
              if (timeSlot['endTime'] is String) {
                final timeStr = timeSlot['endTime'] as String;
                final parts = timeStr.split(':');
                if (parts.length == 2) {
                  timeSlot['endTime'] = TimeOfDay(
                    hour: int.tryParse(parts[0]) ?? 17,
                    minute: int.tryParse(parts[1]) ?? 0,
                  );
                } else {
                  timeSlot['endTime'] = const TimeOfDay(hour: 17, minute: 0);
                }
              }
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingClubDays = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load club days: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadSports() async {
    if (!mounted) return;
    
    setState(() {
      _isLoadingSports = true;
    });

    try {
      final response = await _authRepository.getSportsList(
        perPage: 1000,
        orderBy: 'id|ASC',
        isActive: 1,
        page: 1,
      );

      if (mounted) {
        setState(() {
          _allSports = response.data.data
              .map((sport) => sport.sportsName)
              .toList();
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
    _defaultAddress1Controller.dispose();
    _defaultAddress2Controller.dispose();
    _defaultCityController.dispose();
    _defaultStateController.dispose();
    _defaultZipController.dispose();
    _defaultCountryController.dispose();
    _defaultDesignationController.dispose();
    _defaultDepartmentController.dispose();
    _defaultOfficePhoneCodeController.dispose();
    _defaultOfficeNumberController.dispose();
    _defaultMobilePhoneCodeController.dispose();
    _defaultMobileNumberController.dispose();
    _defaultWebsiteController.dispose();

    // Dispose all branch controllers
    for (var branch in _branches) {
      if (branch['addressControllers'] != null) {
        for (var controller in branch['addressControllers'].values) {
          controller.dispose();
        }
      }
      if (branch['contactControllers'] != null) {
        for (var controller in branch['contactControllers'].values) {
          controller.dispose();
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
      'name': 'Branch $branchNumber',
      'users': branchNumber == 1 ? 1 : 2,
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
      'cityId': null, // Store selected city ID
      'contactControllers': {
        'designation': TextEditingController(),
        'department': TextEditingController(),
        'officePhoneCode': TextEditingController(),
        'officeNumber': TextEditingController(),
        'mobilePhoneCode': TextEditingController(),
        'mobileNumber': TextEditingController(),
        'website': TextEditingController(),
      },
      'operationalTimes': [
        {
          'day': _clubDays.isNotEmpty ? _clubDays.first.name : 'Monday',
          'startTime': const TimeOfDay(hour: 9, minute: 0),
          'endTime': const TimeOfDay(hour: 17, minute: 0),
        },
        if (branchNumber > 1 && _clubDays.length > 1)
          {
            'day': _clubDays[1].name,
            'startTime': const TimeOfDay(hour: 9, minute: 0),
            'endTime': const TimeOfDay(hour: 17, minute: 0),
          },
      ],
      'sports': List<String>.from(_selectedSports),
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
        } else {
          // Remove excess branches
          for (int i = _branches.length - 1; i >= numberOfBranches; i--) {
            // Dispose controllers before removing
            var branch = _branches[i];
            if (branch['addressControllers'] != null) {
              for (var controller in branch['addressControllers'].values) {
                controller.dispose();
              }
            }
            if (branch['contactControllers'] != null) {
              for (var controller in branch['contactControllers'].values) {
                controller.dispose();
              }
            }
            _branches.removeAt(i);
          }
        }
      });
    }
  }

  void _submitClubRegistration() {
    if (!_formKey.currentState!.validate()) return;

    // Navigate directly to membership plan page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MembershipPlanPage()),
    );
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
                      (value) =>
                          setState(() => _allSportsSameForBranches = value!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dynamic Branch Sections
              ..._branches.asMap().entries.map((entry) {
                final index = entry.key;
                final branch = entry.value;
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
    final addressControllers =
        branchData['addressControllers'] as Map<String, TextEditingController>;
    final contactControllers =
        branchData['contactControllers'] as Map<String, TextEditingController>;

    return _buildSectionCard(
      title: 'Branch $branchNumber Details',
      titleColor: Colors.white,
      titleBackground: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: TextEditingController(
              text: branchData['name'].toString(),
            ),
            label: 'Club Name',
            hint: 'Enter club name',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: TextEditingController(
              text: branchData['users'].toString(),
            ),
            label: 'Number Of Users',
            hint: 'Enter number of users',
            keyboardType: TextInputType.number,
            suffixText: branchNumber > 1
                ? '(It Is A Paid Service For More Than 1 User/Branch. You Will Be Allowed To Add Users From Your Admin Panel After Subscription.)'
                : null,
          ),
          const SizedBox(height: 16),
          if (branchNumber == 1) ...[
            const SizedBox(height: 10),
            _buildAddressSubSection(addressControllers),
            const SizedBox(height: 16),
            _buildContactDetailsSubSection(contactControllers),
          ] else ...[
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
        CitySearchField(
          cityController: controllers['city']!,
          stateController: controllers['state']!,
          countryController: controllers['country']!,
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
              child: RoundedTextField(
                controller: controllers['state']!,
                hint: 'State',
                enabled: true,
                readOnly: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RoundedTextField(
          controller: controllers['country']!,
          hint: 'Country',
          enabled: true,
          readOnly: true,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Office Number',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      final controller = controllers['officePhoneCode'] as TextEditingController?;
                      return PhoneCodeDropdown(
                        value: controller?.text.isNotEmpty == true ? controller!.text : null,
                        onChanged: (value) {
                          controller?.text = value ?? '';
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controllers['officeNumber']!,
                    label: '',
                    hint: 'Enter office number',
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mobile Number',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      final controller = controllers['mobilePhoneCode'] as TextEditingController?;
                      return PhoneCodeDropdown(
                        value: controller?.text.isNotEmpty == true ? controller!.text : null,
                        onChanged: (value) {
                          controller?.text = value ?? '';
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controllers['mobileNumber']!,
                    label: '',
                    hint: 'Enter mobile number',
                    keyboardType: TextInputType.phone,
                  ),
                ],
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
        branchData['operationalTimes'] as List<Map<String, dynamic>>;

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
              InkWell(
                onTap: () {
                  setState(() {
                    operationalTimes.add({
                      'day': _clubDays.isNotEmpty ? _clubDays.first.name : 'Monday',
                      'startTime': const TimeOfDay(hour: 9, minute: 0),
                      'endTime': const TimeOfDay(hour: 17, minute: 0),
                    });
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11998E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Color(0xFF11998E), size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Day & Time',
                        style: TextStyle(
                          color: Color(0xFF11998E),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Service day time rows
        ...operationalTimes.asMap().entries.map((entry) {
          final index = entry.key;
          final timeSlot = entry.value;
          return _buildServiceDayTimeRow(
            timeSlot,
            branchData,
            index,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildServiceDayTimeRow(
    Map<String, dynamic> timeSlot,
    Map<String, dynamic> branchData,
    int dayIndex,
  ) {
    final operationalTimes = branchData['operationalTimes'] as List<Map<String, dynamic>>;
    
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
          // First Row: Day Selection
          Row(
            children: [
              Expanded(
                child: _isLoadingClubDays
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Service Day',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 12),
                                Text('Loading...', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      )
                    : _clubDays.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Service Day',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: const Text(
                                  'No days available',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          )
                        : _buildDropdownField(
                            label: 'Service Day',
                            value: () {
                              final day = timeSlot['day'] as String?;
                              return _clubDays.any((d) => d.name == day)
                                  ? day
                                  : _clubDays.isNotEmpty
                                      ? _clubDays.first.name
                                      : 'Monday';
                            }(),
                            items: _clubDays.map((day) => day.name).toList(),
                            onChanged: (value) {
                              setState(() {
                                timeSlot['day'] = value!;
                              });
                            },
                          ),
              ),
              const SizedBox(width: 12),
              // Remove button (only show if more than one day)
              if (operationalTimes.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        operationalTimes.removeAt(dayIndex);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
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
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Second Row: Time Selection
          Row(
            children: [
              Expanded(
                child: _buildTimePickerField(
                  label: 'Start Time',
                  time: timeSlot['startTime'] as TimeOfDay?,
                  onTimeSelected: (time) {
                    setState(() {
                      timeSlot['startTime'] = time;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimePickerField(
                  label: 'End Time',
                  time: timeSlot['endTime'] as TimeOfDay?,
                  onTimeSelected: (time) {
                    setState(() {
                      timeSlot['endTime'] = time;
                    });
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
    required TimeOfDay? time,
    required Function(TimeOfDay?) onTimeSelected,
  }) {
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
              initialTime: time ?? const TimeOfDay(hour: 9, minute: 0),
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
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    time != null
                        ? '${time!.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                        : 'HH:MM',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: time != null ? Colors.black87 : Colors.grey[400],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Icon(
                  Icons.access_time,
                  color: Colors.grey[600],
                  size: 18,
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
                        content: Text('No sports available. Please try again later.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
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
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Text('Loading sports...', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: sports.isEmpty
                              ? [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('Select sports', style: TextStyle(color: Colors.grey)),
                                  ),
                                ]
                              : sports.map((sport) {
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          sport,
                                          style: const TextStyle(
                                            color: Color(0xFF667EEA),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              sports.remove(sport);
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
    final validValue = value != null && value.isNotEmpty && items.contains(value) ? value : null;
    
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
            hint: Text(
              'Select',
              style: TextStyle(color: Colors.grey[400]),
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
              onPressed: _submitClubRegistration,
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
              child: const Row(
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
