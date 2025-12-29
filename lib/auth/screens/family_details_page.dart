import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'member_membership_plan_page.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/models/api_models.dart';

class FamilyDetailsPage extends StatefulWidget {
  const FamilyDetailsPage({super.key});

  @override
  State<FamilyDetailsPage> createState() => _FamilyDetailsPageState();
}

class _FamilyDetailsPageState extends State<FamilyDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final TextEditingController _numberOfMembersController = TextEditingController(text: '2');

  // Common checkboxes
  bool _addressSameAsSignup = true;
  bool _practicePlanSameAsMain = true;
  bool _preferredClubsSameAsMain = true;

  // Member data list
  List<Map<String, dynamic>> _members = [];

  // Address data (for when checkbox is unchecked)
  final Map<String, TextEditingController> _addressControllers = {
    'address1': TextEditingController(text: 'Xyz'),
    'address2': TextEditingController(text: 'Xyz'),
    'city': TextEditingController(text: 'Xyz'),
    'state': TextEditingController(text: 'Xyz'),
    'zip': TextEditingController(text: 'Xyz'),
    'country': TextEditingController(text: 'Xyz'),
  };

  // Practice plans (for when checkbox is unchecked)
  List<Map<String, dynamic>> _practicePlans = [];

  // Preferred clubs (for when checkbox is unchecked)
  final List<String> _selectedClubs = [];
  final TextEditingController _distanceController = TextEditingController(text: '5');
  String _distanceUnit = 'Km';

  final List<String> _availableClubs = [
    'Urban Titans',
    'Steel Panthers',
    'Golden Eagles',
    'Thunder Hawks',
    'Crimson Wolves',
  ];

  List<String> _allSports = [];
  bool _isLoadingSports = false;
  final AuthRepository _authRepository = AuthRepository();

  // Club days from API
  List<MstClubDay> _clubDays = [];
  bool _isLoadingClubDays = false;

  @override
  void initState() {
    super.initState();
    _numberOfMembersController.addListener(_onNumberOfMembersChanged);
    _initializeMembers();
    _selectedClubs.addAll(['Urban Titans', 'Steel Panthers']);
    _loadSports();
    _loadClubDays().then((_) {
      // Initialize practice plans after club days are loaded
      if (mounted) {
        _initializePracticePlans();
      }
    });
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
          // Update default days in existing practice plans if they're still using hardcoded values
          for (var plan in _practicePlans) {
            final practiceDays = plan['practiceDays'] as String;
            if (practiceDays == 'Weekdays' || practiceDays == 'Weekend') {
              if (_clubDays.isNotEmpty) {
                plan['practiceDays'] = _clubDays.first.name;
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
        orderBy: 'id|ASC',
        isActive: 1,
      );

      if (mounted) {
        setState(() {
          _allSports = response.data
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
    final numberOfMembers = int.tryParse(_numberOfMembersController.text) ?? 2;
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
        'firstName': TextEditingController(text: 'Peter'),
        'lastName': TextEditingController(text: 'Stillman'),
        'email': TextEditingController(text: 'Peter123@Gmail.Com'),
        'dateOfBirth': TextEditingController(),
        'gender': 'Male',
        'contactNumber': TextEditingController(text: '9876543210'),
        'countryCode': '+91',
        'membershipType': 'Adult (18 And Above)',
        'sports': ['Tennis', 'Baseball', 'Cricket', 'Basketball'],
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
    final defaultDay = _clubDays.isNotEmpty ? _clubDays.first.name : 'Monday';
    _practicePlans = [
      {
        'id': 1,
        'practiceDays': defaultDay,
        'startTime': '00:00',
        'endTime': '00:00',
      },
      {
        'id': 2,
        'practiceDays': defaultDay,
        'startTime': '00:00',
        'endTime': '00:00',
      },
    ];
  }

  void _addPracticePlan() {
    setState(() {
      final defaultDay = _clubDays.isNotEmpty ? _clubDays.first.name : 'Monday';
      _practicePlans.add({
        'id': _practicePlans.length + 1,
        'practiceDays': defaultDay,
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
                if (_isLoadingSports)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  )
                else if (_allSports.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No sports available'),
                  )
                else
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
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      member['controllers']['sports'] = currentSports;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submitFamilyDetails() {
    if (!_formKey.currentState!.validate()) return;

    // Navigate to membership plan page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MemberMembershipPlanPage(),
      ),
    );
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
                  hint: '2',
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
          Row(
            children: [
              SizedBox(
                width: 80,
                child: _buildDropdownField(
                  label: '',
                  value: controllers['countryCode'] as String,
                  items: ['+91', '+1', '+44', '+86'],
                  onChanged: (value) {
                    setState(() {
                      controllers['countryCode'] = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  controller: controllers['contactNumber'] as TextEditingController,
                  label: 'Contact Number',
                  hint: '9876543210',
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
    final sports = member['controllers']['sports'] as List<String>;

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
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: 'City',
                        value: _addressControllers['city']!.text,
                        items: ['Xyz', 'Mumbai', 'Delhi', 'Bangalore'],
                        onChanged: (value) {
                          setState(() {
                            _addressControllers['city']!.text = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'State',
                        value: _addressControllers['state']!.text,
                        items: ['Xyz', 'Maharashtra', 'Delhi', 'Karnataka'],
                        onChanged: (value) {
                          setState(() {
                            _addressControllers['state']!.text = value!;
                          });
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
                        controller: _addressControllers['zip']!,
                        label: 'Zip Code',
                        hint: 'Enter zip code',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Country',
                        value: _addressControllers['country']!.text,
                        items: ['Xyz', 'India', 'USA', 'UK'],
                        onChanged: (value) {
                          setState(() {
                            _addressControllers['country']!.text = value!;
                          });
                        },
                      ),
                    ),
                  ],
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
                      _isLoadingClubDays
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Practice Days',
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
                                      'Practice Days',
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
                                  label: 'Practice Days',
                                  value: _clubDays.any((day) => day.name == plan['practiceDays'] as String)
                                      ? plan['practiceDays'] as String
                                      : _clubDays.isNotEmpty
                                          ? _clubDays.first.name
                                          : 'Monday',
                                  items: _clubDays.map((day) => day.name).toList(),
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
                          child: Wrap(
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
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
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
              onPressed: _submitFamilyDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
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

