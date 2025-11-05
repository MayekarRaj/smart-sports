import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../role_specific/common/role_router.dart';
import 'payment_details_screen.dart';

class SponsorshipScreen extends StatefulWidget {
  final String selectedClub;
  final String selectedSport;
  final String selectedArea;
  final DateTime selectedDate;
  final RangeValues distanceRange;
  final UserRole? role;

  const SponsorshipScreen({
    Key? key,
    required this.selectedClub,
    required this.selectedSport,
    required this.selectedArea,
    required this.selectedDate,
    required this.distanceRange,
    this.role,
  }) : super(key: key);

  @override
  State<SponsorshipScreen> createState() => _SponsorshipScreenState();
}

class _SponsorshipScreenState extends State<SponsorshipScreen> {
  bool isSponsorshipApplicable = true;
  List<bool> sponsorshipTypes = [
    true,
    true,
    false,
    false,
  ]; // Corporate, Merchandise, Coach, Members
  List<bool> selectedSponsorships = List.filled(
    9,
    true,
  ); // All initially selected
  List<int> maxNumbers = List.filled(9, 1);
  List<int> costs = List.filled(9, 50000);

  final List<Map<String, dynamic>> sponsorships = [
    {
      'title': 'Title/Main Sponsorship',
      'description':
          'Massive Brand Exposure Across All Event Materials, Press, Banners, Jerseys, And Digital Platforms. ABC Sports Cup 2025 Presented By BrandX',
    },
    {
      'title': 'Category/Segment Sponsorship',
      'description':
          'Tailored Promotions And Association With A Specific Product Or Service \'Official Beverage Partner\' Or \'Technology Partner\'',
    },
    {
      'title': 'Team Or Player Sponsorship',
      'description':
          'Logo Placement On Team Jerseys Or Gear TV/In-Person Exposure, Especially If Teams Or Players Are Popular.',
    },
    {
      'title': 'Merchandise Or Product Sponsorship',
      'description':
          'Providing Water Bottles, T-Shirts, Or Kits With Your Branding Tangible Product Experience + Visibility',
    },
    {
      'title': 'Venue Branding Sponsorship',
      'description':
          'Visual Branding (Banners, Backdrops, Entry Gates, Etc.) High Impact On The Crowd + Great For Media Coverage Shots',
    },
    {
      'title': 'Digital/Media Sponsorship',
      'description':
          'Sponsored Instagram Stories, Event Live Stream, Or App Sponsor Engages Online Viewers, Good For Performance Tracking (Clicks, Views)',
    },
    {
      'title': 'Hospitality Or Experience Zone Sponsorship',
      'description':
          'Food Lounges, Fan Interaction Zones, VIP Areas Lifestyle And Luxury Brands',
    },
    {
      'title': 'Seat Or Section Sponsorship',
      'description':
          'Great For Creating Memorable Experiences Linked To The Brand \'BrandX Fan Zone\' Or \'VIP Zone By XYZ\'',
    },
    {
      'title': 'Post-Event Sponsorship',
      'description':
          'Awards Night, Highlights Reel, Or Thank-You Kits Extended Engagement And Content Opportunities',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Sponsorship Options',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: widget.role != null ? null : const Color(0xFF007BFF),
        flexibleSpace: widget.role != null
            ? Container(
                decoration: BoxDecoration(
                  gradient: _getRoleGradient(widget.role!),
                ),
              )
            : null,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sponsorship Section
            _buildSponsorshipSection(),
            const SizedBox(height: 80), // Space for bottom buttons
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Prev',
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007BFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Book',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSponsorshipSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Sponsorship\'s Available For This Club',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Unlock Sponsorships By Upgrading Now.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: _upgradeSponsorships,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    child: Text(
                      'Upgrade',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Is Sponsorship Applicable?
          Row(
            children: [
              Text(
                'Is Sponsorship Applicable?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 12),

          // Radio Buttons
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: isSponsorshipApplicable,
                onChanged: (value) {
                  setState(() {
                    isSponsorshipApplicable = value ?? true;
                  });
                },
                activeColor: const Color(0xFF007BFF),
              ),
              Text(
                'Yes',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(width: 24),
              Radio<bool>(
                value: false,
                groupValue: isSponsorshipApplicable,
                onChanged: (value) {
                  setState(() {
                    isSponsorshipApplicable = value ?? false;
                  });
                },
                activeColor: const Color(0xFF007BFF),
              ),
              Text(
                'No',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sponsorship Type Checkboxes
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildSponsorshipTypeCheckbox('Corporate', 0),
              _buildSponsorshipTypeCheckbox('Merchandise', 1),
              _buildSponsorshipTypeCheckbox('Coach', 2),
              _buildSponsorshipTypeCheckbox('Members', 3),
            ],
          ),
          const SizedBox(height: 20),

          // Sponsorship List
          ...sponsorships.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> sponsorship = entry.value;
            return _buildSponsorshipCard(index, sponsorship);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSponsorshipTypeCheckbox(String label, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: sponsorshipTypes[index],
          onChanged: (value) {
            setState(() {
              sponsorshipTypes[index] = value ?? false;
            });
          },
          activeColor: const Color(0xFF007BFF),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildSponsorshipCard(int index, Map<String, dynamic> sponsorship) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Checkbox
          Row(
            children: [
              Checkbox(
                value: selectedSponsorships[index],
                onChanged: (value) {
                  setState(() {
                    selectedSponsorships[index] = value ?? false;
                  });
                },
                activeColor: const Color(0xFF007BFF),
              ),
              Expanded(
                child: Text(
                  sponsorship['title'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            sponsorship['description'],
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Max No. and Cost Inputs
          Row(
            children: [
              // Max No. Input
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Max No.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      initialValue: maxNumbers[index].toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          maxNumbers[index] = int.tryParse(value) ?? 1;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Cost Input
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cost',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Currency Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'USD',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Cost Input Field
                        Expanded(
                          child: TextFormField(
                            initialValue: costs[index].toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                costs[index] = int.tryParse(value) ?? 50000;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
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
        ],
      ),
    );
  }

  void _upgradeSponsorships() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Upgrade to unlock premium sponsorship options!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleBook() {
    final selectedCount = selectedSponsorships
        .where((selected) => selected)
        .length;
    final totalCost = selectedSponsorships
        .asMap()
        .entries
        .where((entry) => entry.value)
        .fold(0, (sum, entry) => sum + costs[entry.key]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sponsorship selection completed! Proceeding to payment...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // Navigate to payment details screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentDetailsScreen(
          selectedClub: widget.selectedClub,
          selectedSport: widget.selectedSport,
          selectedArea: widget.selectedArea,
          selectedDate: widget.selectedDate,
          distanceRange: widget.distanceRange,
          role: widget.role,
        ),
      ),
    );
  }

  LinearGradient _getRoleGradient(UserRole role) {
    switch (role) {
      case UserRole.club:
        return const LinearGradient(
          colors: [Color(0xFF283048), Color(0xFF859398)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.coach:
        return const LinearGradient(
          colors: [Color(0xFF232534), Color(0xFF2C3BC5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.corporate:
        return const LinearGradient(
          colors: [Color(0xFF232534), Color(0xFF414384)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.merchandiser:
        return const LinearGradient(
          colors: [Color(0xFF009A69), Color(0xFF232534)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.member:
        return const LinearGradient(
          colors: [Color(0xFF283048), Color(0xFF859398)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.freelancer:
        return const LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFF0056CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}
