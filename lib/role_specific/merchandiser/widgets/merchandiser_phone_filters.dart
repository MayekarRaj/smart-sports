import 'package:flutter/material.dart';

/// MerchandiserPhoneFilters: unified, phone-style filter section for Merchandiser screens
/// - Uses merchandiser purple background (#8B5CF6)
/// - Mobile-friendly stacked layout
/// - Optional header toggle; can be embedded without header
class MerchandiserPhoneFilters extends StatefulWidget {
  final bool showHeader;
  final bool initiallyExpanded;

  final TextEditingController? searchController;

  final DateTime? fromDate;
  final DateTime? toDate;
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;
  final VoidCallback? onPickFromDate;
  final VoidCallback? onPickToDate;
  final VoidCallback? onPickFromTime;
  final VoidCallback? onPickToTime;

  final String? days;
  final ValueChanged<String>? onChangeDays;
  final List<String> daysItems;

  final String? status;
  final ValueChanged<String>? onChangeStatus;
  final List<String> statusItems;

  /// Allow hiding sections to keep the component flexible
  final bool showSearch;
  final bool showDateRange;
  final bool showTimeRange;
  final bool showDays;
  final bool showStatus;

  const MerchandiserPhoneFilters({
    super.key,
    this.showHeader = true,
    this.initiallyExpanded = true,
    this.searchController,
    this.fromDate,
    this.toDate,
    this.fromTime,
    this.toTime,
    this.onPickFromDate,
    this.onPickToDate,
    this.onPickFromTime,
    this.onPickToTime,
    this.days,
    this.onChangeDays,
    this.daysItems = const ['Select', 'Mon-Fri', 'Sat-Sun'],
    this.status,
    this.onChangeStatus,
    this.statusItems = const ['Select', 'Paid', 'Unpaid', 'Refunded'],
    this.showSearch = true,
    this.showDateRange = true,
    this.showTimeRange = true,
    this.showDays = true,
    this.showStatus = true,
  });

  @override
  State<MerchandiserPhoneFilters> createState() =>
      _MerchandiserPhoneFiltersState();
}

class _MerchandiserPhoneFiltersState extends State<MerchandiserPhoneFilters>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _controller;
  late Animation<double> _size;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: _expanded ? 1 : 0,
    );
    _size = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bg = const Color(0xFF8B5CF6);
    final Color chipBg = Colors.white.withOpacity(0.08);

    Widget content = Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      color: bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showSearch) ...[
            _label('Title'),
            _box(
              bg,
              const Color(0xFFFFFFFF),
              TextField(
                controller: widget.searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          if (widget.showDateRange) ...[
            _label('Date Range'),
            Row(
              children: [
                Expanded(
                  child: _picker(
                    bg,
                    _fmtDate(context, widget.fromDate),
                    Icons.calendar_today,
                    widget.onPickFromDate,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _picker(
                    bg,
                    _fmtDate(context, widget.toDate),
                    Icons.calendar_today,
                    widget.onPickToDate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          if (widget.showTimeRange) ...[
            _label('Time'),
            Row(
              children: [
                Expanded(
                  child: _picker(
                    bg,
                    _fmtTime(context, widget.fromTime),
                    Icons.schedule,
                    widget.onPickFromTime,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _picker(
                    bg,
                    _fmtTime(context, widget.toTime),
                    Icons.schedule,
                    widget.onPickToTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          Row(
            children: [
              if (widget.showDays)
                Expanded(
                  child: _dropdown(
                    bg,
                    'Days',
                    widget.days,
                    widget.daysItems,
                    widget.onChangeDays,
                  ),
                ),
              if (widget.showDays && widget.showStatus)
                const SizedBox(width: 8),
              if (widget.showStatus)
                Expanded(
                  child: _dropdown(
                    bg,
                    'Status',
                    widget.status,
                    widget.statusItems,
                    widget.onChangeStatus,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip('ALL', chipBg),
              _chip('Financial Year', chipBg),
              _chip('Flexible Duration', chipBg),
            ],
          ),
        ],
      ),
    );

    if (!widget.showHeader) return content;

    return Container(
      color: bg,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
                if (_expanded) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(sizeFactor: _size, child: content),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _box(Color bg, Color borderColor, Widget child) => Container(
    decoration: BoxDecoration(
      color: bg.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white24),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: child,
  );

  Widget _picker(Color bg, String label, IconData icon, VoidCallback? onTap) =>
      _box(
        bg,
        Colors.white,
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Icon(icon, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      );

  Widget _dropdown(
    Color bg,
    String label,
    String? value,
    List<String> items,
    ValueChanged<String>? onChanged,
  ) => _box(
    bg,
    Colors.white,
    DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: items.contains(value) ? value : items.first,
        isExpanded: true,
        dropdownColor: const Color(0xFF047857),
        iconEnabledColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(color: Colors.white)),
              ),
            )
            .toList(),
        onChanged: (v) {
          if (v == null) return;
          onChanged?.call(v);
        },
      ),
    ),
  );

  Widget _chip(String text, Color bg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white24),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
  );

  String _fmtDate(BuildContext context, DateTime? d) => d == null
      ? 'Select Date'
      : MaterialLocalizations.of(context).formatFullDate(d);
  String _fmtTime(BuildContext context, TimeOfDay? t) =>
      t == null ? 'HH:MM' : t.format(context);
}
