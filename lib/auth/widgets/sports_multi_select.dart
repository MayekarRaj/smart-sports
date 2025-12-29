import 'package:flutter/material.dart';
import '../../core/models/api_models.dart';

class SportsMultiSelect extends StatefulWidget {
  final List<Sport> allSports;
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

  List<Sport> get _filteredSports {
    if (_search.isEmpty) return widget.allSports;
    return widget.allSports
        .where(
          (sport) =>
              sport.sportsName.toLowerCase().contains(_search.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayList =
        _search.isEmpty && !_expanded && _filteredSports.length > 6
        ? _filteredSports.take(6).toList()
        : _filteredSports;
    final hiddenCount =
        _search.isEmpty && !_expanded && _filteredSports.length > 6
        ? _filteredSports.length - 6
        : 0;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with selection counter
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8E2DE2).withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Select Sports',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (_selected.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8E2DE2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_selected.length} selected',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, size: 22),
                  hintText: 'Search sports...',
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
                    borderSide: const BorderSide(
                      color: Color(0xFF8E2DE2),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (v) => setState(() => _search = v),
              ),
            ),
            // Select All / Deselect All
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (_filteredSports.every(
                              (s) => _selected.contains(s.sportsName),
                            ) &&
                            _filteredSports.isNotEmpty) {
                          _selected.removeWhere(
                            (s) => _filteredSports.any(
                              (sport) => sport.sportsName == s,
                            ),
                          );
                        } else {
                          for (final sport in _filteredSports) {
                            if (!_selected.contains(sport.sportsName)) {
                              _selected.add(sport.sportsName);
                            }
                          }
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            _filteredSports.every(
                                  (s) => _selected.contains(s.sportsName),
                                ) &&
                                _filteredSports.isNotEmpty
                            ? const Color(0xFF8E2DE2).withOpacity(0.2)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              _filteredSports.every(
                                    (s) => _selected.contains(s.sportsName),
                                  ) &&
                                  _filteredSports.isNotEmpty
                              ? const Color(0xFF8E2DE2)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _filteredSports.every(
                                      (s) => _selected.contains(s.sportsName),
                                    ) &&
                                    _filteredSports.isNotEmpty
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 18,
                            color:
                                _filteredSports.every(
                                      (s) => _selected.contains(s.sportsName),
                                    ) &&
                                    _filteredSports.isNotEmpty
                                ? const Color(0xFF8E2DE2)
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _filteredSports.every(
                                      (s) => _selected.contains(s.sportsName),
                                    ) &&
                                    _filteredSports.isNotEmpty
                                ? 'Deselect All'
                                : 'Select All',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  _filteredSports.every(
                                        (s) => _selected.contains(s.sportsName),
                                      ) &&
                                      _filteredSports.isNotEmpty
                                  ? const Color(0xFF8E2DE2)
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (_selected.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selected.clear();
                        });
                      },
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Clear All'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Sports List with images
            Flexible(
              child: Material(
                color: Colors.transparent,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: displayList.length + (hiddenCount > 0 ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == displayList.length && hiddenCount > 0) {
                      return InkWell(
                        onTap: () => setState(() => _expanded = true),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              "+ $hiddenCount More \u25BC",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8E2DE2),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final sport = displayList[index];
                    final isSelected = _selected.contains(sport.sportsName);

                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selected.remove(sport.sportsName);
                          } else {
                            _selected.add(sport.sportsName);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF8E2DE2).withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF8E2DE2)
                                : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Sport Image
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                              ),
                              child:
                                  sport.imageUrl != null &&
                                      sport.imageUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        sport.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Icon(
                                                Icons.sports,
                                                color: Colors.grey.shade400,
                                                size: 24,
                                              );
                                            },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Icon(
                                      Icons.sports,
                                      color: Colors.grey.shade400,
                                      size: 24,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            // Sport Name
                            Expanded(
                              child: Text(
                                sport.sportsName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? const Color(0xFF8E2DE2)
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            // Checkbox
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? const Color(0xFF8E2DE2)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF8E2DE2)
                                      : Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(null),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E2DE2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(_selected),
                    child: Text(
                      _selected.isEmpty
                          ? 'Apply'
                          : 'Apply (${_selected.length})',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
