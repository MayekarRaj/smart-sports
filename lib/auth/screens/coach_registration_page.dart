import 'package:flutter/material.dart';
import 'membership_plan_page.dart';

class CoachRegistrationPage extends StatefulWidget {
  const CoachRegistrationPage({super.key});

  @override
  State<CoachRegistrationPage> createState() => _CoachRegistrationPageState();
}

class _CoachRegistrationPageState extends State<CoachRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Coach Details Controllers
  String _experienceLevel = 'Experienced';
  final _numberOfUsersController = TextEditingController(text: '2');

  // Clubs Data
  final List<Map<String, dynamic>> _clubs = [
    {
      'name': 'Tennis',
      'sportType': 'Tennis',
      'serviceDays': ['Weekdays', 'Saturday'],
      'serviceTimes': [
        {'start': '00:00', 'end': '00:00'},
        {'start': '00:00', 'end': '00:00'},
      ],
    },
    {
      'name': 'Tennis',
      'sportType': 'Tennis',
      'serviceDays': ['Weekdays', 'Saturday'],
      'serviceTimes': [
        {'start': '00:00', 'end': '00:00'},
        {'start': '00:00', 'end': '00:00'},
      ],
    },
  ];

  // Address and Contact Options
  bool _companyAddressSameAsSignup = false;
  bool _contactDetailsSameAsSignup = false;

  // Address Controllers
  final _address1Controller = TextEditingController(text: 'Xyz');
  final _address2Controller = TextEditingController(text: 'Xyz');
  final _cityController = TextEditingController(text: 'Xyz');
  final _stateController = TextEditingController(text: 'Xyz');
  final _zipController = TextEditingController(text: 'Xyz');
  final _countryController = TextEditingController(text: 'Xyz');

  // Contact Details Controllers
  final _designationController = TextEditingController();
  final _departmentController = TextEditingController();
  final _officeNumberController = TextEditingController(
    text: '+91 - 9876543210',
  );
  final _mobileNumberController = TextEditingController(
    text: '+91 - 9876543210',
  );
  final _websiteController = TextEditingController(text: 'https://abc.com');

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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
          '⚽ Coach Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
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

              // Coach Details Section
              _buildSectionCard(
                title: 'Coach Details',
                titleColor: Colors.white,
                titleBackground: const Color(0xFF8BB6D9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Coach Experience Level
                    _buildDropdownField(
                      label: 'Coach Experience Level',
                      value: _experienceLevel,
                      items: [
                        'Experienced',
                        'Beginner',
                        'Intermediate',
                        'Expert',
                      ],
                      onChanged: (value) =>
                          setState(() => _experienceLevel = value!),
                    ),
                    const SizedBox(height: 20),

                    // Add File Section
                    _buildAddFileSection(),
                    const SizedBox(height: 20),

                    // Number of Users
                    _buildTextField(
                      controller: _numberOfUsersController,
                      label: 'Number Of Users',
                      hint: '2',
                      keyboardType: TextInputType.number,
                      suffixText:
                          '(You Will Be Allowed To Add Users From Your Admin Panel After Subscription.)',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Clubs Section
              _buildClubsSection(),
              const SizedBox(height: 16),

              // Company Address Checkbox
              _buildAddressCheckboxSection(),
              const SizedBox(height: 16),

              // Company Address Section (if not same as signup)
              if (!_companyAddressSameAsSignup) _buildCompanyAddressSection(),
              if (!_companyAddressSameAsSignup) const SizedBox(height: 16),

              // Contact Details Checkbox
              _buildContactDetailsCheckboxSection(),
              const SizedBox(height: 16),

              // Contact Details Section (if not same as signup)
              if (!_contactDetailsSameAsSignup) _buildContactDetailsSection(),
              if (!_contactDetailsSameAsSignup) const SizedBox(height: 16),

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
      case 'Coach Details':
        return Icons.sports;
      case 'Clubs':
        return Icons.business;
      case 'Company Address':
        return Icons.location_on;
      case 'Contact Details':
        return Icons.contact_phone;
      default:
        return Icons.info;
    }
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

  Widget _buildAddFileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300]!,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            children: [
              Icon(Icons.upload_file, size: 48, color: const Color(0xFF11998E)),
              const SizedBox(height: 12),
              const Text(
                'Add file',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF11998E),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload your coaching certificates or portfolio',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClubsSection() {
    return _buildSectionCard(
      title: 'Clubs',
      titleColor: Colors.white,
      titleBackground: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Clubs',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF11998E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '+ Add Club',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._clubs.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> club = entry.value;
            return _buildClubCard(index + 1, club);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildClubCard(int clubNumber, Map<String, dynamic> club) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Club $clubNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              if (clubNumber > 1)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11998E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '+ Day & Time',
                    style: TextStyle(
                      color: Color(0xFF11998E),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: TextEditingController(text: club['name']),
                  label: 'Club',
                  hint: 'Enter club name',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: TextEditingController(text: club['sportType']),
                  label: 'Sport Type',
                  hint: 'Enter sport type',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...club['serviceDays'].asMap().entries.map((entry) {
            int dayIndex = entry.key;
            String day = entry.value;
            Map<String, String> time = club['serviceTimes'][dayIndex];
            return _buildServiceDayTimeRow(day, time, dayIndex);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildServiceDayTimeRow(
    String day,
    Map<String, String> time,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdownField(
              label: 'Service Days',
              value: day,
              items: ['Weekdays', 'Weekend', 'Saturday', 'Sunday'],
              onChanged: (value) => {},
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Service Time',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          time['start']!,
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
                        color: const Color(0xFF11998E),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          time['end']!,
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
          activeColor: const Color(0xFF11998E),
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

  Widget _buildAddressCheckboxSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
      child: _buildCheckboxOption(
        'Company Address Is Same As Sign Up Address?',
        _companyAddressSameAsSignup,
        (value) => setState(() => _companyAddressSameAsSignup = value!),
      ),
    );
  }

  Widget _buildCompanyAddressSection() {
    return _buildSectionCard(
      title: 'Company Address',
      titleColor: Colors.white,
      titleBackground: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'City',
                  value: _cityController.text,
                  items: ['Xyz', 'City 1', 'City 2'],
                  onChanged: (value) => _cityController.text = value!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  label: 'State',
                  value: _stateController.text,
                  items: ['Xyz', 'State 1', 'State 2'],
                  onChanged: (value) => _stateController.text = value!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _zipController,
                  label: 'Zip Code',
                  hint: 'Enter zip code',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  label: 'Country',
                  value: _countryController.text,
                  items: ['Xyz', 'Country 1', 'Country 2'],
                  onChanged: (value) => _countryController.text = value!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsCheckboxSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
      child: _buildCheckboxOption(
        'Contact Details Is Same As Sign Up Contact Details?',
        _contactDetailsSameAsSignup,
        (value) => setState(() => _contactDetailsSameAsSignup = value!),
      ),
    );
  }

  Widget _buildContactDetailsSection() {
    return _buildSectionCard(
      title: 'Contact Details',
      titleColor: Colors.white,
      titleBackground: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _designationController,
                  label: 'Designation',
                  hint: 'Enter designation',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _departmentController,
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
                  controller: _officeNumberController,
                  label: 'Office Number',
                  hint: 'Enter office number',
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _mobileNumberController,
                  label: 'Mobile Number',
                  hint: 'Enter mobile number',
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _websiteController,
            label: 'Company Website',
            hint: 'Enter website URL',
            keyboardType: TextInputType.url,
          ),
        ],
      ),
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
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF11998E).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MembershipPlanPage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
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
          ),
        ],
      ),
    );
  }
}
