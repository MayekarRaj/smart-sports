import 'package:flutter/material.dart';
import 'merchandiser_page.dart';

class MerchandiserDetailsPage extends StatefulWidget {
  final MerchandiseData merchandise;

  const MerchandiserDetailsPage({super.key, required this.merchandise});

  @override
  State<MerchandiserDetailsPage> createState() =>
      _MerchandiserDetailsPageState();
}

class _MerchandiserDetailsPageState extends State<MerchandiserDetailsPage> {
  int _selectedSpecializationIndex = 0;
  int _selectedExperienceIndex = 0;
  bool _showMoreDetails = false;

  final List<String> _specializations = [
    'Football',
    'Basketball',
    'Tennis',
    'Cricket',
    'Swimming',
  ];
  final List<String> _experienceLevels = [
    'Beginner (0-2 years)',
    'Intermediate (2-5 years)',
    'Advanced (5-10 years)',
    'Expert (10+ years)',
  ];

  final List<TrainingSessionData> _sessions = [
    TrainingSessionData(
      name: 'Morning Training',
      status: 'Available',
      maxStudents: 15,
      duration: '1 hour',
      level: 'Beginner',
      price: 25,
      schedule: {
        'weekdays': '06:00 - 07:00',
        'saturday': '07:00 - 08:00',
        'sunday': '08:00 - 09:00',
      },
      imageUrl: 'assets/images/training1.jpg',
    ),
    TrainingSessionData(
      name: 'Evening Training',
      status: 'Available',
      maxStudents: 20,
      duration: '1.5 hours',
      level: 'Intermediate',
      price: 35,
      schedule: {
        'weekdays': '18:00 - 19:30',
        'saturday': '16:00 - 17:30',
        'sunday': '17:00 - 18:30',
      },
      imageUrl: 'assets/images/training2.jpg',
    ),
    TrainingSessionData(
      name: 'Advanced Training',
      status: 'Available',
      maxStudents: 10,
      duration: '2 hours',
      level: 'Advanced',
      price: 50,
      schedule: {
        'weekdays': '19:30 - 21:30',
        'saturday': '18:00 - 20:00',
        'sunday': '19:00 - 21:00',
      },
      imageUrl: 'assets/images/training3.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.merchandise.name),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF009A69), Color(0xFF232534)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coach Header
            MobileMerchandiseHeader(merchandise: widget.merchandise),

            // Specialization Selection
            MobileSpecializationSelector(
              specializations: _specializations,
              selectedIndex: _selectedSpecializationIndex,
              onSpecializationChanged: (index) =>
                  setState(() => _selectedSpecializationIndex = index),
            ),

            // Experience Level Selection
            MobileExperienceSelector(
              experienceLevels: _experienceLevels,
              selectedIndex: _selectedExperienceIndex,
              onExperienceChanged: (index) =>
                  setState(() => _selectedExperienceIndex = index),
            ),

            // Training Sessions List
            MobileTrainingSessionsList(sessions: _sessions),

            // More Details Section
            MobileMoreDetailsSection(
              showMoreDetails: _showMoreDetails,
              onToggle: () =>
                  setState(() => _showMoreDetails = !_showMoreDetails),
            ),
          ],
        ),
      ),
    );
  }
}

// Mobile Coach Header Component
class MobileMerchandiseHeader extends StatelessWidget {
  final MerchandiseData merchandise;

  const MobileMerchandiseHeader({super.key, required this.merchandise});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coach Name and Rating
          Row(
            children: [
              Expanded(
                child: Text(
                  merchandise.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${merchandise.rating}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                merchandise.location,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Specializations
          const Text(
            'Specializations',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: merchandise.categories
                .map(
                  (specialization) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF232534),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      specialization,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 12),

          // Stats
          Row(
            children: [
              _buildStatChip('Price', '\$${merchandise.price}'),
              const SizedBox(width: 8),
              _buildStatChip('Stock', '${merchandise.stock}'),
              const SizedBox(width: 8),
              _buildStatChip('Discount', '${merchandise.discount}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Mobile Specialization Selector Component
class MobileSpecializationSelector extends StatelessWidget {
  final List<String> specializations;
  final int selectedIndex;
  final ValueChanged<int> onSpecializationChanged;

  const MobileSpecializationSelector({
    super.key,
    required this.specializations,
    required this.selectedIndex,
    required this.onSpecializationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Specialization',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: specializations.asMap().entries.map((entry) {
                final index = entry.key;
                final specialization = entry.value;
                final isSelected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => onSpecializationChanged(index),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF232534)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF232534)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        specialization,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Mobile Experience Selector Component
class MobileExperienceSelector extends StatelessWidget {
  final List<String> experienceLevels;
  final int selectedIndex;
  final ValueChanged<int> onExperienceChanged;

  const MobileExperienceSelector({
    super.key,
    required this.experienceLevels,
    required this.selectedIndex,
    required this.onExperienceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Experience Level',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: experienceLevels.asMap().entries.map((entry) {
                final index = entry.key;
                final experience = entry.value;
                final isSelected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => onExperienceChanged(index),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2C3BC5)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2C3BC5)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        experience,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Mobile Training Sessions List Component
class MobileTrainingSessionsList extends StatelessWidget {
  final List<TrainingSessionData> sessions;

  const MobileTrainingSessionsList({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Training Sessions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...sessions
              .map((session) => MobileTrainingSessionCard(session: session))
              .toList(),
        ],
      ),
    );
  }
}

// Mobile Training Session Card Component
class MobileTrainingSessionCard extends StatelessWidget {
  final TrainingSessionData session;

  const MobileTrainingSessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: const Icon(
                Icons.fitness_center,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),

          // Session Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Session Name and Status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        session.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Available',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Session Metrics
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'MAX STUDENTS',
                        '${session.maxStudents}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricCard('DURATION', session.duration),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMetricCard('LEVEL', session.level)),
                  ],
                ),

                const SizedBox(height: 12),

                // Price
                const Text(
                  'PRICE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232534),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '\$${session.price}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Schedule
                _buildScheduleItem('Weekdays', session.schedule['weekdays']!),
                const SizedBox(height: 8),
                _buildScheduleItem('Saturday', session.schedule['saturday']!),
                const SizedBox(height: 8),
                _buildScheduleItem(
                  'Sunday & National Holidays',
                  session.schedule['sunday']!,
                ),

                const SizedBox(height: 16),

                // Book Session Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF232534),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'BOOK SESSION',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF232534).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF232534),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String label, String time) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF232534).withOpacity(0.3)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            time,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// Mobile More Details Section Component
class MobileMoreDetailsSection extends StatelessWidget {
  final bool showMoreDetails;
  final VoidCallback onToggle;

  const MobileMoreDetailsSection({
    super.key,
    required this.showMoreDetails,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // More Details Header
          InkWell(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    'More Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Icon(
                    showMoreDetails
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),

          // More Details Content
          if (showMoreDetails) ...[
            const SizedBox(height: 16),

            // Coaches Section
            MobileCoachesSection(),

            const SizedBox(height: 16),

            // Billing Method Section
            MobileBillingSection(),

            const SizedBox(height: 16),

            // Guest Seating Section
            MobileGuestSeatingSection(),

            const SizedBox(height: 16),

            // Sponsorship Section
            MobileSponsorshipSection(),
          ],
        ],
      ),
    );
  }
}

// Mobile Coaches Section Component
class MobileCoachesSection extends StatelessWidget {
  const MobileCoachesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Coaches',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Upgrade To Unlock Coach Ratings And Reviews',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Coach Cards
          ...List.generate(
            3,
            (index) => MobileCoachCard(
              name: 'Riya Mehra',
              rating: 3.8,
              specialization: 'Football (U17), Tennis, Strength & Conditioning',
              experience: '5+ Years, Former National Player',
              certification: 'AIFF D-License, NASM CPT, First-Aid Certified',
              availability: 'Weekdays 6-9 PM, Weekends Full Day',
              distance: '5 Miles From Event Venue',
              rate: 'USD 50',
              isBlocked: index == 1,
            ),
          ),
        ],
      ),
    );
  }
}

// Mobile Coach Card Component
class MobileCoachCard extends StatelessWidget {
  final String name;
  final double rating;
  final String specialization;
  final String experience;
  final String certification;
  final String availability;
  final String distance;
  final String rate;
  final bool isBlocked;

  const MobileCoachCard({
    super.key,
    required this.name,
    required this.rating,
    required this.specialization,
    required this.experience,
    required this.certification,
    required this.availability,
    required this.distance,
    required this.rate,
    required this.isBlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            size: 12,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('$rating', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBlocked ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  isBlocked ? 'Block' : 'Unblock',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            specialization,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            experience,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            certification,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            'Language: English',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            availability,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            distance,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            'Rate: $rate',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Mobile Billing Section Component
class MobileBillingSection extends StatelessWidget {
  const MobileBillingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Billing Method',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._buildBillingItems(),
        ],
      ),
    );
  }

  List<Widget> _buildBillingItems() {
    final items = [
      {'meter': 'Per 30 Minutes', 'charge': 'USD 10'},
      {'meter': 'Per Hour', 'charge': 'USD 18'},
      {'meter': 'Per Day', 'charge': 'USD 50'},
      {'meter': 'Per Week', 'charge': 'USD 300'},
      {'meter': 'Per Month', 'charge': 'USD 1000'},
    ];

    return items
        .map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item['meter']!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['charge']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}

// Mobile Guest Seating Section Component
class MobileGuestSeatingSection extends StatelessWidget {
  const MobileGuestSeatingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guest Seating Available',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Max Guest Capacity 100',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Mobile Sponsorship Section Component
class MobileSponsorshipSection extends StatelessWidget {
  const MobileSponsorshipSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sponsorship\'s Available For This Club',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._buildSponsorshipItems(),
        ],
      ),
    );
  }

  List<Widget> _buildSponsorshipItems() {
    final items = [
      {'type': 'Bill Board', 'meter': 'Per Year'},
      {'type': 'Shoes', 'meter': 'Per Day'},
      {'type': 'Uniform', 'meter': 'Per Week'},
    ];

    return items
        .map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item['type']!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['meter']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}

// Data models
class CoachData {
  final String name;
  final double rating;
  final String location;
  final List<String> specializations;
  final int experience;
  final int students;
  final int hourlyRate;

  CoachData({
    required this.name,
    required this.rating,
    required this.location,
    required this.specializations,
    required this.experience,
    required this.students,
    required this.hourlyRate,
  });
}

class TrainingSessionData {
  final String name;
  final String status;
  final int maxStudents;
  final String duration;
  final String level;
  final int price;
  final Map<String, String> schedule;
  final String imageUrl;

  TrainingSessionData({
    required this.name,
    required this.status,
    required this.maxStudents,
    required this.duration,
    required this.level,
    required this.price,
    required this.schedule,
    required this.imageUrl,
  });
}
