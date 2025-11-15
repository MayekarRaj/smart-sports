import 'package:flutter/material.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/models/api_models.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/utils/phone_parser.dart';
import '../../core/services/storage_service.dart';
import 'family_details_page.dart';

class MemberRegistrationPage extends StatefulWidget {
  const MemberRegistrationPage({super.key});

  @override
  State<MemberRegistrationPage> createState() => _MemberRegistrationPageState();
}

class _MemberRegistrationPageState extends State<MemberRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final AuthRepository _authRepository = AuthRepository();
  final StorageService _storageService = StorageService();
  bool _isLoading = false;

  // Practice Plan
  String _practiceDays = 'Weekdays';
  String _practiceStartTime = '00:00';
  String _practiceEndTime = '00:00';

  // Preferred Club
  final List<String> _selectedClubs = [];
  final TextEditingController _selectClubsController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController(text: '5');
  String _distanceUnit = 'Km';

  // Employer Health Benefits
  bool _employerSupportsHealthBenefits = true;

  // Employer Detail
  final TextEditingController _employerController = TextEditingController();

  // HR Manager Details
  final TextEditingController _hrFirstNameController = TextEditingController(text: 'Peter');
  final TextEditingController _hrLastNameController = TextEditingController(text: 'Stillman');
  final TextEditingController _hrMailIdController = TextEditingController(text: 'Peter123@Gmail.Com');

  // Contact Details
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _officeNumberController = TextEditingController(text: '9876543210');
  final TextEditingController _mobileNumberController = TextEditingController(text: '9876543210');
  final TextEditingController _companyWebsiteController = TextEditingController(text: 'https://abc.com');
  String _officeCountryCode = '+91';
  String _mobileCountryCode = '+91';

  final List<String> _availableClubs = [
    'Urban Titans',
    'Steel Panthers',
    'Golden Eagles',
    'Thunder Hawks',
    'Crimson Wolves',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with sample selected clubs
    _selectedClubs.addAll(['Urban Titans', 'Steel Panthers']);
  }

  @override
  void dispose() {
    _selectClubsController.dispose();
    _distanceController.dispose();
    _employerController.dispose();
    _hrFirstNameController.dispose();
    _hrLastNameController.dispose();
    _hrMailIdController.dispose();
    _designationController.dispose();
    _departmentController.dispose();
    _officeNumberController.dispose();
    _mobileNumberController.dispose();
    _companyWebsiteController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showClubSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Clubs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            ..._availableClubs.map((club) {
              final isSelected = _selectedClubs.contains(club);
              return CheckboxListTile(
                title: Text(club),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      if (!_selectedClubs.contains(club)) {
                        _selectedClubs.add(club);
                      }
                    } else {
                      _selectedClubs.remove(club);
                    }
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        if (isStartTime) {
          _practiceStartTime = timeString;
        } else {
          _practiceEndTime = timeString;
        }
      });
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Parse phone numbers
      final officePhone = PhoneParser.parsePhoneNumber(_officeNumberController.text);
      final mobilePhone = PhoneParser.parsePhoneNumber(_mobileNumberController.text);

      // Convert practice days to practice plans
      // For now, if it's "Weekdays", we'll create entries for Monday-Friday
      // If it's "Weekend", we'll create entries for Saturday-Sunday
      // Otherwise, use the selected day as-is
      List<PracticePlan> practicePlans = [];
      
      if (_practiceDays == 'Weekdays') {
        // Create entries for Monday through Friday
        practicePlans = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
            .map((day) => PracticePlan(
                  practiceDay: day,
                  practiceStartTime: _practiceStartTime,
                  practiceEndTime: _practiceEndTime,
                ))
            .toList();
      } else if (_practiceDays == 'Weekend') {
        // Create entries for Saturday and Sunday
        practicePlans = ['Saturday', 'Sunday']
            .map((day) => PracticePlan(
                  practiceDay: day,
                  practiceStartTime: _practiceStartTime,
                  practiceEndTime: _practiceEndTime,
                ))
            .toList();
      } else {
        // Single day
        practicePlans = [
          PracticePlan(
            practiceDay: _practiceDays,
            practiceStartTime: _practiceStartTime,
            practiceEndTime: _practiceEndTime,
          )
        ];
      }

      // Build request
      final request = MemberSignupRequest(
        userRole: 'member',
        preferredClub: [1, 2, 3], // Static for now as requested
        isEmployerSupportHealthBenefits: _employerSupportsHealthBenefits ? 1 : 0,
        hrFirstname: _employerSupportsHealthBenefits ? _hrFirstNameController.text.trim() : '',
        hrLastname: _employerSupportsHealthBenefits ? _hrLastNameController.text.trim() : '',
        hrEmailid: _employerSupportsHealthBenefits ? _hrMailIdController.text.trim() : '',
        employerName: _employerSupportsHealthBenefits ? _employerController.text.trim() : '',
        hrDesignation: '', // Not in form, using empty string
        hrDepartment: '', // Not in form, using empty string
        designation: _employerSupportsHealthBenefits ? _designationController.text.trim() : '',
        department: _employerSupportsHealthBenefits ? _departmentController.text.trim() : '',
        officePhoneExt: _employerSupportsHealthBenefits ? (officePhone['ext'] ?? '') : '',
        officePhone: _employerSupportsHealthBenefits ? (officePhone['number'] ?? '') : '',
        mobilePhoneExt: _employerSupportsHealthBenefits ? (mobilePhone['ext'] ?? '') : '',
        mobilePhone: _employerSupportsHealthBenefits ? (mobilePhone['number'] ?? '') : '',
        companyWebsite: _employerSupportsHealthBenefits ? _companyWebsiteController.text.trim() : '',
        practicePlans: practicePlans,
      );

      final response = await _authRepository.memberSignup(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to family details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FamilyDetailsPage(),
          ),
        );
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit registration: ${e.toString()}'),
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
          'Club Details',
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
              // Practice Plan Section
              _buildSectionCard(
                title: 'Practice Plan',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdownField(
                      label: 'Practice Days',
                      value: _practiceDays,
                      items: ['Weekdays', 'Weekend', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
                      onChanged: (value) {
                        setState(() {
                          _practiceDays = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeField(
                            label: 'Practice Time',
                            value: _practiceStartTime,
                            onTap: () => _selectTime(context, true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF8BB6D9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTimeField(
                            label: '',
                            value: _practiceEndTime,
                            onTap: () => _selectTime(context, false),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Preferred Club Section
              _buildSectionCard(
                title: 'Preferred Club',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _selectClubsController,
                      label: 'Select Clubs',
                      hint: 'Select Clubs',
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      onTap: _showClubSelection,
                    ),
                    if (_selectedClubs.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedClubs.map((club) {
                          return Chip(
                            label: Text(club),
                            onDeleted: () {
                              setState(() {
                                _selectedClubs.remove(club);
                              });
                            },
                            deleteIcon: const Icon(Icons.close, size: 16),
                            backgroundColor: Colors.grey[200],
                            labelStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            controller: _distanceController,
                            label: 'Distance',
                            hint: '5',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDropdownField(
                            label: '',
                            value: _distanceUnit,
                            items: ['Km', 'Miles'],
                            onChanged: (value) {
                              setState(() {
                                _distanceUnit = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '(You Can Select The Clubs Within Your Preferred Radius From Below Map Too)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMapView(),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Employer Supports Health Benefits
              _buildSectionCard(
                title: '',
                child: Row(
                  children: [
                    Checkbox(
                      value: _employerSupportsHealthBenefits,
                      onChanged: (value) {
                        setState(() {
                          _employerSupportsHealthBenefits = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF8BB6D9),
                    ),
                    const Expanded(
                      child: Text(
                        'Employer Supports Health Benefits?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Employer Detail Section - Only show if checkbox is checked
              if (_employerSupportsHealthBenefits) ...[
                _buildSectionCard(
                  title: 'Employer Detail',
                  child: _buildTextField(
                    controller: _employerController,
                    label: 'Employer',
                    hint: 'Company Name',
                  ),
                ),
                const SizedBox(height: 16),

                // HR Manager Details Section
                _buildSectionCard(
                  title: 'HR Manager Details',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _hrFirstNameController,
                              label: 'First Name',
                              hint: 'First Name',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _hrLastNameController,
                              label: 'Last Name',
                              hint: 'Last Name',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _hrMailIdController,
                        label: 'Mail ID',
                        hint: 'Email address',
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Contact Details Section
                _buildSectionCard(
                  title: 'Contact Details',
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
                            width: 80,
                            child: _buildDropdownField(
                              label: '',
                              value: _officeCountryCode,
                              items: ['+91', '+1', '+44', '+86'],
                              onChanged: (value) {
                                setState(() {
                                  _officeCountryCode = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildTextField(
                              controller: _officeNumberController,
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
                            width: 80,
                            child: _buildDropdownField(
                              label: '',
                              value: _mobileCountryCode,
                              items: ['+91', '+1', '+44', '+86'],
                              onChanged: (value) {
                                setState(() {
                                  _mobileCountryCode = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildTextField(
                              controller: _mobileNumberController,
                              label: 'Mobile Number',
                              hint: '9876543210',
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _companyWebsiteController,
                        label: 'Company Website',
                        hint: 'https://abc.com',
                        keyboardType: TextInputType.url,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
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
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF8BB6D9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    VoidCallback? onTap,
  }) {
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
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              enabled: onTap == null,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                suffixIcon: suffixIcon,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
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
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.access_time,
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
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
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
            border: Border.all(color: Colors.grey[300]!),
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
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildMapView() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          // Placeholder for map - in real app, use google_maps_flutter
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Interactive Map',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select clubs within your preferred radius',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Radius circle overlay (visual representation)
          Positioned(
            left: 50,
            top: 50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red.withOpacity(0.5),
                  width: 2,
                ),
                color: Colors.red.withOpacity(0.1),
              ),
            ),
          ),
          // Distance label
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_distanceController.text} ${_distanceUnit}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: const BorderSide(color: Colors.grey),
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
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text(
                'Back',
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
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
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
                  : const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

