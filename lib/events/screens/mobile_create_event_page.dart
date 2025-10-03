import 'package:flutter/material.dart';
import '../widgets/mobile_event_header.dart';
import '../widgets/mobile_form_section.dart';

class MobileCreateEventPage extends StatefulWidget {
  final bool showAppBar;
  const MobileCreateEventPage({super.key, this.showAppBar = true});

  @override
  State<MobileCreateEventPage> createState() => _MobileCreateEventPageState();
}

class _MobileCreateEventPageState extends State<MobileCreateEventPage> {
  // Form controllers
  final TextEditingController _organizerNameController =
      TextEditingController();
  final TextEditingController _clubAddressController = TextEditingController();
  final TextEditingController _eventAddressController = TextEditingController();

  // Form state
  bool _isOrganizerLoggedIn = true;
  bool _eventLocationSameAsClub = true;
  bool _sponsorshipApplicable = false;
  List<String> _selectedSports = ['Cricket', 'Tennis', 'Basketball'];
  final List<String> _selectedSponsorshipParties = [];
  final DateTime _eventDate = DateTime.now().add(const Duration(days: 28));
  final DateTime _registrationLastDate = DateTime.now().add(
    const Duration(days: 27),
  );

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    _organizerNameController.text = 'Elite Sports Arena';
    _clubAddressController.text = 'Los Angeles, CA';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text(
                'Events / Tournaments',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // Handle menu tap
                },
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            const Text(
              'Create Event',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Event Header Card
            MobileEventHeader(
              title: 'Brown Country Tournament',
              venue: 'Elite Sports Arena',
              location: 'Los Angeles, CA',
              selectedSports: _selectedSports,
              onSportsChanged: (sports) {
                setState(() {
                  _selectedSports = sports;
                });
              },
              eventDate: _eventDate,
              registrationLastDate: _registrationLastDate,
              organizerName: 'Miles King',
              organizerEmail: 'elijahscott@gmail.com',
              onConnect: () {
                _showSnackBar('Opening organiser profile...');
              },
            ),
            const SizedBox(height: 24),

            // Organizer Section
            MobileFormSection(
              title: 'Organizer',
              child: Column(
                children: [
                  MobileToggleSection(
                    title: 'Organizer is logged in',
                    description: '',
                    value: _isOrganizerLoggedIn,
                    onChanged: (value) {
                      setState(() {
                        _isOrganizerLoggedIn = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  MobileTextField(
                    label: 'Organizer Name',
                    controller: _organizerNameController,
                    hint: 'Enter organizer name',
                  ),
                ],
              ),
            ),

            // Event Location Section
            MobileFormSection(
              title: 'Event Location',
              child: Column(
                children: [
                  MobileTextField(
                    label: 'Club Address',
                    controller: _clubAddressController,
                    hint: 'Enter club address',
                  ),
                  const SizedBox(height: 16),
                  MobileToggleSection(
                    title: 'Event location same as club address',
                    description: '',
                    value: _eventLocationSameAsClub,
                    onChanged: (value) {
                      setState(() {
                        _eventLocationSameAsClub = value;
                      });
                    },
                    child: !_eventLocationSameAsClub
                        ? MobileTextField(
                            label: 'Event Address',
                            controller: _eventAddressController,
                            hint: 'Enter event address',
                          )
                        : null,
                  ),
                ],
              ),
            ),

            // Sponsorship Section
            MobileFormSection(
              title: 'Sponsorship',
              child: MobileToggleSection(
                title: 'Sponsorship Applicable',
                description:
                    'Enable if you want to accept sponsorships for this event',
                value: _sponsorshipApplicable,
                onChanged: (value) {
                  setState(() {
                    _sponsorshipApplicable = value;
                  });
                },
                child: _sponsorshipApplicable
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sponsorship Parties',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              _buildSponsorshipChip('Merchandiser'),
                              _buildSponsorshipChip('Corporate'),
                            ],
                          ),
                        ],
                      )
                    : null,
              ),
            ),

            // Action Buttons
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showSnackBar('Event saved as draft');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    child: const Text(
                      'Save Draft',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showSnackBar('Event published successfully!');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Publish Event',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSponsorshipChip(String label) {
    final isSelected = _selectedSponsorshipParties.contains(label);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            if (!isSelected) _selectedSponsorshipParties.add(label);
          } else {
            _selectedSponsorshipParties.remove(label);
          }
        });
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue.shade600,
      labelStyle: TextStyle(
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _organizerNameController.dispose();
    _clubAddressController.dispose();
    _eventAddressController.dispose();
    super.dispose();
  }
}
