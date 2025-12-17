import 'package:flutter/material.dart';

class CourtBookingPage extends StatefulWidget {
  final String courtName;
  final String branchName;

  const CourtBookingPage({
    super.key,
    required this.courtName,
    required this.branchName,
  });

  @override
  State<CourtBookingPage> createState() => _CourtBookingPageState();
}

class _CourtBookingPageState extends State<CourtBookingPage> {
  int _selectedDateIndex = 0;
  int _selectedSlotType = 0; // 0: Full Slot, 1: Privilege Slot, 2: General Slot
  bool _showBookingForm = false;

  final List<String> _dates = ['Today', 'Tomorrow', 'Day After', 'Next Week'];

  final List<String> _slotTypes = [
    'Full Slot',
    'Privilege Slot',
    'General Slot',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.courtName} - ${widget.branchName}'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_today)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Court Header
            MobileCourtHeader(
              courtName: widget.courtName,
              branchName: widget.branchName,
            ),

            // Date Selection
            MobileDateSelector(
              dates: _dates,
              selectedIndex: _selectedDateIndex,
              onDateChanged: (index) =>
                  setState(() => _selectedDateIndex = index),
            ),

            // Slot Type Tabs
            MobileSlotTypeTabs(
              slotTypes: _slotTypes,
              selectedIndex: _selectedSlotType,
              onSlotTypeChanged: (index) =>
                  setState(() => _selectedSlotType = index),
            ),

            // Calendar Section
            MobileCalendarSection(
              selectedDateIndex: _selectedDateIndex,
              onDateSelected: (dateIndex) =>
                  setState(() => _selectedDateIndex = dateIndex),
            ),

            // Booking Status
            MobileBookingStatus(),

            // Available Slots
            MobileAvailableSlots(
              slotType: _slotTypes[_selectedSlotType],
              onSlotSelected: (slot) => _showSlotDetails(slot),
            ),

            // Booking Form (if slot selected)
            if (_showBookingForm)
              MobileBookingForm(
                onClose: () => setState(() => _showBookingForm = false),
                onConfirm: () => _confirmBooking(),
              ),
          ],
        ),
      ),
    );
  }

  void _showSlotDetails(Map<String, dynamic> slot) {
    setState(() => _showBookingForm = true);
  }

  void _confirmBooking() {
    // Handle booking confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking confirmed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    setState(() => _showBookingForm = false);
  }
}

// Mobile Court Header Component
class MobileCourtHeader extends StatelessWidget {
  final String courtName;
  final String branchName;

  const MobileCourtHeader({
    super.key,
    required this.courtName,
    required this.branchName,
  });

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
          // Court Image
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=800',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.sports_basketball,
                      size: 60,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courtName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      branchName,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: Colors.white, size: 8),
                    SizedBox(width: 4),
                    Text(
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
          const SizedBox(height: 16),
          // COACH Section
          const Text(
            'COACH',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildCoachAvatar(
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
              ),
              Transform.translate(
                offset: const Offset(-8, 0),
                child: _buildCoachAvatar(
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
                ),
              ),
              Transform.translate(
                offset: const Offset(-16, 0),
                child: _buildCoachAvatar(
                  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
                ),
              ),
              Transform.translate(
                offset: const Offset(-24, 0),
                child: _buildCoachAvatar(
                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Court Stats
          Row(
            children: [
              _buildStatCard('Max Players', '30'),
              const SizedBox(width: 8),
              _buildStatCard('Max Teams', '3'),
              const SizedBox(width: 8),
              _buildStatCard('Guest Cap', '300'),
            ],
          ),

          const SizedBox(height: 16),

          // Schedule
          const Text(
            'Schedule',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildScheduleItem('Weekdays', '08:30 - 22:00'),
          const SizedBox(height: 4),
          _buildScheduleItem('Saturday', '11:30 - 20:00'),
          const SizedBox(height: 4),
          _buildScheduleItem('Sunday & Holidays', 'Off'),
        ],
      ),
    );
  }

  Widget _buildCoachAvatar(String imageUrl) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade300,
              child: const Icon(Icons.person, size: 30, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.blue,
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
      ),
    );
  }

  Widget _buildScheduleItem(String label, String time) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
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

// Mobile Date Selector Component
class MobileDateSelector extends StatelessWidget {
  final List<String> dates;
  final int selectedIndex;
  final ValueChanged<int> onDateChanged;

  const MobileDateSelector({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Date',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: dates.asMap().entries.map((entry) {
                final index = entry.key;
                final date = entry.value;
                final isSelected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => onDateChanged(index),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        date,
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

// Mobile Slot Type Tabs Component
class MobileSlotTypeTabs extends StatelessWidget {
  final List<String> slotTypes;
  final int selectedIndex;
  final ValueChanged<int> onSlotTypeChanged;

  const MobileSlotTypeTabs({
    super.key,
    required this.slotTypes,
    required this.selectedIndex,
    required this.onSlotTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Slot Types',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: slotTypes.asMap().entries.map((entry) {
              final index = entry.key;
              final slotType = entry.value;
              final isSelected = selectedIndex == index;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => onSlotTypeChanged(index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        slotType,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Mobile Booking Status Component
class MobileBookingStatus extends StatelessWidget {
  const MobileBookingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          const Text(
            'Booking Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatusChip('Available', 18, Colors.green),
              const SizedBox(width: 8),
              _buildStatusChip('Booked', 9, Colors.blueGrey),
              const SizedBox(width: 8),
              _buildStatusChip('Maintenance', 3, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mobile Available Slots Component
class MobileAvailableSlots extends StatelessWidget {
  final String slotType;
  final Function(Map<String, dynamic>) onSlotSelected;

  const MobileAvailableSlots({
    super.key,
    required this.slotType,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available $slotType',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSlotGrid(),
        ],
      ),
    );
  }

  Widget _buildSlotGrid() {
    final slots = _getSlotsForType(slotType);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.5,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        return _buildSlotCard(slot);
      },
    );
  }

  Widget _buildSlotCard(Map<String, dynamic> slot) {
    return InkWell(
      onTap: () => onSlotSelected(slot),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: slot['available']
              ? Colors.green.shade50
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: slot['available'] ? Colors.green : Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    slot['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: slot['available'] ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    slot['available'] ? 'Available' : 'Booked',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              slot['time'],
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              slot['price'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getSlotsForType(String type) {
    switch (type) {
      case 'Full Slot':
        return [
          {
            'title': 'Full Month',
            'time': 'All Day',
            'price': 'USD 1000',
            'available': true,
          },
          {
            'title': 'Full Week',
            'time': 'Mon-Sun',
            'price': 'USD 300',
            'available': true,
          },
          {
            'title': 'Full Day',
            'time': '08:00-22:00',
            'price': 'USD 50',
            'available': false,
          },
          {
            'title': 'Full Session',
            'time': 'Morning',
            'price': 'USD 25',
            'available': true,
          },
        ];
      case 'Privilege Slot':
        return [
          {
            'title': 'VIP Month',
            'time': 'All Day',
            'price': 'USD 1500',
            'available': true,
          },
          {
            'title': 'VIP Week',
            'time': 'Mon-Sun',
            'price': 'USD 500',
            'available': true,
          },
          {
            'title': 'VIP Day',
            'time': '08:00-22:00',
            'price': 'USD 80',
            'available': true,
          },
          {
            'title': 'VIP Session',
            'time': 'Evening',
            'price': 'USD 40',
            'available': false,
          },
        ];
      case 'General Slot':
        return [
          {
            'title': 'Morning Slot',
            'time': '06:00-12:00',
            'price': 'USD 15',
            'available': true,
          },
          {
            'title': 'Afternoon Slot',
            'time': '12:00-18:00',
            'price': 'USD 18',
            'available': true,
          },
          {
            'title': 'Evening Slot',
            'time': '18:00-22:00',
            'price': 'USD 20',
            'available': false,
          },
          {
            'title': 'Night Slot',
            'time': '22:00-06:00',
            'price': 'USD 12',
            'available': true,
          },
        ];
      default:
        return [];
    }
  }
}

// Mobile Booking Form Component
class MobileBookingForm extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onConfirm;

  const MobileBookingForm({
    super.key,
    required this.onClose,
    required this.onConfirm,
  });

  @override
  State<MobileBookingForm> createState() => _MobileBookingFormState();
}

class _MobileBookingFormState extends State<MobileBookingForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  int _selectedPlayers = 1;
  bool _guestSeating = false;

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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Booking Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Name is required' : null,
            ),

            const SizedBox(height: 12),

            // Phone Field
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Phone is required' : null,
            ),

            const SizedBox(height: 12),

            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Email is required' : null,
            ),

            const SizedBox(height: 16),

            // Number of Players
            const Text(
              'Number of Players',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: _selectedPlayers > 1
                      ? () => setState(() => _selectedPlayers--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_selectedPlayers',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _selectedPlayers < 30
                      ? () => setState(() => _selectedPlayers++)
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Guest Seating
            Row(
              children: [
                const Text(
                  'Guest Seating',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Switch(
                  value: _guestSeating,
                  onChanged: (value) => setState(() => _guestSeating = value),
                ),
              ],
            ),

            if (_guestSeating) ...[
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Number of Guests',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {},
              ),
            ],

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onClose,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        widget.onConfirm();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Confirm Booking'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

// Mobile Calendar Section Component
class MobileCalendarSection extends StatefulWidget {
  final int selectedDateIndex;
  final ValueChanged<int> onDateSelected;

  const MobileCalendarSection({
    super.key,
    required this.selectedDateIndex,
    required this.onDateSelected,
  });

  @override
  State<MobileCalendarSection> createState() => _MobileCalendarSectionState();
}

class _MobileCalendarSectionState extends State<MobileCalendarSection> {
  DateTime _currentMonth = DateTime(2025, 3, 1); // March 2025
  int _selectedDay = 11; // Default selected day

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
          // Calendar Header
          Row(
            children: [
              IconButton(
                onPressed: () => _previousMonth(),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  'March 2025',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _nextMonth(),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Calendar Grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(2025, 3, 0).day; // Days in March 2025
    final firstDayOfMonth = DateTime(2025, 3, 1).weekday; // Monday = 1

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.2,
      ),
      itemCount: 35, // 5 weeks * 7 days
      itemBuilder: (context, index) {
        final dayNumber = index - firstDayOfMonth + 2;
        final isCurrentMonth = dayNumber > 0 && dayNumber <= daysInMonth;
        final isSelected = isCurrentMonth && dayNumber == _selectedDay;
        final isAvailable = isCurrentMonth && _isDateAvailable(dayNumber);

        if (!isCurrentMonth) {
          return Container(); // Empty cell for days outside current month
        }

        return InkWell(
          onTap: isAvailable ? () => _selectDate(dayNumber) : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.orange
                  : isAvailable
                  ? Colors.green
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$dayNumber',
              style: TextStyle(
                color: isSelected || isAvailable
                    ? Colors.white
                    : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isDateAvailable(int day) {
    // Define available dates (green dates from the image)
    final availableDates = [
      2,
      3,
      4,
      6,
      7,
      8,
      10,
      12,
      14,
      15,
      16,
      18,
      19,
      20,
      22,
      23,
      24,
      26,
      27,
      28,
      30,
      31,
    ];
    return availableDates.contains(day);
  }

  void _selectDate(int day) {
    setState(() {
      _selectedDay = day;
    });
    // Update the parent widget with the selected date
    widget.onDateSelected(day - 1); // Convert to 0-based index
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }
}
