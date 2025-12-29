import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'practice_plan_card.dart';

class MemberCard extends StatefulWidget {
  final Color roleColor;
  final bool isMobile;
  final Map<String, dynamic> member;
  final bool isHead;
  final bool useMembersGradient;
  final bool isEditMode;
  final ValueChanged<Map<String, dynamic>> onUpdate;

  const MemberCard({
    super.key,
    required this.roleColor,
    required this.isMobile,
    required this.member,
    required this.isHead,
    this.useMembersGradient = false,
    this.isEditMode = true,
    required this.onUpdate,
  });

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  // Members tab gradient - uses role color
  LinearGradient get _membersGradient => LinearGradient(
    colors: [
      widget.roleColor.withValues(alpha: 0.8),
      widget.roleColor,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  late Map<String, dynamic> _member;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _zipCodeController = TextEditingController();

  final List<String> _availableSports = [
    'Tennis',
    'Baseball',
    'Cricket',
    'Basketball',
    'Soccer',
    'Swimming',
    'Golf',
    'Volleyball',
  ];

  final List<String> _availableClubs = [
    'Premier Sports Club',
    'Elite Athletic Center',
    'City Sports Complex',
    'Metro Sports Hub',
    'Community Sports Center',
  ];

  @override
  void initState() {
    super.initState();
    _member = Map<String, dynamic>.from(widget.member);
    _initializeControllers();
  }

  void _initializeControllers() {
    _firstNameController.text = _member['firstName'] ?? '';
    _lastNameController.text = _member['lastName'] ?? '';
    _emailController.text = _member['email'] ?? '';
    _contactController.text =
        _member['contactNumber']?.toString().replaceAll('+1-', '') ?? '';
    _addressLine1Controller.text = _member['address']?['line1'] ?? '';
    _addressLine2Controller.text = _member['address']?['line2'] ?? '';
    _zipCodeController.text = _member['address']?['zipCode'] ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _updateMember() {
    _member['firstName'] = _firstNameController.text;
    _member['lastName'] = _lastNameController.text;
    _member['email'] = _emailController.text;
    _member['contactNumber'] =
        '${_member['countryCode']}-${_contactController.text}';
    _member['address'] = {
      'line1': _addressLine1Controller.text,
      'line2': _addressLine2Controller.text,
      'city': _member['address']?['city'] ?? '',
      'state': _member['address']?['state'] ?? '',
      'zipCode': _zipCodeController.text,
      'country': _member['address']?['country'] ?? '',
    };
    widget.onUpdate(_member);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.isHead
                        ? 'Member 1 (Head)'
                        : 'Member ${_member['id'] + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (widget.isHead)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Head',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Details Section
                _buildBasicDetailsSection(),
                const SizedBox(height: 24),
                // Sports Interested Section
                _buildSportsInterestedSection(),
                const SizedBox(height: 24),
                // Address Section
                _buildAddressSection(),
                const SizedBox(height: 24),
                // Practice Plan Section
                _buildPracticePlanSection(),
                const SizedBox(height: 24),
                // Preferred Clubs Section
                _buildPreferredClubsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.useMembersGradient
            ? ShaderMask(
                shaderCallback: (bounds) =>
                    _membersGradient.createShader(bounds),
                child: const Text(
                  'Basic Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )
            : Text(
                'Basic Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: widget.roleColor,
                ),
              ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFormField(
                label: 'First Name',
                controller: _firstNameController,
                onChanged: (_) => _updateMember(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFormField(
                label: 'Last Name',
                controller: _lastNameController,
                onChanged: (_) => _updateMember(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildFormField(
          label: 'Email Address',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => _updateMember(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDatePickerField(
                label: 'Date of Birth',
                value: _member['dateOfBirth'] as DateTime,
                onChanged: (date) {
                  setState(() {
                    _member['dateOfBirth'] = date;
                    _updateMember();
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField(
                label: 'Gender',
                value: _member['gender'] as String,
                items: const ['Male', 'Female', 'Other'],
                onChanged: (value) {
                  setState(() {
                    _member['gender'] = value;
                    _updateMember();
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildPhoneField(
          label: 'Contact Number',
          countryCode: _member['countryCode'] as String,
          controller: _contactController,
          onCodeChanged: (code) {
            setState(() {
              _member['countryCode'] = code;
              _updateMember();
            });
          },
          onChanged: (_) => _updateMember(),
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Membership Type',
          value: _member['membershipType'] as String,
          items: const ['Adult', 'Child', 'Senior', 'Student'],
          onChanged: (value) {
            setState(() {
              _member['membershipType'] = value;
              _updateMember();
            });
          },
        ),
      ],
    );
  }

  Widget _buildSportsInterestedSection() {
    final selectedSports =
        (_member['sportsInterested'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.useMembersGradient
            ? ShaderMask(
                shaderCallback: (bounds) =>
                    _membersGradient.createShader(bounds),
                child: const Text(
                  'Sports Interested In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )
            : Text(
                'Sports Interested In',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: widget.roleColor,
                ),
              ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableSports.map((sport) {
            final isSelected = selectedSports.contains(sport);
            return FilterChip(
              selected: isSelected,
              label: Text(sport),
              onSelected: widget.isEditMode
                  ? (selected) {
                      setState(() {
                        if (selected) {
                          selectedSports.add(sport);
                        } else {
                          selectedSports.remove(sport);
                        }
                        _member['sportsInterested'] = selectedSports;
                        _updateMember();
                      });
                    }
                  : null,
              selectedColor: widget.roleColor.withValues(alpha: 0.2),
              checkmarkColor: widget.roleColor,
              labelStyle: TextStyle(
                color: isSelected
                    ? widget.roleColor
                    : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              side: BorderSide(
                color: isSelected
                    ? widget.roleColor
                    : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    final addressSameAsSignUp = _member['addressSameAsSignUp'] as bool? ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: addressSameAsSignUp,
              onChanged: widget.isEditMode
                  ? (value) {
                      setState(() {
                        _member['addressSameAsSignUp'] = value ?? true;
                        _updateMember();
                      });
                    }
                  : null,
              activeColor: widget.roleColor,
            ),
            const Expanded(
              child: Text(
                'Address is same as Sign Up Address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          ],
        ),
        if (!addressSameAsSignUp) ...[
          const SizedBox(height: 16),
          _buildFormField(
            label: 'Address Line 1',
            controller: _addressLine1Controller,
            onChanged: (_) => _updateMember(),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            label: 'Address Line 2',
            controller: _addressLine2Controller,
            onChanged: (_) => _updateMember(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'City',
                  value: _member['address']?['city'] ?? 'New York',
                  items: const [
                    'New York',
                    'Los Angeles',
                    'Chicago',
                    'Houston',
                    'Phoenix',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _member['address'] ??= {};
                      _member['address']['city'] = value;
                      _updateMember();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  label: 'State',
                  value: _member['address']?['state'] ?? 'New York',
                  items: const [
                    'New York',
                    'California',
                    'Texas',
                    'Florida',
                    'Illinois',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _member['address'] ??= {};
                      _member['address']['state'] = value;
                      _updateMember();
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
                child: _buildFormField(
                  label: 'Zip Code',
                  controller: _zipCodeController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updateMember(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  label: 'Country',
                  value: _member['address']?['country'] ?? 'United States',
                  items: const [
                    'United States',
                    'Canada',
                    'United Kingdom',
                    'Australia',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _member['address'] ??= {};
                      _member['address']['country'] = value;
                      _updateMember();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPracticePlanSection() {
    final practicePlanSameAsMain =
        _member['practicePlanSameAsMain'] as bool? ?? true;
    final practicePlans = (_member['practicePlans'] as List<dynamic>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: practicePlanSameAsMain,
              onChanged: widget.isEditMode
                  ? (value) {
                      setState(() {
                        _member['practicePlanSameAsMain'] = value ?? true;
                        _updateMember();
                      });
                    }
                  : null,
              activeColor: widget.roleColor,
            ),
            const Expanded(
              child: Text(
                'Practice Plan same as Main Member',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          ],
        ),
        if (!practicePlanSameAsMain) ...[
          const SizedBox(height: 16),
          ...practicePlans.asMap().entries.map((entry) {
            final index = entry.key;
            final plan = entry.value as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PracticePlanCard(
                roleColor: widget.roleColor,
                plan: plan,
                onUpdate: (updatedPlan) {
                  setState(() {
                    practicePlans[index] = updatedPlan;
                    _member['practicePlans'] = practicePlans;
                    _updateMember();
                  });
                },
                onRemove: () {
                  setState(() {
                    practicePlans.removeAt(index);
                    _member['practicePlans'] = practicePlans;
                    _updateMember();
                  });
                },
              ),
            );
          }),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                practicePlans.add({
                  'practiceDays': 'Monday',
                  'startTime': TimeOfDay(hour: 9, minute: 0),
                  'endTime': TimeOfDay(hour: 10, minute: 0),
                });
                _member['practicePlans'] = practicePlans;
                _updateMember();
              });
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Practice Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.roleColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPreferredClubsSection() {
    final preferredClubsSameAsMain =
        _member['preferredClubsSameAsMain'] as bool? ?? true;
    final selectedClubs =
        (_member['preferredClubs'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];
    final distance = _member['distance'] as double? ?? 5.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: preferredClubsSameAsMain,
              onChanged: widget.isEditMode
                  ? (value) {
                      setState(() {
                        _member['preferredClubsSameAsMain'] = value ?? true;
                        _updateMember();
                      });
                    }
                  : null,
              activeColor: widget.roleColor,
            ),
            const Expanded(
              child: Text(
                'Preferred Clubs same as Main Member',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          ],
        ),
        if (!preferredClubsSameAsMain) ...[
          const SizedBox(height: 16),
          _buildMultiSelectDropdown(
            label: 'Preferred Clubs',
            selectedItems: selectedClubs,
            items: _availableClubs,
            onChanged: widget.isEditMode
                ? (items) {
                    setState(() {
                      _member['preferredClubs'] = items;
                      _updateMember();
                    });
                  }
                : (_) {},
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distance (km)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: distance,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      label: '${distance.toStringAsFixed(1)} km',
                      activeColor: widget.roleColor,
                      onChanged: widget.isEditMode
                          ? (value) {
                              setState(() {
                                _member['distance'] = value;
                                _updateMember();
                              });
                            }
                          : null,
                    ),
                    Text(
                      '${distance.toStringAsFixed(1)} km',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Map view placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Map View (${distance.toStringAsFixed(1)} km radius)',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Clubs within radius: ${selectedClubs.length}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: widget.isEditMode,
          readOnly: !widget.isEditMode,
          keyboardType: keyboardType,
          onChanged: widget.isEditMode ? onChanged : null,
          style: TextStyle(
            fontSize: 15,
            color: widget.isEditMode ? Colors.black87 : Colors.grey.shade700,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.roleColor,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
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
    required ValueChanged<String> onChanged,
  }) {
    // Ensure value exists in items list, otherwise use first item
    final validValue = items.contains(value)
        ? value
        : (items.isNotEmpty ? items.first : '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: widget.isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: validValue.isEmpty ? null : validValue,
              isExpanded: true,
              style: TextStyle(
                fontSize: 15,
                color: widget.isEditMode ? Colors.black87 : Colors.grey.shade700,
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: widget.isEditMode
                  ? (value) {
                      if (value != null) onChanged(value);
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime value,
    required ValueChanged<DateTime> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: widget.isEditMode
              ? () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: value,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    onChanged(date);
                  }
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${value.day}/${value.month}/${value.year}',
                    style: TextStyle(
                      fontSize: 15,
                      color: widget.isEditMode ? Colors.black87 : Colors.grey.shade700,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: widget.isEditMode ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField({
    required String label,
    required String countryCode,
    required TextEditingController controller,
    required ValueChanged<String> onCodeChanged,
    ValueChanged<String>? onChanged,
  }) {
    final countryCodes = ['+1', '+44', '+91', '+61', '+86'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: widget.isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: countryCode,
                  isDense: true,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.isEditMode ? Colors.black87 : Colors.grey.shade700,
                  ),
                  items: countryCodes.map((code) {
                    return DropdownMenuItem<String>(
                      value: code,
                      child: Text(code),
                    );
                  }).toList(),
                  onChanged: widget.isEditMode
                      ? (value) {
                          if (value != null) onCodeChanged(value);
                        }
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller,
                enabled: widget.isEditMode,
                readOnly: !widget.isEditMode,
                keyboardType: TextInputType.phone,
                onChanged: widget.isEditMode ? onChanged : null,
                inputFormatters: widget.isEditMode
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : null,
                style: TextStyle(
                  fontSize: 15,
                  color: widget.isEditMode ? Colors.black87 : Colors.grey.shade700,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: widget.isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.roleColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMultiSelectDropdown({
    required String label,
    required List<String> selectedItems,
    required List<String> items,
    required ValueChanged<List<String>> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: widget.isEditMode
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final tempSelected = List<String>.from(selectedItems);
                      return StatefulBuilder(
                        builder: (context, setDialogState) {
                          return AlertDialog(
                            title: Text(label),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  final isSelected = tempSelected.contains(item);
                                  return CheckboxListTile(
                                    title: Text(item),
                                    value: isSelected,
                                    onChanged: (value) {
                                      setDialogState(() {
                                        if (value == true) {
                                          tempSelected.add(item);
                                        } else {
                                          tempSelected.remove(item);
                                        }
                                      });
                                    },
                                    activeColor: widget.roleColor,
                                  );
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  onChanged(tempSelected);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: widget.roleColor,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Done'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedItems.isEmpty
                        ? 'Select clubs...'
                        : '${selectedItems.length} club${selectedItems.length > 1 ? 's' : ''} selected',
                    style: TextStyle(
                      fontSize: 15,
                      color: selectedItems.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
        if (selectedItems.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedItems.map((club) {
              return Chip(
                label: Text(club),
                onDeleted: () {
                  setState(() {
                    selectedItems.remove(club);
                    _member['preferredClubs'] = selectedItems;
                    _updateMember();
                  });
                },
                deleteIconColor: widget.roleColor,
                backgroundColor: widget.roleColor.withValues(alpha: 0.1),
                labelStyle: TextStyle(
                  color: widget.roleColor,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
