import 'package:flutter/material.dart';

class SportsMultiSelect extends StatefulWidget {
  final List<String> allSports;
  final List<String> initialSelected;

  const SportsMultiSelect({
    super.key,
    required this.allSports,
    required this.initialSelected,
  });

  @override
  State<SportsMultiSelect> createState() => _SportsMultiSelectState();
}

class _SportsMultiSelectState extends State<SportsMultiSelect> {
  late List<String> _selected;
  String _search = '';
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelected);
  }

  List<String> get _filteredSports => widget.allSports
      .where((s) => s.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final displayList = _search.isEmpty && !_expanded && _filteredSports.length > 4
        ? _filteredSports.take(4).toList()
        : _filteredSports;
    final hiddenCount = _search.isEmpty && !_expanded && _filteredSports.length > 4
        ? _filteredSports.length - 4
        : 0;
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, size: 22),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _filteredSports.every(_selected.contains) && _filteredSports.isNotEmpty,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        for (final s in _filteredSports) {
                          if (!_selected.contains(s)) _selected.add(s);
                        }
                      } else {
                        _selected.removeWhere(_filteredSports.contains);
                      }
                    });
                  },
                ),
                const Text('Select All'),
                const SizedBox(width: 24),
                Checkbox(
                  value: _filteredSports.every((s) => !_selected.contains(s)),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selected.removeWhere(_filteredSports.contains);
                      }
                    });
                  },
                ),
                const Text('Deselect All'),
              ],
            ),
            const SizedBox(height: 4),
            // List
            Material(
              color: Colors.transparent,
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...displayList.map((s) => CheckboxListTile(
                        value: _selected.contains(s),
                        title: Text(s),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (v) {
                          setState(() {
                            if (v == true) {
                              _selected.add(s);
                            } else {
                              _selected.remove(s);
                            }
                          });
                        },
                        dense: true,
                      )),
                  if (hiddenCount > 0)
                    InkWell(
                      onTap: () => setState(() => _expanded = true),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "+ $hiddenCount More \u25BC",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.shade500,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 14),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                  ),
                  onPressed: () => Navigator.of(context).pop(_selected),
                  child: const Text('Apply'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
