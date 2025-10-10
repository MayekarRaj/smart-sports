import 'package:flutter/material.dart';

class CoachFilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;
  final Map<String, dynamic> initialFilters;

  const CoachFilterWidget({
    super.key,
    required this.onFiltersChanged,
    this.initialFilters = const {},
  });

  @override
  State<CoachFilterWidget> createState() => _CoachFilterWidgetState();
}

class _CoachFilterWidgetState extends State<CoachFilterWidget> {
  String _selectedSport = 'Sport';
  DateTime? _fromDate;
  DateTime? _toDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  String _selectedDays = 'Select';
  String _selectedStatus = 'Select';
  double _distanceRange = 25.0;

  @override
  void initState() {
    super.initState();
    _selectedSport = widget.initialFilters['sport'] ?? 'Sport';
    _selectedDays = widget.initialFilters['days'] ?? 'Select';
    _selectedStatus = widget.initialFilters['status'] ?? 'Select';
    _distanceRange = widget.initialFilters['distance'] ?? 25.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _clearAllFilters,
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sport Filter
          _buildFilterRow('Sport', _selectedSport, () => _showSportDialog()),
          const SizedBox(height: 12),

          // Date Range Filter
          _buildFilterRow(
            'Date Range',
            _fromDate != null && _toDate != null
                ? '${_fromDate!.day}/${_fromDate!.month} - ${_toDate!.day}/${_toDate!.month}'
                : 'Select',
            () => _showDateRangeDialog(),
          ),
          const SizedBox(height: 12),

          // Time Range Filter
          _buildFilterRow(
            'Time Range',
            _fromTime != null && _toTime != null
                ? '${_fromTime!.format(context)} - ${_toTime!.format(context)}'
                : 'Select',
            () => _showTimeRangeDialog(),
          ),
          const SizedBox(height: 12),

          // Days Filter
          _buildFilterRow('Days', _selectedDays, () => _showDaysDialog()),
          const SizedBox(height: 12),

          // Status Filter
          _buildFilterRow('Status', _selectedStatus, () => _showStatusDialog()),
          const SizedBox(height: 16),

          // Distance Slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Distance: ${_distanceRange.toStringAsFixed(1)} miles',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Slider(
                value: _distanceRange,
                min: 1.0,
                max: 50.0,
                divisions: 49,
                onChanged: (value) {
                  setState(() => _distanceRange = value);
                  _notifyFiltersChanged();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: value == 'Select'
                        ? Colors.grey[600]
                        : Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedSport = 'Sport';
      _fromDate = null;
      _toDate = null;
      _fromTime = null;
      _toTime = null;
      _selectedDays = 'Select';
      _selectedStatus = 'Select';
      _distanceRange = 25.0;
    });
    _notifyFiltersChanged();
  }

  void _notifyFiltersChanged() {
    widget.onFiltersChanged({
      'sport': _selectedSport,
      'fromDate': _fromDate,
      'toDate': _toDate,
      'fromTime': _fromTime,
      'toTime': _toTime,
      'days': _selectedDays,
      'status': _selectedStatus,
      'distance': _distanceRange,
    });
  }

  void _showSportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Sport'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              [
                    'Basketball',
                    'Tennis',
                    'Cricket',
                    'Badminton',
                    'Squash',
                    'Fitness',
                    'All Sports',
                  ]
                  .map(
                    (sport) => ListTile(
                      title: Text(sport),
                      onTap: () {
                        setState(() => _selectedSport = sport);
                        Navigator.pop(context);
                        _notifyFiltersChanged();
                      },
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  void _showDateRangeDialog() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked.start;
        _toDate = picked.end;
      });
      _notifyFiltersChanged();
    }
  }

  void _showTimeRangeDialog() async {
    final TimeOfDay? fromTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (fromTime != null) {
      final TimeOfDay? toTime = await showTimePicker(
        context: context,
        initialTime: fromTime,
      );
      if (toTime != null) {
        setState(() {
          _fromTime = fromTime;
          _toTime = toTime;
        });
        _notifyFiltersChanged();
      }
    }
  }

  void _showDaysDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Days'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              [
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                    'Saturday',
                    'Sunday',
                    'All Days',
                  ]
                  .map(
                    (day) => ListTile(
                      title: Text(day),
                      onTap: () {
                        setState(() => _selectedDays = day);
                        Navigator.pop(context);
                        _notifyFiltersChanged();
                      },
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  void _showStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Available', 'Busy', 'Offline', 'All Status']
              .map(
                (status) => ListTile(
                  title: Text(status),
                  onTap: () {
                    setState(() => _selectedStatus = status);
                    Navigator.pop(context);
                    _notifyFiltersChanged();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
