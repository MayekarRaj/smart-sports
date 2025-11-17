import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/api_models.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/utils/phone_parser.dart';
import '../widgets/phone_code_dropdown.dart';
import '../widgets/city_search_field.dart';
import 'member_membership_plan_page.dart';

class FamilyDetailsPage extends StatefulWidget {
  const FamilyDetailsPage({super.key});

  @override
  State<FamilyDetailsPage> createState() => _FamilyDetailsPageState();
}

class _FamilyDetailsPageState extends State<FamilyDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController _numberOfMembersController = TextEditingController();
  bool _isLoading = false;

  // Common checkboxes
  bool _addressSameAsSignup = true;
  bool _practicePlanSameAsMain = true;
  bool _preferredClubsSameAsMain = true;

  // Member data list
  List<Map<String, dynamic>> _members = [];

  // Address data (for when checkbox is unchecked)
  final Map<String, TextEditingController> _addressControllers = {
    'address1': TextEditingController(),
    'address2': TextEditingController(),
    'city': TextEditingController(),
    'state': TextEditingController(),
    'zip': TextEditingController(),
    'country': TextEditingController(),
  };

  // Practice plans (for when checkbox is unchecked)
  List<Map<String, dynamic>> _practicePlans = [];

  // Preferred clubs (for when checkbox is unchecked)
  final List<String> _selectedClubs = [];
  final TextEditingController _distanceController = TextEditingController();
  String _distanceUnit = 'Km';

  final List<String> _availableClubs = [
    'Urban Titans',
    'Steel Panthers',
    'Golden Eagles',
    'Thunder Hawks',
    'Crimson Wolves',
  ];

  final List<String> _allSports = [
    'Tennis',
    'Baseball',
    'Cricket',
    'Basketball',
    'Football',
    'Hockey',
    'Badminton',
    'Volleyball',
  ];

  @override
  void initState() {
    super.initState();
    _numberOfMembersController.addListener(_onNumberOfMembersChanged);
    _initializeMembers();
    _initializePracticePlans();
  }

  @override
  void dispose() {
    _numberOfMembersController.dispose();
    _scrollController.dispose();
    for (var controller in _addressControllers.values) {
      controller.dispose();
    }
    _distanceController.dispose();
    for (var member in _members) {
      for (var controller in member['controllers'].values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _initializeMembers() {
    final numberOfMembers = int.tryParse(_numberOfMembersController.text) ?? 1;
    if (numberOfMembers < 1) {
      _members.clear();
      return;
    }
    _members.clear();

    for (int i = 0; i < numberOfMembers; i++) {
      _members.add(_createMemberData(i + 1));
    }
  }

  Map<String, dynamic> _createMemberData(int memberNumber) {
    return {
      'memberNumber': memberNumber,
      'isHead': memberNumber == 1,
      'controllers': {
        'firstName': TextEditingController(),
        'lastName': TextEditingController(),
        'email': TextEditingController(),
        'dateOfBirth': TextEditingController(),
        'gender': 'Male',
        'contactNumber': TextEditingController(),
        'countryCode': '+91', // Default value for dropdown
        'membershipType': 'Adult (18 And Above)',
        'sports': [],
      },
    };
  }

  void _onNumberOfMembersChanged() {
    final numberOfMembers = int.tryParse(_numberOfMembersController.text) ?? 1;
    if (numberOfMembers < 1) {
      setState(() {
        _numberOfMembersController.text = '1';
      });
      return;
    }

    setState(() {
      if (numberOfMembers > _members.length) {
        // Add new members
        for (int i = _members.length; i < numberOfMembers; i++) {
          _members.add(_createMemberData(i + 1));
        }
      } else if (numberOfMembers < _members.length) {
        // Remove excess members
        for (int i = _members.length - 1; i >= numberOfMembers; i--) {
          var member = _members[i];
          for (var controller in member['controllers'].values) {
            if (controller is TextEditingController) {
              controller.dispose();
            }
          }
          _members.removeAt(i);
        }
        // Update member numbers
        for (int i = 0; i < _members.length; i++) {
          _members[i]['memberNumber'] = i + 1;
          _members[i]['isHead'] = i == 0;
        }
      }
    });
  }

  void _initializePracticePlans() {
    _practicePlans = [
      {
        'id': 1,
        'practiceDays': 'Weekdays',
        'startTime': '00:00',
        'endTime': '00:00',
      },
      {
        'id': 2,
        'practiceDays': 'Weekdays',
        'startTime': '00:00',
        'endTime': '00:00',
      },
    ];
  }

  void _addPracticePlan() {
    setState(() {
      _practicePlans.add({
        'id': _practicePlans.length + 1,
        'practiceDays': 'Weekdays',
        'startTime': '00:00',
        'endTime': '00:00',
      });
    });
  }

  void _removePracticePlan(int id) {
    setState(() {
      _practicePlans.removeWhere((plan) => plan['id'] == id);
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8BB6D9),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('MM-dd-yyyy').format(picked);
    }
  }

  Future<void> _selectTime(BuildContext context, Map<String, dynamic> plan, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        if (isStartTime) {
          plan['startTime'] = timeString;
        } else {
          plan['endTime'] = timeString;
        }
      });
    }
  }

  void _showClubSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
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
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: _availableClubs.map((club) {
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
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSportsSelection(Map<String, dynamic> member) {
    final currentSports = List<String>.from(member['controllers']['sports'] as List);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Sports',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _allSports.map((sport) {
                        final isSelected = currentSports.contains(sport);
                        return CheckboxListTile(
                          title: Text(sport),
                          value: isSelected,
                          onChanged: (value) {
                            setModalState(() {
                              if (value == true) {
                                if (!currentSports.contains(sport)) {
                                  currentSports.add(sport);
                                }
                              } else {
                                currentSports.remove(sport);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        member['controllers']['sports'] = currentSports;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _submitFamilyDetails() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert form data to FamilyMember objects
      List<FamilyMember> familyMembers = [];

      if (_members.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please add at least one family member'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      for (var member in _members) {
        final controllers = member['controllers'] as Map<String, dynamic>;
        
        // Parse date from MM-DD-YYYY to YYYY-MM-DD
        String dob = '';
        final dobController = controllers['dateOfBirth'] as TextEditingController;
        if (dobController.text.isNotEmpty) {
          try {
            final date = DateFormat('MM-dd-yyyy').parse(dobController.text);
            dob = DateFormat('yyyy-MM-dd').format(date);
          } catch (e) {
            // If parsing fails, try to use as-is or show error
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Invalid date format for member ${member['memberNumber']}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            setState(() => _isLoading = false);
            return;
          }
        }

        // Parse phone numbers
        final mobilePhone = PhoneParser.parsePhoneNumber(
          controllers['contactNumber']?.text ?? '',
        );
        final countryCode = controllers['countryCode'] as String? ?? '+91';

        // Convert membership type
        String membershipType = controllers['membershipType'] as String? ?? 'Adult (18 And Above)';
        // Map to API format (assuming API expects: "Adult", "Youth", "Junior", etc.)
        if (membershipType.contains('Adult')) {
          membershipType = 'Adult';
        } else if (membershipType.contains('Youth')) {
          membershipType = 'Youth';
        } else if (membershipType.contains('Child')) {
          membershipType = 'Junior';
        }

        // Get sports
        final sports = List<String>.from(controllers['sports'] as List? ?? []);

        // Handle address
        String? zipCode;
        String? city;
        String? state;
        String? country;
        String? addressLine1;
        String? addressLine2;
        String? addressLine3;

        if (!_addressSameAsSignup) {
          zipCode = _addressControllers['zip']?.text.trim();
          city = _addressControllers['city']?.text.trim();
          state = _addressControllers['state']?.text.trim();
          country = _addressControllers['country']?.text.trim();
          addressLine1 = _addressControllers['address1']?.text.trim();
          addressLine2 = _addressControllers['address2']?.text.trim();
          addressLine3 = null; // Not in form
        }

        // Handle practice plans
        List<PracticePlan> practicePlans = [];
        if (!_practicePlanSameAsMain) {
          for (var plan in _practicePlans) {
            final practiceDays = plan['practiceDays'] as String;
            final startTime = plan['startTime'] as String;
            final endTime = plan['endTime'] as String;

            // Convert Weekdays/Weekend to individual days
            List<String> days = [];
            if (practiceDays == 'Weekdays') {
              days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
            } else if (practiceDays == 'Weekend') {
              days = ['Saturday', 'Sunday'];
            } else {
              days = [practiceDays];
            }

            // Create practice plan for each day
            for (var day in days) {
              practicePlans.add(
                PracticePlan(
                  practiceDay: day,
                  practiceStartTime: startTime,
                  practiceEndTime: endTime,
                ),
              );
            }
          }
        }

        // Handle preferred clubs
        List<int> preferredClub = [];
        if (!_preferredClubsSameAsMain) {
          // Map club names to IDs (for now, using static mapping)
          // In production, you'd fetch this from an API or store it
          final clubNameToId = {
            'Urban Titans': 1,
            'Steel Panthers': 2,
            'Golden Eagles': 3,
            'Thunder Hawks': 4,
            'Crimson Wolves': 5,
          };
          
          for (var clubName in _selectedClubs) {
            final clubId = clubNameToId[clubName];
            if (clubId != null) {
              preferredClub.add(clubId);
            }
          }
        }

        // Create FamilyMember object
        familyMembers.add(
          FamilyMember(
            firstname: (controllers['firstName'] as TextEditingController).text.trim(),
            lastname: (controllers['lastName'] as TextEditingController).text.trim(),
            email: (controllers['email'] as TextEditingController).text.trim(),
            dob: dob,
            gender: controllers['gender'] as String? ?? 'Male',
            designation: '', // Not in form, using empty string
            department: '', // Not in form, using empty string
            mobilePhoneExt: countryCode,
            mobilePhone: mobilePhone['number'] ?? '',
            officePhoneExt: countryCode, // Using same as mobile for now
            officePhone: '', // Not in form, using empty string
            membershipType: membershipType,
            sportsInterestedIn: sports,
            isAddressIsSameAsUser: _addressSameAsSignup ? 1 : 0,
            zipCode: zipCode,
            city: city,
            state: state,
            country: country,
            addressLine1: addressLine1,
            addressLine2: addressLine2,
            addressLine3: addressLine3,
            isPracticePlanSameMainMember: _practicePlanSameAsMain ? 1 : 0,
            practicePlans: practicePlans,
            isPreferredClubsSameMainMember: _preferredClubsSameAsMain ? 1 : 0,
            preferredClub: preferredClub,
          ),
        );
      }

      // Build request
      final request = FamilyMemberSignupRequest(
        familyMembers: familyMembers,
      );

      // Call API
      final response = await _authRepository.familyMemberSignup(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to membership plan page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MemberMembershipPlanPage(),
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
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
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
          'Family Details (If Utilize This Platform)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
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
              // Number of Family Members
              _buildSectionCard(
                title: '',
                child: _buildTextField(
                  controller: _numberOfMembersController,
                  label: 'Number Of Family Members',
                  hint: 'Enter number of family members',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 16),

              // Member Details Sections
              ..._members.asMap().entries.map((entry) {
                final member = entry.value;
                return Column(
                  children: [
                    _buildMemberSection(member),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),

              // Additional sections with checkboxes
              const SizedBox(height: 16),
              _buildAddressSection(),
              const SizedBox(height: 16),
              _buildPracticePlanSection(),
              const SizedBox(height: 16),
              _buildPreferredClubSection(),

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
                color: Colors.black,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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

  Widget _buildMemberSection(Map<String, dynamic> member) {
    final controllers = member['controllers'] as Map<String, dynamic>;
    final memberNumber = member['memberNumber'] as int;
    final isHead = member['isHead'] as bool;

    return _buildSectionCard(
      title: 'Member $memberNumber Details${isHead ? ' (Head)' : ''}',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: controllers['firstName'] as TextEditingController,
                  label: 'First Name',
                  hint: 'First Name',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: controllers['lastName'] as TextEditingController,
                  label: 'Last Name',
                  hint: 'Last Name',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: controllers['email'] as TextEditingController,
            label: 'Email Address',
            hint: 'Email address',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  controller: controllers['dateOfBirth'] as TextEditingController,
                  label: 'Date Of Birth',
                  hint: 'MM-DD-YYYY',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  label: 'Gender',
                  value: controllers['gender'] as String,
                  items: ['Male', 'Female', 'Other'],
                  onChanged: (value) {
                    setState(() {
                      controllers['gender'] = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Contact Number',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),  
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 120,
                child: PhoneCodeDropdown(
                  value: controllers['countryCode'] as String?,
                  onChanged: (value) {
                    setState(() {
                      controllers['countryCode'] = value ?? '+91';
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  controller: controllers['contactNumber'] as TextEditingController,
                  label: '',
                  hint: 'Enter contact number',
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Membership Type',
            value: controllers['membershipType'] as String,
            items: [
              'Adult (18 And Above)',
              'Youth (13-17)',
              'Child (Below 13)',
            ],
            onChanged: (value) {
              setState(() {
                controllers['membershipType'] = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildSportsSection(member),
        ],
      ),
    );
  }

  Widget _buildSportsSection(Map<String, dynamic> member) {
    final sports = List<String>.from(member['controllers']['sports'] as List? ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sports Interested In',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showSportsSelection(member),
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
                  child: sports.isEmpty
                      ? Text(
                          'No sports selected. Tap to select.',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: sports.map((sport) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8BB6D9).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF8BB6D9)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    sport,
                                    style: const TextStyle(
                                      color: Color(0xFF8BB6D9),
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


  Widget _buildAddressSection() {
    return Column(
      children: [
        // Checkbox for Address
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              Checkbox(
                value: _addressSameAsSignup,
                onChanged: (value) {
                  setState(() {
                    _addressSameAsSignup = value ?? false;
                  });
                },
                activeColor: const Color(0xFF8BB6D9),
              ),
              const Expanded(
                child: Text(
                  'Address Is Same As Sign Up Address?',
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
        if (!_addressSameAsSignup) ...[
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Address',
            child: Column(
              children: [
                _buildTextField(
                  controller: _addressControllers['address1']!,
                  label: 'Address 1',
                  hint: 'Enter address line 1',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _addressControllers['address2']!,
                  label: 'Address 2',
                  hint: 'Enter address line 2',
                ),
                const SizedBox(height: 16),
                CitySearchField(
                  cityController: _addressControllers['city']!,
                  stateController: _addressControllers['state'],
                  countryController: _addressControllers['country'],
                  label: 'City',
                  hint: 'Enter city name',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _addressControllers['zip']!,
                        label: 'Zip Code',
                        hint: 'Enter zip code',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _addressControllers['state']!,
                        label: 'State',
                        hint: 'State',
                        enabled: true,
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _addressControllers['country']!,
                  label: 'Country',
                  hint: 'Country',
                  enabled: true,
                  readOnly: true,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPracticePlanSection() {
    return Column(
      children: [
        // Checkbox for Practice Plan
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              Checkbox(
                value: _practicePlanSameAsMain,
                onChanged: (value) {
                  setState(() {
                    _practicePlanSameAsMain = value ?? false;
                  });
                },
                activeColor: const Color(0xFF8BB6D9),
              ),
              const Expanded(
                child: Text(
                  'Practice Plan Same As Main Member?',
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
        if (!_practicePlanSameAsMain) ...[
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Practice Plan',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    ElevatedButton.icon(
                      onPressed: _addPracticePlan,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Practice Plan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 16),
          ..._practicePlans.asMap().entries.map((entry) {
            final index = entry.key;
            final plan = entry.value;
            return Column(
              children: [
                Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Plan ${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (_practicePlans.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removePracticePlan(plan['id']),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDropdownField(
                        label: 'Practice Days',
                        value: plan['practiceDays'] as String,
                        items: [
                          'Weekdays',
                          'Weekend',
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                          'Saturday',
                          'Sunday',
                        ],
                        onChanged: (value) {
                          setState(() {
                            plan['practiceDays'] = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimeField(
                              label: 'Practice Time',
                              value: plan['startTime'] as String,
                              onTap: () => _selectTime(context, plan, true),
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
                              value: plan['endTime'] as String,
                              onTap: () => _selectTime(context, plan, false),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (index < _practicePlans.length - 1) const SizedBox(height: 12),
              ],
            );
          }).toList(),
            ],
          ),
          ),
        ],
      ],
    );
  }

  Widget _buildPreferredClubSection() {
    return Column(
      children: [
        // Checkbox for Preferred Clubs
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              Checkbox(
                value: _preferredClubsSameAsMain,
                onChanged: (value) {
                  setState(() {
                    _preferredClubsSameAsMain = value ?? false;
                  });
                },
                activeColor: const Color(0xFF8BB6D9),
              ),
              const Expanded(
                child: Text(
                  'Preferred Clubs Are Same As Main Member',
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
        if (!_preferredClubsSameAsMain) ...[
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Preferred Club',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _showClubSelection,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _selectedClubs.isEmpty
                              ? Text(
                                  'No clubs selected. Tap to select.',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              : Wrap(
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        controller: _distanceController,
                        label: 'Distance',
                        hint: 'Enter distance',
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
        ],
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
                ],
              ),
            ),
          ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != '' ?
        Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          )
        : SizedBox.shrink(),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            enabled: enabled,
            readOnly: readOnly,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
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
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required String hint,
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
        GestureDetector(
          onTap: () => _selectDate(context, controller),
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
                  controller.text.isEmpty ? hint : controller.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: controller.text.isEmpty ? Colors.grey[400] : Colors.black,
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
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
              onPressed: _isLoading ? null : _submitFamilyDetails,
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

