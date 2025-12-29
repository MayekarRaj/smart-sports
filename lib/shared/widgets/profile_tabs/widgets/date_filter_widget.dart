import 'package:flutter/material.dart';

class DateFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final String startMonth;
  final String startYear;
  final String endMonth;
  final String endYear;
  final ValueChanged<String> onStartMonthChanged;
  final ValueChanged<String> onStartYearChanged;
  final ValueChanged<String> onEndMonthChanged;
  final ValueChanged<String> onEndYearChanged;
  final bool showFlexibleDuration;
  final DateTime? flexibleStartDate;
  final DateTime? flexibleEndDate;
  final ValueChanged<DateTime>? onFlexibleStartDateChanged;
  final ValueChanged<DateTime>? onFlexibleEndDateChanged;

  const DateFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.startMonth,
    required this.startYear,
    required this.endMonth,
    required this.endYear,
    required this.onStartMonthChanged,
    required this.onStartYearChanged,
    required this.onEndMonthChanged,
    required this.onEndYearChanged,
    this.showFlexibleDuration = false,
    this.flexibleStartDate,
    this.flexibleEndDate,
    this.onFlexibleStartDateChanged,
    this.onFlexibleEndDateChanged,
  });

  final List<String> _months = const [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  final List<String> _years = const [
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Buttons
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildFilterButton('All', selectedFilter == 'All'),
            _buildFilterButton('Financial Year', selectedFilter == 'Financial Year'),
            if (showFlexibleDuration)
              _buildFilterButton('Flexible Duration', selectedFilter == 'Flexible Duration'),
          ],
        ),
        const SizedBox(height: 16),
        // Date Selection
        if (selectedFilter == 'Financial Year')
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;
              if (isSmallScreen) {
                return Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start Month',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                value: startMonth,
                                items: _months,
                                onChanged: onStartMonthChanged,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildDropdown(
                                value: startYear,
                                items: _years,
                                onChanged: onStartYearChanged,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'End Month',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                value: endMonth,
                                items: _months,
                                onChanged: onEndMonthChanged,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildDropdown(
                                value: endYear,
                                items: _years,
                                onChanged: onEndYearChanged,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start Month',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                value: startMonth,
                                items: _months,
                                onChanged: onStartMonthChanged,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildDropdown(
                                value: startYear,
                                items: _years,
                                onChanged: onStartYearChanged,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'End Month',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                value: endMonth,
                                items: _months,
                                onChanged: onEndMonthChanged,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildDropdown(
                                value: endYear,
                                items: _years,
                                onChanged: onEndYearChanged,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          )
        else if (selectedFilter == 'Flexible Duration' && showFlexibleDuration)
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;
              if (isSmallScreen) {
                return Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start Date',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDatePicker(
                          context,
                          value: flexibleStartDate ?? DateTime.now(),
                          onChanged: onFlexibleStartDateChanged ?? (date) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'End Date',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDatePicker(
                          context,
                          value: flexibleEndDate ?? DateTime.now(),
                          onChanged: onFlexibleEndDateChanged ?? (date) {},
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start Date',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDatePicker(
                          context,
                          value: flexibleStartDate ?? DateTime.now(),
                          onChanged: onFlexibleStartDateChanged ?? (date) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'End Date',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDatePicker(
                          context,
                          value: flexibleEndDate ?? DateTime.now(),
                          onChanged: onFlexibleEndDateChanged ?? (date) {},
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _buildFilterButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => onFilterChanged(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: const BoxConstraints(minWidth: 80),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF1F2937) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context, {
    required DateTime value,
    required ValueChanged<DateTime> onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2019),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${value.day}/${value.month}/${value.year}',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}

