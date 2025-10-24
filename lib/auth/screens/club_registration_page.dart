import 'package:flutter/material.dart';
import 'membership_plan_page.dart';

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
  final List<String> _selectedSports = [
    'Tennis',
    'Baseball',
    'Cricket',
    'Basketball',
  ];

  // Default Address Controllers (for signup address)
  final _defaultAddress1Controller = TextEditingController(text: 'Xyz');
  final _defaultAddress2Controller = TextEditingController(text: 'Xyz');
  final _defaultCityController = TextEditingController(text: 'Xyz');
  final _defaultStateController = TextEditingController(text: 'Xyz');
  final _defaultZipController = TextEditingController(text: 'Xyz');
  final _defaultCountryController = TextEditingController(text: 'Xyz');

  // Default Contact Details Controllers (for signup contact)
  final _defaultDesignationController = TextEditingController();
  final _defaultDepartmentController = TextEditingController();
  final _defaultOfficeNumberController = TextEditingController(
    text: '+91 - 9876543210',
  );
  final _defaultMobileNumberController = TextEditingController(
    text: '+91 - 9876543210',
  );
  final _defaultWebsiteController = TextEditingController(
    text: 'https://abc.com',
  );

  @override
  void initState() {
    super.initState();
    _initializeBranches();
    _branchesController.addListener(_onBranchesChanged);
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
    _defaultOfficeNumberController.dispose();
    _defaultMobileNumberController.dispose();
    _defaultWebsiteController.dispose();

    // Dispose all branch controllers
    for (var branch in _branches) {
      if (branch['addressControllers'] != null) {
        for (var controller in branch['addressControllers']) {
          controller.dispose();
        }
      }
      if (branch['contactControllers'] != null) {
        for (var controller in branch['contactControllers']) {
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
        'address1': TextEditingController(text: 'Xyz'),
        'address2': TextEditingController(text: 'Xyz'),
        'city': TextEditingController(text: 'Xyz'),
        'state': TextEditingController(text: 'Xyz'),
        'zip': TextEditingController(text: 'Xyz'),
        'country': TextEditingController(text: 'Xyz'),
      },
      'contactControllers': {
        'designation': TextEditingController(),
        'department': TextEditingController(),
        'officeNumber': TextEditingController(text: '+91 - 9876543210'),
        'mobileNumber': TextEditingController(text: '+91 - 9876543210'),
        'website': TextEditingController(text: 'https://abc.com'),
      },
      'operationalTimes': [
        {'days': 'Weekdays', 'startTime': '00:00', 'endTime': '00:00'},
        if (branchNumber > 1)
          {'days': 'Weekend', 'startTime': '00:00', 'endTime': '00:00'},
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
          _buildCheckboxOption(
            'Address Is Same As Sign Up Address?',
            branchData['addressSameAsSignup'] as bool,
            (value) => setState(() {
              branchData['addressSameAsSignup'] = value!;
            }),
          ),

          // Address Section (if not same as signup)
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

          // Contact Details Section (if not same as signup)
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
                onChanged: (value) => controllers['city']!.text = value!,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdownField(
                label: 'State',
                value: controllers['state']!.text,
                items: ['Xyz', 'State 1', 'State 2'],
                onChanged: (value) => controllers['state']!.text = value!,
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
                onChanged: (value) => controllers['country']!.text = value!,
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
                hint: 'Enter office number',
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: controllers['mobileNumber']!,
                label: 'Mobile Number',
                hint: 'Enter mobile number',
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
                child: const Text(
                  '+ Days & Time',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
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
    String timeLabel,
    String openDays,
    String startTime,
    String endTime,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Open Days',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(openDays, style: const TextStyle(fontSize: 14)),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF64748B),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Club Time',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Text(
                              startTime,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFF667EEA),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Text(
                              endTime,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: sports.map((sport) {
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
                          Container(
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
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
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
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
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
