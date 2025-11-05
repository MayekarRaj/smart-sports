import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterBar extends StatefulWidget {
  final Function(String eventName) onEventNameChanged;
  final Function(DateTimeRange? dateRange) onDateRangeChanged;
  final Function(TimeOfDay? startTime, TimeOfDay? endTime) onTimeRangeChanged;
  final Function(String days) onDaysChanged;
  final Function(String status) onStatusChanged;

  const FilterBar({
    Key? key,
    required this.onEventNameChanged,
    required this.onDateRangeChanged,
    required this.onTimeRangeChanged,
    required this.onDaysChanged,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  bool _isExpanded = false;
  String _selectedEventName = 'Cricket';
  DateTimeRange? _selectedDateRange;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _selectedDays = 'Select';
  String _selectedStatus = 'Select';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Filter',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Date Range',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (_isExpanded)
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 12),

                    // Event Name
                    _buildDropdownField(
                      label: 'Event Name',
                      value: _selectedEventName,
                      items: ['Cricket', 'Basketball', 'Football', 'Tennis'],
                      onChanged: (value) {
                        setState(() {
                          _selectedEventName = value!;
                        });
                        widget.onEventNameChanged(value!);
                      },
                    ),

                    const SizedBox(height: 12),

                    // Date Range
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            label: 'Start Date',
                            date: _selectedDateRange?.start,
                            onTap: () => _selectDateRange(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDateField(
                            label: 'End Date',
                            date: _selectedDateRange?.end,
                            onTap: () => _selectDateRange(context),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Time Range
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeField(
                            label: 'Start Time',
                            time: _startTime,
                            onTap: () => _selectTime(context, true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTimeField(
                            label: 'End Time',
                            time: _endTime,
                            onTap: () => _selectTime(context, false),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Days and Status
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Days',
                            value: _selectedDays,
                            items: [
                              'Select',
                              'Weekdays',
                              'Weekends',
                              'All Days',
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedDays = value!;
                              });
                              widget.onDaysChanged(value!);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Status',
                            value: _selectedStatus,
                            items: [
                              'Select',
                              'Waiting',
                              'Confirmed',
                              'Cancelled',
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                              widget.onStatusChanged(value!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
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
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        InkWell(
          onTap: _isLoading ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: _isLoading ? Colors.grey.shade100 : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                if (_isLoading)
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
                    ),
                  )
                else
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _isLoading
                        ? 'Loading...'
                        : date != null
                            ? '${date.day}/${date.month}/${date.year}'
                            : 'Select Date',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: _isLoading
                          ? Colors.grey.shade500
                          : date != null
                              ? Colors.black87
                              : Colors.grey.shade600,
                    ),
                  ),
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
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        InkWell(
          onTap: _isLoading ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: _isLoading ? Colors.grey.shade100 : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                if (_isLoading)
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
                    ),
                  )
                else
                  Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _isLoading
                        ? 'Loading...'
                        : time != null ? time.format(context) : 'HH:MM',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: _isLoading
                          ? Colors.grey.shade500
                          : time != null
                              ? Colors.black87
                              : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        initialDateRange: _selectedDateRange,
      );

      if (picked != null && mounted) {
        setState(() {
          _selectedDateRange = picked;
        });
        widget.onDateRangeChanged(picked);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting date: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: isStartTime
            ? (_startTime ?? const TimeOfDay(hour: 9, minute: 0))
            : (_endTime ?? const TimeOfDay(hour: 17, minute: 0)),
      );

      if (picked != null && mounted) {
        setState(() {
          if (isStartTime) {
            _startTime = picked;
          } else {
            _endTime = picked;
          }
        });
        widget.onTimeRangeChanged(_startTime, _endTime);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting time: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
