import 'package:flutter/material.dart';

class ClubSelectionSheet extends StatefulWidget {
  final List<String> availableClubs;
  final List<String> initialSelectedClubs;
  final Function(List<String>) onChanged;

  const ClubSelectionSheet({
    super.key,
    required this.availableClubs,
    required this.initialSelectedClubs,
    required this.onChanged,
  });

  @override
  State<ClubSelectionSheet> createState() => _ClubSelectionSheetState();
}

class _ClubSelectionSheetState extends State<ClubSelectionSheet> {
  late List<String> _tempSelectedClubs;

  @override
  void initState() {
    super.initState();
    _tempSelectedClubs = List.from(widget.initialSelectedClubs);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Clubs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: widget.availableClubs.map((club) {
                final isSelected = _tempSelectedClubs.contains(club);
                return CheckboxListTile(
                  title: Text(club),
                  value: isSelected,
                  activeColor: const Color(0xFF8BB6D9),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        if (!_tempSelectedClubs.contains(club)) {
                          _tempSelectedClubs.add(club);
                        }
                      } else {
                        _tempSelectedClubs.remove(club);
                      }
                    });
                    widget.onChanged(_tempSelectedClubs);
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Done',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFFFFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
