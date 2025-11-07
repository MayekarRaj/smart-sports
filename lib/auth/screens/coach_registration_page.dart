import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/models/api_models.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/utils/phone_parser.dart';
import '../../core/utils/file_utils.dart';
import 'membership_plan_page.dart';

// Helper class for club data
class ClubData {
  final TextEditingController clubNameController;
  final TextEditingController sportTypeController;
  final List<ServiceDayTime> serviceDays;

  ClubData({
    required this.clubNameController,
    required this.sportTypeController,
    required this.serviceDays,
  });

  void dispose() {
    clubNameController.dispose();
    sportTypeController.dispose();
  }
}

// Helper class for service day and time
class ServiceDayTime {
  String day;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  ServiceDayTime({
    this.day = 'Monday',
    this.startTime,
    this.endTime,
  });
}

class CoachRegistrationPage extends ConsumerStatefulWidget {
  const CoachRegistrationPage({super.key});

  @override
  ConsumerState<CoachRegistrationPage> createState() => _CoachRegistrationPageState();
}

class _CoachRegistrationPageState extends ConsumerState<CoachRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final AuthRepository _authRepository = AuthRepository();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;

  // Coach Details Controllers
  String _experienceLevel = 'Experienced';
  final _numberOfUsersController = TextEditingController(text: '2');
  
  // Certificate files (for experience levels)
  List<XFile> _certificateFiles = [];

  // Clubs Data - Dynamic structure
  final List<ClubData> _clubs = [];

  // Address and Contact Options
  bool _companyAddressSameAsSignup = false;
  bool _contactDetailsSameAsSignup = false;

  // Address Controllers
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

  @override
  void initState() {
    super.initState();
    // Add one initial club
    _addClub();
  }

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
    // Dispose all clubs
    for (var club in _clubs) {
      club.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _addClub() {
    setState(() {
      _clubs.add(
        ClubData(
          clubNameController: TextEditingController(),
          sportTypeController: TextEditingController(),
          serviceDays: [
            ServiceDayTime(
              day: 'Monday',
              startTime: const TimeOfDay(hour: 9, minute: 0),
              endTime: const TimeOfDay(hour: 17, minute: 0),
            ),
          ],
        ),
      );
    });
  }

  void _removeClub(int index) {
    if (_clubs.length > 1) {
      setState(() {
        _clubs[index].dispose();
        _clubs.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one club is required'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _addServiceDayTime(int clubIndex) {
    setState(() {
      _clubs[clubIndex].serviceDays.add(
        ServiceDayTime(
          day: 'Monday',
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 17, minute: 0),
        ),
      );
    });
  }

  void _removeServiceDayTime(int clubIndex, int dayIndex) {
    if (_clubs[clubIndex].serviceDays.length > 1) {
      setState(() {
        _clubs[clubIndex].serviceDays.removeAt(dayIndex);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one service day is required'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16A34A),
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
          'Coach Registration',
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

  Widget _buildAddFileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _pickCertificateFile,
          child: Container(
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
        ),
        if (_certificateFiles.isNotEmpty) ...[
          const SizedBox(height: 12),
          ..._certificateFiles.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.description, color: const Color(0xFF11998E)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      file.name,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      setState(() {
                        _certificateFiles.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ],
    );
  }

  Future<void> _pickCertificateFile() async {
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Compress image to 70% quality (reduced from 85)
        maxWidth: 1200, // Limit width (reduced from 1920)
        maxHeight: 1200, // Limit height (reduced from 1920)
      );
      if (file != null) {
        // Validate file size (max 2MB)
        final isValidSize = await FileUtils.validateFileSize(file);
        if (!isValidSize) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File size exceeds 2MB. Please select a smaller image.'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 4),
              ),
            );
          }
          return;
        }

        setState(() {
          _certificateFiles.add(file);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
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
              InkWell(
                onTap: _addClub,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11998E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Add Club',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._clubs.asMap().entries.map((entry) {
            int index = entry.key;
            ClubData club = entry.value;
            return _buildClubCard(index + 1, club, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildClubCard(int clubNumber, ClubData club, int clubIndex) {
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
              // Add Day & Time button
              InkWell(
                onTap: () => _addServiceDayTime(clubIndex),
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
              const SizedBox(width: 8),
              // Remove club button (only show if more than one club)
              if (_clubs.length > 1)
                InkWell(
                  onTap: () => _removeClub(clubIndex),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 18,
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
                  controller: club.clubNameController,
                  label: 'Club Name',
                  hint: 'Enter club name',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: club.sportTypeController,
                  label: 'Sport Type',
                  hint: 'Enter sport type',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...club.serviceDays.asMap().entries.map((entry) {
            int dayIndex = entry.key;
            ServiceDayTime serviceDay = entry.value;
            return _buildServiceDayTimeRow(serviceDay, clubIndex, dayIndex);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildServiceDayTimeRow(
    ServiceDayTime serviceDay,
    int clubIndex,
    int dayIndex,
  ) {
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
                child: _buildDropdownField(
                  label: 'Service Day',
                  value: serviceDay.day,
                  items: const [
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                    'Saturday',
                    'Sunday',
                    'Weekdays',
                    'Weekend',
                  ],
                  onChanged: (value) {
                    setState(() {
                      serviceDay.day = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Remove button (only show if more than one day)
              if (_clubs[clubIndex].serviceDays.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: InkWell(
                    onTap: () => _removeServiceDayTime(clubIndex, dayIndex),
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
                  time: serviceDay.startTime,
                  onTimeSelected: (time) {
                    setState(() {
                      serviceDay.startTime = time;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimePickerField(
                  label: 'End Time',
                  time: serviceDay.endTime,
                  onTimeSelected: (time) {
                    setState(() {
                      serviceDay.endTime = time;
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
                  value: _cityController.text.isNotEmpty ? _cityController.text : null,
                  items: const ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _cityController.text = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  label: 'State',
                  value: _stateController.text.isNotEmpty ? _stateController.text : null,
                  items: const ['NY', 'CA', 'TX', 'FL', 'IL'],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _stateController.text = value;
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
                  value: _countryController.text.isNotEmpty ? _countryController.text : null,
                  items: const ['USA', 'Canada', 'Mexico', 'UK', 'Australia'],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _countryController.text = value;
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
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitCoachRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
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
                        Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitCoachRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    // Validate clubs
    if (_clubs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one club'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validate experience levels (certificates)
    if (_certificateFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload at least one certificate'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Parse phone numbers
      final officePhone = PhoneParser.parsePhoneNumber(_officeNumberController.text);
      final mobilePhone = PhoneParser.parsePhoneNumber(_mobileNumberController.text);

      // Convert certificate files to base64 (with size validation)
      final experienceLevels = <CoachExperienceLevel>[];
      for (final file in _certificateFiles) {
        try {
          // Double-check file size before encoding
          final fileSizeMB = await FileUtils.getFileSizeInMB(file);
          if (fileSizeMB > 2.0) {
            throw Exception(
              'Certificate "${file.name}" is too large (${fileSizeMB.toStringAsFixed(2)} MB). Maximum size is 2MB.',
            );
          }

          final base64 = await FileUtils.xFileToBase64(file);
          experienceLevels.add(
            CoachExperienceLevel(
              expLevelName: _experienceLevel,
              certificateName: file.name,
              certificateBase64: base64,
            ),
          );
        } catch (e) {
          // If one file fails, show error and stop
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString().replaceFirst('Exception: ', '')),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }
          return;
        }
      }

      // Transform clubs data to API format
      final clubs = _clubs.map((club) {
        final serviceDays = <CoachServiceDay>[];
        
        // Validate club name and sport type
        if (club.clubNameController.text.trim().isEmpty) {
          throw Exception('Please enter club name for all clubs');
        }
        if (club.sportTypeController.text.trim().isEmpty) {
          throw Exception('Please enter sport type for all clubs');
        }
        
        // Map service days and times
        for (final serviceDay in club.serviceDays) {
          if (serviceDay.startTime == null || serviceDay.endTime == null) {
            throw Exception('Please select start and end time for all service days');
          }
          
          serviceDays.add(
            CoachServiceDay(
              day: serviceDay.day,
              timeSlotsStart: '${serviceDay.startTime!.hour.toString().padLeft(2, '0')}:${serviceDay.startTime!.minute.toString().padLeft(2, '0')}',
              timeSlotsEnd: '${serviceDay.endTime!.hour.toString().padLeft(2, '0')}:${serviceDay.endTime!.minute.toString().padLeft(2, '0')}',
            ),
          );
        }

        return CoachClub(
          clubName: club.clubNameController.text.trim(),
          sportType: club.sportTypeController.text.trim(),
          serviceDays: serviceDays,
        );
      }).toList();

      // Build request
      final request = CoachSignupRequest(
        userRole: 'coach',
        noOfUsers: int.tryParse(_numberOfUsersController.text) ?? 0,
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
            : officePhone['ext']?.isNotEmpty == true
                ? officePhone['ext']
                : null,
        officePhone: _contactDetailsSameAsSignup
            ? null
            : officePhone['number']?.isNotEmpty == true
                ? officePhone['number']
                : null,
        mobilePhoneExt: _contactDetailsSameAsSignup
            ? null
            : mobilePhone['ext']?.isNotEmpty == true
                ? mobilePhone['ext']
                : null,
        mobilePhone: _contactDetailsSameAsSignup
            ? null
            : mobilePhone['number']?.isNotEmpty == true
                ? mobilePhone['number']
                : null,
        companyWebsite: _contactDetailsSameAsSignup
            ? null
            : _websiteController.text.trim().isNotEmpty
                ? _websiteController.text.trim()
                : null,
        clubs: clubs,
        experienceLevels: experienceLevels,
      );

      // Call API
      await _authRepository.coachSignup(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coach registration successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to membership plan page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MembershipPlanPage(),
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
}
