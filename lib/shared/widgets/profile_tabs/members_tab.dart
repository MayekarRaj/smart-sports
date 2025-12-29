import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/member_card.dart';

class MembersTab extends StatefulWidget {
  final Color roleColor;
  final bool isMobile;

  const MembersTab({
    super.key,
    required this.roleColor,
    required this.isMobile,
  });

  @override
  State<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  // Members tab gradient - uses role color
  LinearGradient get _membersGradient => LinearGradient(
    colors: [widget.roleColor.withValues(alpha: 0.8), widget.roleColor],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  bool _isEditMode = false;
  int _numberOfFamilyMembers = 1;
  final List<Map<String, dynamic>> _members = [];
  final _numberOfMembersController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    _numberOfMembersController.addListener(_onNumberOfMembersChanged);
    _initializeMembers();
  }

  @override
  void dispose() {
    _numberOfMembersController.dispose();
    super.dispose();
  }

  void _onNumberOfMembersChanged() {
    final text = _numberOfMembersController.text;
    if (text.isEmpty) return;

    final count = int.tryParse(text);
    if (count != null &&
        count > 0 &&
        count <= 20 &&
        count != _numberOfFamilyMembers) {
      _updateNumberOfMembers(count);
    }
  }

  void _initializeMembers() {
    _members.clear();
    for (int i = 0; i < _numberOfFamilyMembers; i++) {
      _members.add({
        'id': i,
        'isHead': i == 0,
        'firstName': i == 0 ? 'Emily' : 'Member ${i + 1}',
        'lastName': i == 0 ? 'Davis' : 'Last Name',
        'email': i == 0
            ? 'emily.davis@example.com'
            : 'member${i + 1}@example.com',
        'dateOfBirth': DateTime.now().subtract(Duration(days: 365 * (25 + i))),
        'gender': 'Male',
        'contactNumber': '+1-9876543210',
        'countryCode': '+1',
        'membershipType': 'Adult',
        'sportsInterested': <String>[],
        'addressSameAsSignUp': true,
        'practicePlanSameAsMain': true,
        'preferredClubsSameAsMain': true,
        'address': {
          'line1': '',
          'line2': '',
          'city': 'New York',
          'state': 'New York',
          'zipCode': '',
          'country': 'United States',
        },
        'practicePlans': <Map<String, dynamic>>[],
        'preferredClubs': <String>[],
        'distance': 5.0,
      });
    }
  }

  void _updateNumberOfMembers(int count) {
    setState(() {
      _numberOfFamilyMembers = count;
      if (_numberOfMembersController.text != count.toString()) {
        _numberOfMembersController.text = count.toString();
      }
      _initializeMembers();
    });
  }

  void _updateMember(int index, Map<String, dynamic> updatedMember) {
    setState(() {
      _members[index] = updatedMember;
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
                      content: Text(
                        _isEditMode ? 'Changes saved' : 'Edit mode enabled',
                      ),
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
          // Number of Family Members Section
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: _membersGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.people_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          _membersGradient.createShader(bounds),
                      child: const Text(
                        'Family Members',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Number of Family Members',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _numberOfMembersController,
                            enabled: _isEditMode,
                            readOnly: !_isEditMode,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              fontSize: 15,
                              color: _isEditMode
                                  ? Colors.black87
                                  : Colors.grey.shade700,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: _isEditMode
                                  ? Colors.grey.shade50
                                  : Colors.grey.shade100,
                              hintText: 'Enter number (1-20)',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a number';
                              }
                              final count = int.tryParse(value);
                              if (count == null || count < 1 || count > 20) {
                                return 'Enter a number between 1 and 20';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Members List
          ...List.generate(_members.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: MemberCard(
                roleColor: widget.roleColor,
                isMobile: widget.isMobile,
                member: _members[index],
                isHead: index == 0,
                useMembersGradient: true,
                isEditMode: _isEditMode,
                onUpdate: (updatedMember) {
                  _updateMember(index, updatedMember);
                },
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
