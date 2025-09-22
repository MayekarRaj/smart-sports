import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/dashboard/merchandiser_analytics_dashboard_page.dart';

class MerchandiserTransactionsPage extends StatefulWidget {
  const MerchandiserTransactionsPage({super.key});

  @override
  State<MerchandiserTransactionsPage> createState() =>
      _MerchandiserTransactionsPageState();
}

class _MerchandiserTransactionsPageState
    extends State<MerchandiserTransactionsPage>
    with TickerProviderStateMixin {
  final TextEditingController _search = TextEditingController();
  int _showEntries = 10;
  String _period = 'ALL';
  late final TabController _tabs;

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
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
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
            role: UserRole.merchandiser,
            selectedIndex: 1,
            edgeToEdge: true,
            onSelectIndex: (i) async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              _navigateFromSidebar(context, i);
            },
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
            Tab(text: 'Merchandiser Branches'),
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
    final columns = const [
      DataColumn(label: Text('Transaction ID')),
      DataColumn(label: Text('Start Date')),
      DataColumn(label: Text('End Date')),
      DataColumn(label: Text('Amount')),
      DataColumn(label: Text('Payment Method')),
      DataColumn(label: Text('Payment Status')),
      DataColumn(label: Text('Payment Date')),
    ];
    final rows = List<DataRow>.generate(25, (i) {
      final odd = i % 2 == 1;
      return DataRow(
        color: MaterialStatePropertyAll(
          odd ? Colors.grey.shade50 : Colors.white,
        ),
        cells: [
          DataCell(Text('${i + 1}')),
          const DataCell(Text('02-28-2025')),
          const DataCell(Text('02-28-2026')),
          const DataCell(Text('1,000')),
          const DataCell(Text('Bank Transfer')),
          DataCell(
            Row(
              children: [
                const Text('Paid'),
                const SizedBox(width: 8),
                _Link('Invoice', () {}),
                const Text('|'),
                const SizedBox(width: 8),
                _Link('Receipt', () {}),
              ],
            ),
          ),
          const DataCell(Text('02-28-2025')),
        ],
      );
    });

    final table = DataTable(
      columns: columns,
      rows: rows,
      headingRowColor: MaterialStatePropertyAll(Colors.grey.shade200),
      columnSpacing: 28,
      dataRowMinHeight: 52,
      dataRowMaxHeight: 60,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black87),
      ),
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: isWide ? 520 : 420,
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 900),
              child: SingleChildScrollView(child: table),
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black26),
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: List.generate(
                4,
                (i) => Container(
                  width: 120,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Partner Logo'),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '© 2024  SEKAI-ICHI Engineering And IT Solutions Pvt. Ltd',
          ),
        ],
      ),
    );
  }
}

class _Link extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _Link(this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

void _navigateFromSidebar(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MerchandiserAnalyticsDashboardPage(),
        ),
      );
      break;
    case 1:
      // already on transactions
      break;
    default:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MerchandiserAnalyticsDashboardPage(),
        ),
      );
  }
}
