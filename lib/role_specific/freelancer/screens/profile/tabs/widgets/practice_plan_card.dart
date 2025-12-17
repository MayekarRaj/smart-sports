import 'package:flutter/material.dart';

class PracticePlanCard extends StatefulWidget {
  final Color roleColor;
  final Map<String, dynamic> plan;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  final VoidCallback onRemove;

  const PracticePlanCard({
    super.key,
    required this.roleColor,
    required this.plan,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  State<PracticePlanCard> createState() => _PracticePlanCardState();
}

class _PracticePlanCardState extends State<PracticePlanCard> {
  late Map<String, dynamic> _plan;

  final List<String> _practiceDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _plan = Map<String, dynamic>.from(widget.plan);
  }

  void _updatePlan() {
    widget.onUpdate(_plan);
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final initialTime = isStartTime
        ? (_plan['startTime'] as TimeOfDay? ?? TimeOfDay(hour: 9, minute: 0))
        : (_plan['endTime'] as TimeOfDay? ?? TimeOfDay(hour: 10, minute: 0));

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _plan['startTime'] = picked;
        } else {
          _plan['endTime'] = picked;
        }
        _updatePlan();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final startTime = _plan['startTime'] as TimeOfDay? ?? TimeOfDay(hour: 9, minute: 0);
    final endTime = _plan['endTime'] as TimeOfDay? ?? TimeOfDay(hour: 10, minute: 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Practice Plan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.roleColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                onPressed: widget.onRemove,
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _plan['practiceDays'] as String? ?? 'Monday',
            decoration: InputDecoration(
              labelText: 'Practice Days',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.roleColor, width: 2),
              ),
            ),
            items: _practiceDays.map((day) {
              return DropdownMenuItem<String>(
                value: day,
                child: Text(day),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _plan['practiceDays'] = value;
                _updatePlan();
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectTime(context, true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          'From: ${startTime.format(context)}',
                          style: const TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => _selectTime(context, false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          'To: ${endTime.format(context)}',
                          style: const TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

