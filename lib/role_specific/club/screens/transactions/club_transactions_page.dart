import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';

class ClubTransactionsPage extends StatefulWidget {
  const ClubTransactionsPage({super.key});

  @override
  State<ClubTransactionsPage> createState() => _ClubTransactionsPageState();
}

class _ClubTransactionsPageState extends State<ClubTransactionsPage>
    with TickerProviderStateMixin {
  final TextEditingController _search = TextEditingController();
  int _showEntries = 10;
  String _period = 'ALL';
  late final TabController _tabs;
  bool _showFilters = false;

  DateTime? _fromDate;
  DateTime? _toDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  String _days = 'Select';
  String _status = 'Select';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: const Color(0xFF1E40AF), // Club blue
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: Colors.white,
            ),
            tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(46),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _TopPills(
              tabs: _tabs,
              labels: const ['Overview', 'Payouts', 'Refunds'],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.club,
            selectedIndex: 1,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.club,
              i,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShowAndSearch(
              value: _showEntries,
              onChanged: (v) => setState(() => _showEntries = v),
              searchController: _search,
            ),
            const SizedBox(height: 16),
            if (_showFilters)
              _FilterBar(
                fromDate: _fromDate,
                toDate: _toDate,
                fromTime: _fromTime,
                toTime: _toTime,
                days: _days,
                status: _status,
                onPickFromDate: () async {
                  final res = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2100),
                    initialDate: _fromDate ?? DateTime.now(),
                  );
                  if (res != null) setState(() => _fromDate = res);
                },
                onPickToDate: () async {
                  final res = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2100),
                    initialDate: _toDate ?? DateTime.now(),
                  );
                  if (res != null) setState(() => _toDate = res);
                },
                onPickFromTime: () async {
                  final res = await showTimePicker(
                    context: context,
                    initialTime: _fromTime ?? TimeOfDay.now(),
                  );
                  if (res != null) setState(() => _fromTime = res);
                },
                onPickToTime: () async {
                  final res = await showTimePicker(
                    context: context,
                    initialTime: _toTime ?? TimeOfDay.now(),
                  );
                  if (res != null) setState(() => _toTime = res);
                },
                onChangeDays: (v) => setState(() => _days = v),
                onChangeStatus: (v) => setState(() => _status = v),
              ),
            if (_showFilters) const SizedBox(height: 16),
            const SizedBox(height: 16),
            _PeriodSelector(
              period: _period,
              onChanged: (v) => setState(() => _period = v),
            ),
            const SizedBox(height: 16),
            _CategoryTabs(controller: _tabs),
            const SizedBox(height: 12),
            _TransactionTable(isWide: isWide),
            const SizedBox(height: 24),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

class _TopPills extends StatelessWidget {
  final TabController tabs;
  final List<String> labels;
  const _TopPills({required this.tabs, required this.labels});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TabBar(
        controller: tabs,
        isScrollable: true,
        indicator: const BoxDecoration(),
        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
        tabs: labels.map((t) => _pill(t)).toList(),
      ),
    );
  }

  Widget _pill(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 6,
                color: Color(0x14000000),
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _ShowAndSearch extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final TextEditingController searchController;
  const _ShowAndSearch({
    required this.value,
    required this.onChanged,
    required this.searchController,
  });
  @override
  Widget build(BuildContext context) {
    final valid = const [10, 25, 50, 100];
    final v = valid.contains(value) ? value : 10;
    final isNarrow = MediaQuery.of(context).size.width < 700;
    final searchField = _box(
      TextField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Search Here',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Show'),
              const SizedBox(width: 8),
              _box(
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: v,
                    items: valid
                        .map(
                          (e) => DropdownMenuItem(value: e, child: Text('$e')),
                        )
                        .toList(),
                    onChanged: (nv) => onChanged(nv ?? v),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Entries'),
            ],
          ),
          const SizedBox(height: 12),
          searchField,
        ],
      );
    }

    return Row(
      children: [
        const Text('Show'),
        const SizedBox(width: 8),
        _box(
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: v,
              items: valid
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (nv) => onChanged(nv ?? v),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text('Entries'),
        const SizedBox(width: 16),
        Expanded(child: searchField),
      ],
    );
  }

  Widget _box(Widget child) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE0E0E0)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: child,
  );
}

class _FilterBar extends StatelessWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;
  final String days;
  final String status;
  final VoidCallback onPickFromDate;
  final VoidCallback onPickToDate;
  final VoidCallback onPickFromTime;
  final VoidCallback onPickToTime;
  final ValueChanged<String> onChangeDays;
  final ValueChanged<String> onChangeStatus;
  const _FilterBar({
    required this.fromDate,
    required this.toDate,
    required this.fromTime,
    required this.toTime,
    required this.days,
    required this.status,
    required this.onPickFromDate,
    required this.onPickToDate,
    required this.onPickFromTime,
    required this.onPickToTime,
    required this.onChangeDays,
    required this.onChangeStatus,
  });
  @override
  Widget build(BuildContext context) {
    String fmtDate(DateTime? d) => d == null
        ? 'Select Date'
        : MaterialLocalizations.of(context).formatFullDate(d);
    String fmtTime(TimeOfDay? t) => t == null ? 'HH:MM' : t.format(context);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _tile(
            'Title',
            _darkBox(
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          _tile(
            'Date Range',
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: _darkBox(
                    _picker(
                      fmtDate(fromDate),
                      Icons.calendar_today,
                      onPickFromDate,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _darkBox(
                    _picker(
                      fmtDate(toDate),
                      Icons.calendar_today,
                      onPickToDate,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _tile(
            'Time',
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: _darkBox(
                    _picker(fmtTime(fromTime), Icons.schedule, onPickFromTime),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _darkBox(
                    _picker(fmtTime(toTime), Icons.schedule, onPickToTime),
                  ),
                ),
              ],
            ),
          ),
          _tile(
            'Days',
            _darkBox(
              _dropdown(days, ['Select', 'Mon-Fri', 'Sat-Sun'], onChangeDays),
            ),
          ),
          _tile(
            'Status',
            _darkBox(
              _dropdown(status, [
                'Select',
                'Paid',
                'Unpaid',
                'Refunded',
              ], onChangeStatus),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(String title, Widget child) => SizedBox(
    width: 300,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );
  Widget _picker(String label, IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),
          Icon(icon, color: Colors.white),
        ],
      ),
    ),
  );
  Widget _dropdown(
    String v,
    List<String> options,
    ValueChanged<String> onChanged,
  ) => DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: options.contains(v) ? v : options.first,
      dropdownColor: const Color(0xFF2B2B2B),
      iconEnabledColor: Colors.white,
      items: options
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(color: Colors.white)),
            ),
          )
          .toList(),
      onChanged: (nv) => onChanged(nv ?? v),
    ),
  );
  Widget _darkBox(Widget child) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFF2B2B2B),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: child,
  );
}

class _PeriodSelector extends StatelessWidget {
  final String period;
  final ValueChanged<String> onChanged;
  const _PeriodSelector({required this.period, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    Widget chip(String v) {
      final active = v == period;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => onChanged(v),
          child: Container(
            decoration: BoxDecoration(
              color: active ? Colors.black87 : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: active ? Colors.black54 : Colors.black26,
              ),
              boxShadow: active
                  ? const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Color(0x14000000),
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              v,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        chip('ALL'),
        chip('Financial Year'),
        chip('Flexible Duration'),
      ],
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final TabController controller;
  const _CategoryTabs({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black26),
        ),
        child: TabBar(
          controller: controller,
          isScrollable: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.black87, width: 3),
          ),
          tabs: const [
            Tab(text: 'Slack'),
            Tab(text: 'Club Branches'),
            Tab(text: 'Forum'),
          ],
        ),
      ),
    );
  }
}

class _TransactionTable extends StatelessWidget {
  final bool isWide;
  const _TransactionTable({required this.isWide});
  @override
  Widget build(BuildContext context) {
    final columns = [
      DataColumn(
        label: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Text(
            'Transaction ID',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Text(
            'Start Date',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Text(
            'End Date',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Text(
            'Amount',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Text(
            'Payment Method',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Text(
            'Payment Status',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Text(
            'Actions',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ),
    ];

    final rows = List<DataRow>.generate(25, (i) {
      final odd = i % 2 == 1;
      return DataRow(
        color: MaterialStatePropertyAll(
          odd ? const Color(0xFFF9FAFB) : Colors.white,
        ),
        cells: [
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '#${(i + 1).toString().padLeft(4, '0')}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                '02-28-2025',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
            ),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                '02-28-2026',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
            ),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                '₹1,000',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF059669),
                ),
              ),
            ),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E40AF).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Bank Transfer',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Paid',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  _ActionButton(
                    icon: Icons.receipt,
                    label: 'Invoice',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invoice downloaded')),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.download,
                    label: 'Receipt',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Receipt downloaded')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });

    final table = DataTable(
      columns: columns,
      rows: rows,
      headingRowColor: MaterialStateProperty.all(const Color(0xFFF3F4F6)),
      columnSpacing: 24,
      dataRowMinHeight: 60,
      dataRowMaxHeight: 60,
      horizontalMargin: 16,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: isWide ? 520 : 420,
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 1000),
              child: SingleChildScrollView(child: table),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF6B7280)),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'SEKAI-ICHI',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '© 2024 SEKAI-ICHI Engineering And IT Solutions Pvt. Ltd',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Removed unused _Link widget

// Navigation from sidebar now centralized via RoleNavigationManager
