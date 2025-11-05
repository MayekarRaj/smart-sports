import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomizeSlotsDialog extends StatefulWidget {
  const CustomizeSlotsDialog({Key? key}) : super(key: key);

  @override
  State<CustomizeSlotsDialog> createState() => _CustomizeSlotsDialogState();
}

class _CustomizeSlotsDialogState extends State<CustomizeSlotsDialog> {
  bool isSingleSlot = false;
  bool isMultipleSlot = true;
  String selectedFrequency = 'Every Day';
  List<bool> selectedDays = [
    true,
    false,
    false,
    false,
    false,
    false,
    true,
  ]; // Sun, Mon, Tue, Wed, Thu, Fri, Sat

  final TextEditingController startDateController = TextEditingController(
    text: 'Wed, March 5, 2025',
  );
  final TextEditingController endDateController = TextEditingController(
    text: 'Fri, March 7, 2025',
  );
  final TextEditingController startTimeController = TextEditingController(
    text: '08:00 AM',
  );
  final TextEditingController endTimeController = TextEditingController(
    text: '10:30 AM',
  );

  final List<String> frequencies = ['Every Day', 'Every Week', 'Every Month'];
  final List<String> weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Customize Slots',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Slot Type Selection
            _buildSlotTypeSelection(),
            const SizedBox(height: 24),

            // Repetition Frequency
            _buildFrequencySelection(),
            const SizedBox(height: 24),

            // Day of Week Selection
            _buildDaySelection(),
            const SizedBox(height: 24),

            // Date Range Input
            _buildDateRangeInput(),
            const SizedBox(height: 20),

            // Time Range Input
            _buildTimeRangeInput(),
            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Book Single Slot
        Row(
          children: [
            Checkbox(
              value: isSingleSlot,
              onChanged: (value) {
                setState(() {
                  isSingleSlot = value ?? false;
                  if (isSingleSlot) {
                    isMultipleSlot = false;
                  }
                });
              },
              activeColor: const Color(0xFF007BFF),
            ),
            Text(
              'Book Single Slot',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Book Multiple Repeated Slot
        Row(
          children: [
            Checkbox(
              value: isMultipleSlot,
              onChanged: (value) {
                setState(() {
                  isMultipleSlot = value ?? false;
                  if (isMultipleSlot) {
                    isSingleSlot = false;
                  }
                });
              },
              activeColor: const Color(0xFF007BFF),
            ),
            Text(
              'Book Multiple Repeated Slot',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFrequencySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repetition Frequency',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: frequencies.map((frequency) {
            final isSelected = selectedFrequency == frequency;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFrequency = frequency;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? const Color(0xFF007BFF)
                        : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black87,
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF007BFF)
                          : Colors.black,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 0,
                  ),
                  child: Text(
                    frequency,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDaySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Days',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isNarrow = screenWidth < 400;

            if (isNarrow) {
              // For narrow screens, show days in a vertical list
              return Column(
                children: weekDays.asMap().entries.map((entry) {
                  int index = entry.key;
                  String day = entry.value;
                  final isSelected = selectedDays[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              selectedDays[index] = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF007BFF),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          day,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            } else {
              // For wider screens, use a more flexible layout
              return Wrap(
                spacing: 6,
                runSpacing: 8,
                children: weekDays.asMap().entries.map((entry) {
                  int index = entry.key;
                  String day = entry.value;
                  final isSelected = selectedDays[index];
                  return Container(
                    constraints: BoxConstraints(
                      minWidth: 60,
                      maxWidth: (screenWidth - 40) / 3, // More flexible width
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              selectedDays[index] = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF007BFF),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            day,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildDateRangeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Start Date
        _buildDateField('Start Date', startDateController),
        const SizedBox(height: 16),
        // End Date
        _buildDateField('End Date', endDateController),
      ],
    );
  }

  Widget _buildTimeRangeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Start Time
        _buildTimeField('Start Time', startTimeController),
        const SizedBox(height: 16),
        // End Time
        _buildTimeField('End Time', endTimeController),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF007BFF)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF007BFF)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Cancel Button
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Next Button
        Expanded(
          child: ElevatedButton(
            onPressed: _handleNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007BFF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              'Next',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleNext() {
    // Validate form
    if (startDateController.text.isEmpty ||
        endDateController.text.isEmpty ||
        startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all date and time fields',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Check if at least one day is selected
    if (!selectedDays.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select at least one day',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Slot customization completed! Frequency: $selectedFrequency',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // Close dialog
    Navigator.of(context).pop();
  }
}
