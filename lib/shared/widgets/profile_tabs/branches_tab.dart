import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BranchesTab extends StatefulWidget {
  final Color roleColor;
  final bool isMobile;

  const BranchesTab({
    super.key,
    required this.roleColor,
    required this.isMobile,
  });

  @override
  State<BranchesTab> createState() => _BranchesTabState();
}

class _BranchesTabState extends State<BranchesTab> {
  bool _isEditMode = false;
  int _numberOfBranches = 2;
  bool _allSportsSame = false;
  final _numberOfBranchesController = TextEditingController(text: '2');
  final List<Map<String, dynamic>> _branches = [];

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

  final List<String> _openDaysOptions = [
    'Weekdays',
    'Weekend',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _numberOfBranchesController.addListener(_onNumberOfBranchesChanged);
    _initializeBranches();
  }

  @override
  void dispose() {
    _numberOfBranchesController.dispose();
    for (var branch in _branches) {
      (branch['clubNameController'] as TextEditingController?)?.dispose();
      (branch['numberOfUsersController'] as TextEditingController?)?.dispose();
      (branch['addressLine1Controller'] as TextEditingController?)?.dispose();
      (branch['addressLine2Controller'] as TextEditingController?)?.dispose();
      (branch['cityController'] as TextEditingController?)?.dispose();
      (branch['stateController'] as TextEditingController?)?.dispose();
      (branch['zipCodeController'] as TextEditingController?)?.dispose();
      (branch['countryController'] as TextEditingController?)?.dispose();
      (branch['officeNumberController'] as TextEditingController?)?.dispose();
      (branch['mobileNumberController'] as TextEditingController?)?.dispose();
      (branch['websiteController'] as TextEditingController?)?.dispose();
    }
    super.dispose();
  }

  void _onNumberOfBranchesChanged() {
    final text = _numberOfBranchesController.text;
    if (text.isEmpty) return;

    final count = int.tryParse(text);
    if (count != null && count > 0 && count <= 10 && count != _numberOfBranches) {
      _updateNumberOfBranches(count);
    }
  }

  void _initializeBranches() {
    _branches.clear();
    for (int i = 0; i < _numberOfBranches; i++) {
      _branches.add({
        'id': i,
        'clubNameController': TextEditingController(text: 'Xyz'),
        'numberOfUsersController': TextEditingController(text: '${i + 1}'),
        'addressSameAsSignUp': i == 0,
        'contactSameAsSignUp': i == 0,
        'addressLine1Controller': TextEditingController(text: i == 0 ? '' : 'Xyz'),
        'addressLine2Controller': TextEditingController(text: i == 0 ? '' : 'Xyz'),
        'cityController': TextEditingController(text: i == 0 ? '' : 'Xyz'),
        'stateController': TextEditingController(text: i == 0 ? '' : 'Xyz'),
        'zipCodeController': TextEditingController(text: i == 0 ? '' : 'Xyz'),
        'countryController': TextEditingController(text: i == 0 ? '' : 'Xyz'),
        'officeNumberController': TextEditingController(text: i == 0 ? '' : '+91 9876543210'),
        'mobileNumberController': TextEditingController(text: i == 0 ? '' : '+91 9876543210'),
        'websiteController': TextEditingController(text: i == 0 ? '' : 'https://abc.com'),
        'operationalDetails': <Map<String, dynamic>>[
          {
            'openDays': 'Weekdays',
            'startTime': TimeOfDay(hour: 0, minute: 0),
            'endTime': TimeOfDay(hour: 0, minute: 0),
          },
          {
            'openDays': 'Weekend',
            'startTime': TimeOfDay(hour: 0, minute: 0),
            'endTime': TimeOfDay(hour: 0, minute: 0),
          },
        ],
        'sports': <String>['Tennis', 'Baseball', 'Cricket', 'Basketball'],
      });
    }
  }

  void _updateNumberOfBranches(int count) {
    setState(() {
      // Dispose old controllers
      for (var branch in _branches) {
        (branch['clubNameController'] as TextEditingController?)?.dispose();
        (branch['numberOfUsersController'] as TextEditingController?)?.dispose();
        (branch['addressLine1Controller'] as TextEditingController?)?.dispose();
        (branch['addressLine2Controller'] as TextEditingController?)?.dispose();
        (branch['cityController'] as TextEditingController?)?.dispose();
        (branch['stateController'] as TextEditingController?)?.dispose();
        (branch['zipCodeController'] as TextEditingController?)?.dispose();
        (branch['countryController'] as TextEditingController?)?.dispose();
        (branch['officeNumberController'] as TextEditingController?)?.dispose();
        (branch['mobileNumberController'] as TextEditingController?)?.dispose();
        (branch['websiteController'] as TextEditingController?)?.dispose();
      }
      _numberOfBranches = count;
      _initializeBranches();
    });
  }

  void _addTimeSlot(int branchIndex) {
    setState(() {
      (_branches[branchIndex]['operationalDetails'] as List<Map<String, dynamic>>).add({
        'openDays': 'Weekdays',
        'startTime': TimeOfDay(hour: 0, minute: 0),
        'endTime': TimeOfDay(hour: 0, minute: 0),
      });
    });
  }

  void _removeTimeSlot(int branchIndex, int timeIndex) {
    setState(() {
      (_branches[branchIndex]['operationalDetails'] as List<Map<String, dynamic>>).removeAt(timeIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Edit/Save Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isEditMode = !_isEditMode;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isEditMode ? 'Changes saved' : 'Edit mode enabled'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                icon: Icon(_isEditMode ? Icons.save : Icons.edit),
                label: Text(_isEditMode ? 'Save' : 'Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.roleColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Number Of Branches Section
          Container(
            padding: const EdgeInsets.all(20),
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Number Of Branches',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _numberOfBranchesController,
                            enabled: _isEditMode,
                            readOnly: !_isEditMode,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              fontSize: 15,
                              color: _isEditMode ? Colors.black87 : Colors.grey.shade700,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: _isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '(It Will Be Paid Service To Use This Platform For More Than 1 Branch)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _allSportsSame,
                      onChanged: _isEditMode
                          ? (value) {
                              setState(() {
                                _allSportsSame = value ?? false;
                              });
                            }
                          : null,
                      activeColor: widget.roleColor,
                    ),
                    const Expanded(
                      child: Text(
                        'All Sports Are Same For Each Branch',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Branches List
          ...List.generate(_branches.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildBranchCard(index),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBranchCard(int branchIndex) {
    final branch = _branches[branchIndex];
    final numberOfUsers = int.tryParse((branch['numberOfUsersController'] as TextEditingController).text) ?? 1;

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
          // Branch Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Text(
              'Branch ${branchIndex + 1} Details',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Club Name and Number Of Users
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        label: 'Club Name',
                        controller: branch['clubNameController'] as TextEditingController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFormField(
                        label: 'Number Of Users',
                        controller: branch['numberOfUsersController'] as TextEditingController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                if (numberOfUsers > 1) ...[
                  const SizedBox(height: 8),
                  const Text(
                    '(It is A Paid Service For More Than 1 User/Branch, You Will Be Allowed To Add Users From Your Admin Panel After Subscription.)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                // Address Section
                Row(
                  children: [
                    Checkbox(
                      value: branch['addressSameAsSignUp'] as bool,
                      onChanged: _isEditMode
                          ? (value) {
                              setState(() {
                                branch['addressSameAsSignUp'] = value ?? false;
                              });
                            }
                          : null,
                      activeColor: widget.roleColor,
                    ),
                    const Expanded(
                      child: Text(
                        'Address Is Same As Sign Up Address?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!(branch['addressSameAsSignUp'] as bool)) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Address 1',
                    controller: branch['addressLine1Controller'] as TextEditingController,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Address 2',
                    controller: branch['addressLine2Controller'] as TextEditingController,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          label: 'City',
                          controller: branch['cityController'] as TextEditingController,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          label: 'State',
                          controller: branch['stateController'] as TextEditingController,
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
                          controller: branch['zipCodeController'] as TextEditingController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          label: 'Country',
                          controller: branch['countryController'] as TextEditingController,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                // Contact Details Section
                Row(
                  children: [
                    Checkbox(
                      value: branch['contactSameAsSignUp'] as bool,
                      onChanged: _isEditMode
                          ? (value) {
                              setState(() {
                                branch['contactSameAsSignUp'] = value ?? false;
                              });
                            }
                          : null,
                      activeColor: widget.roleColor,
                    ),
                    const Expanded(
                      child: Text(
                        'Contact Details Is Same As Sign Up Contact Details?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!(branch['contactSameAsSignUp'] as bool)) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Contact Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Office Number',
                    controller: branch['officeNumberController'] as TextEditingController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Mobile Number',
                    controller: branch['mobileNumberController'] as TextEditingController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Company Website',
                    controller: branch['websiteController'] as TextEditingController,
                    keyboardType: TextInputType.url,
                  ),
                ],
                const SizedBox(height: 24),
                // Club Operational Details
                _buildOperationalDetails(branchIndex),
                const SizedBox(height: 24),
                // Sports Section
                _buildSportsSection(branchIndex),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationalDetails(int branchIndex) {
    final branch = _branches[branchIndex];
    final operationalDetails = branch['operationalDetails'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Club Operational Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (_isEditMode)
                ElevatedButton.icon(
                  onPressed: () => _addTimeSlot(branchIndex),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Days & Time'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...operationalDetails.asMap().entries.map((entry) {
          final timeIndex = entry.key;
          final timeSlot = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildTimeSlot(branchIndex, timeIndex, timeSlot),
          );
        }),
      ],
    );
  }

  Widget _buildTimeSlot(int branchIndex, int timeIndex, Map<String, dynamic> timeSlot) {
    final branch = _branches[branchIndex];
    final operationalDetails = branch['operationalDetails'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Time ${timeIndex + 1}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            if (_isEditMode && operationalDetails.length > 1) ...[
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                color: Colors.red,
                onPressed: () => _removeTimeSlot(branchIndex, timeIndex),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                label: 'Open Days',
                value: timeSlot['openDays'] as String,
                items: _openDaysOptions,
                onChanged: (value) {
                  setState(() {
                    timeSlot['openDays'] = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _buildTimeRangeField(
                label: 'Club Time',
                startTime: timeSlot['startTime'] as TimeOfDay,
                endTime: timeSlot['endTime'] as TimeOfDay,
                onStartTimeChanged: (time) {
                  setState(() {
                    timeSlot['startTime'] = time;
                  });
                },
                onEndTimeChanged: (time) {
                  setState(() {
                    timeSlot['endTime'] = time;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeRangeField({
    required String label,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required ValueChanged<TimeOfDay> onStartTimeChanged,
    required ValueChanged<TimeOfDay> onEndTimeChanged,
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
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _isEditMode
                    ? () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (time != null) {
                          onStartTimeChanged(time);
                        }
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: _isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 15,
                      color: _isEditMode ? Colors.black87 : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.arrow_forward,
                color: widget.roleColor,
                size: 20,
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: _isEditMode
                    ? () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (time != null) {
                          onEndTimeChanged(time);
                        }
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: _isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 15,
                      color: _isEditMode ? Colors.black87 : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSportsSection(int branchIndex) {
    final branch = _branches[branchIndex];
    final selectedSports = (branch['sports'] as List<String>).toList();
    final displayText = selectedSports.isEmpty
        ? 'Select Sports'
        : selectedSports.join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sports',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _isEditMode
              ? () {
                  final tempSelected = List<String>.from(selectedSports);
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setDialogState) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Select Sports',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Flexible(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _availableSports.length,
                                    itemBuilder: (context, index) {
                                      final sport = _availableSports[index];
                                      final isSelected = tempSelected.contains(sport);
                                      return CheckboxListTile(
                                        title: Text(sport),
                                        value: isSelected,
                                        onChanged: (value) {
                                          setDialogState(() {
                                            if (value == true) {
                                              if (!tempSelected.contains(sport)) {
                                                tempSelected.add(sport);
                                              }
                                            } else {
                                              tempSelected.remove(sport);
                                            }
                                          });
                                        },
                                        activeColor: widget.roleColor,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        branch['sports'] = tempSelected;
                                      });
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: widget.roleColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Done'),
                                  ),
                                ),
                              ],
                            ),
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
              color: _isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 15,
                      color: selectedSports.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (selectedSports.isNotEmpty && _isEditMode) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedSports.map((sport) {
              return Chip(
                label: Text(sport),
                onDeleted: () {
                  setState(() {
                    selectedSports.remove(sport);
                    branch['sports'] = selectedSports;
                  });
                },
                deleteIconColor: widget.roleColor,
                backgroundColor: widget.roleColor.withValues(alpha: 0.1),
                labelStyle: TextStyle(
                  color: widget.roleColor,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
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
          enabled: _isEditMode,
          readOnly: !_isEditMode,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 15,
            color: _isEditMode ? Colors.black87 : Colors.grey.shade700,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: _isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
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
            color: _isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: TextStyle(
                fontSize: 15,
                color: _isEditMode ? Colors.black87 : Colors.grey.shade700,
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: _isEditMode
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
}

