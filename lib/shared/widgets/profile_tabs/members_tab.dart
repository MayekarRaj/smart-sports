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

  // Members tab gradient colors
  static const Color _gradientStart = Color(0xFF232534);
  static const Color _gradientEnd = Color(0xFF009A69);
  static const LinearGradient _membersGradient = LinearGradient(
    colors: [_gradientStart, _gradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  State<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
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
                        gradient: MembersTab._membersGradient,
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
                          MembersTab._membersGradient.createShader(bounds),
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
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade50,
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
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: MembersTab._gradientEnd,
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
