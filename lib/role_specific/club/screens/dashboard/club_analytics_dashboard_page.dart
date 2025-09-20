import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/club/screens/profile/club_profile_page.dart';
import 'package:smart_sports/role_specific/club/screens/courts/courts_page.dart';
import 'package:smart_sports/role_specific/club/screens/transactions/club_transactions_page.dart';
import 'package:smart_sports/role_specific/club/screens/bookings/club_bookings_page.dart';
import 'package:smart_sports/role_specific/club/screens/events/club_events_page.dart';

class ClubAnalyticsDashboardPage extends StatefulWidget {
  const ClubAnalyticsDashboardPage({super.key});

  @override
  State<ClubAnalyticsDashboardPage> createState() => _ClubAnalyticsDashboardPageState();
}

void _navigateFromSidebar(BuildContext context, int index) {
  switch (index) {
    case 0:
      // Already on dashboard; no-op
      break;
    case 1:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClubTransactionsPage()),
      );
      break;
    case 2:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClubCourtsPage()),
      );
      break;
    case 3:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const _SidebarPlaceholder(title: 'Clubs', currentIndex: 3)),
      );
      break;
    case 4:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClubBookingsPage()),
      );
      break;
    case 5:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClubEventsPage()),
      );
      break;
    case 6:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const _SidebarPlaceholder(title: 'Sponsorships', currentIndex: 6)),
      );
      break;
    case 7:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const _SidebarPlaceholder(title: 'Users', currentIndex: 7)),
      );
      break;
    case 8:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const _SidebarPlaceholder(title: 'Referrals', currentIndex: 8)),
      );
      break;
    default:
      break;
  }
}

class _SidebarPlaceholder extends StatelessWidget {
  final String title;
  final int currentIndex;
  const _SidebarPlaceholder({required this.title, required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.club,
            selectedIndex: currentIndex,
            edgeToEdge: true,
            onSelectIndex: (i) async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              _navigateFromSidebar(context, i);
            },
            onProfileTap: () async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ClubProfilePage()),
              );
            },
          ),
        ),
      ),
      body: Center(child: Text('$title screen coming soon')),
    );
  }
}

class MediaUtils {
  final BuildContext context;
  MediaUtils(this.context);
  bool get isWide => MediaQuery.of(context).size.width >= 1000;
}

class _ClubAnalyticsDashboardPageState extends State<ClubAnalyticsDashboardPage>
    with TickerProviderStateMixin {
  late final TabController _topTabs;
  late final TabController _tableTabs;

  final TextEditingController _searchController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  String _days = 'Select';
  String _status = 'Select';
  int _showEntries = 10;
  String _period = 'ALL'; // ALL, Financial Year, Flexible Duration

  @override
  void initState() {
    super.initState();
    _topTabs = TabController(length: 4, vsync: this);
    _tableTabs = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _topTabs.dispose();
    _tableTabs.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaUtils(context).isWide;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black87,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _TopNavTabs(controller: _topTabs),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.club,
            selectedIndex: 0,
            onSelectIndex: (i) async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 180));
              _navigateFromSidebar(context, i);
            },
            onClose: null,
            onProfileTap: () async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 180));
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ClubProfilePage()),
              );
            },
            edgeToEdge: true,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShowAndSearchRow(
                  showEntries: _showEntries,
                  onEntriesChanged: (v) => setState(() => _showEntries = v),
                  searchController: _searchController,
                ),
                const SizedBox(height: 16),
                _FiltersCard(
                  fromDate: _fromDate,
                  toDate: _toDate,
                  fromTime: _fromTime,
                  toTime: _toTime,
                  days: _days,
                  status: _status,
                  onPickFromDate: () async {
                    final result = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2100),
                      initialDate: _fromDate ?? DateTime.now(),
                    );
                    if (result != null) setState(() => _fromDate = result);
                  },
                  onPickToDate: () async {
                    final result = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2100),
                      initialDate: _toDate ?? DateTime.now(),
                    );
                    if (result != null) setState(() => _toDate = result);
                  },
                  onPickFromTime: () async {
                    final result = await showTimePicker(
                      context: context,
                      initialTime: _fromTime ?? TimeOfDay.now(),
                    );
                    if (result != null) setState(() => _fromTime = result);
                  },
                  onPickToTime: () async {
                    final result = await showTimePicker(
                      context: context,
                      initialTime: _toTime ?? TimeOfDay.now(),
                    );
                    if (result != null) setState(() => _toTime = result);
                  },
                  onChangeDays: (v) => setState(() => _days = v),
                  onChangeStatus: (v) => setState(() => _status = v),
                ),
                const SizedBox(height: 16),
                _PeriodChips(
                  period: _period,
                  onChanged: (v) => setState(() => _period = v),
                ),
                const SizedBox(height: 16),
                _TableTabs(controller: _tableTabs),
                const SizedBox(height: 12),
                _TransactionsTable(isWide: isWide),
                const SizedBox(height: 24),
                const _FooterSection(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TopNavTabs extends StatelessWidget {
  final TabController controller;
  const _TopNavTabs({required this.controller});
  @override
  Widget build(BuildContext context) {
    final tabs = [
      _pill('DASHBOARD'),
      _pill('Global Search'),
      _pill('Cancel'),
      _pill('Button'),
    ];
    return Material(
      color: Colors.transparent,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        indicator: const BoxDecoration(),
        tabs: tabs,
      ),
    );
  }

  Widget _pill(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: const [
              BoxShadow(blurRadius: 8, color: Color(0x14000000), offset: Offset(0, 2)),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

class _ShowAndSearchRow extends StatelessWidget {
  final int showEntries;
  final ValueChanged<int> onEntriesChanged;
  final TextEditingController searchController;
  const _ShowAndSearchRow({
    required this.showEntries,
    required this.onEntriesChanged,
    required this.searchController,
  });
  @override
  Widget build(BuildContext context) {
    final valid = const [10, 25, 50, 100];
    final value = valid.contains(showEntries) ? showEntries : 10;
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 700;
    final searchField = _RoundedContainer(
      child: TextField(
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
              _RoundedContainer(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: value,
                    items: valid
                        .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                        .toList(),
                    onChanged: (v) => onEntriesChanged(v ?? value),
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
        _RoundedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              items: valid
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (v) => onEntriesChanged(v ?? value),
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
}

class _FiltersCard extends StatelessWidget {
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
  const _FiltersCard({
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
    final dateFmt = MaterialLocalizations.of(context);
    String fmtDate(DateTime? d) => d == null ? 'Select Date' : dateFmt.formatFullDate(d);
    String fmtTime(TimeOfDay? t) => t == null ? 'HH:MM' : t.format(context);

    final isNarrow = MediaQuery.of(context).size.width < 700;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 16,
        children: [
          _FilterTile(
            title: 'Title',
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.tune),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
          _FilterTile(
            title: 'Date Range',
            child: isNarrow
                ? Column(
                    children: [
                      _dateButton(fmtDate(fromDate), Icons.calendar_today, onPickFromDate),
                      const SizedBox(height: 8),
                      _dateButton(fmtDate(toDate), Icons.calendar_today, onPickToDate),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _dateButton(fmtDate(fromDate), Icons.calendar_today, onPickFromDate)),
                      const SizedBox(width: 8),
                      Expanded(child: _dateButton(fmtDate(toDate), Icons.calendar_today, onPickToDate)),
                    ],
                  ),
          ),
          _FilterTile(
            title: 'Time',
            child: isNarrow
                ? Column(
                    children: [
                      _dateButton(fmtTime(fromTime), Icons.schedule, onPickFromTime),
                      const SizedBox(height: 8),
                      _dateButton(fmtTime(toTime), Icons.schedule, onPickToTime),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _dateButton(fmtTime(fromTime), Icons.schedule, onPickFromTime)),
                      const SizedBox(width: 8),
                      Expanded(child: _dateButton(fmtTime(toTime), Icons.schedule, onPickToTime)),
                    ],
                  ),
          ),
          _FilterTile(
            title: 'Days',
            child: DropdownButtonFormField<String>(
              value: const ['Select', 'Mon-Fri', 'Sat-Sun'].contains(days) ? days : 'Select',
              items: const ['Select', 'Mon-Fri', 'Sat-Sun']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => onChangeDays(v ?? days),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
          _FilterTile(
            title: 'Status',
            child: DropdownButtonFormField<String>(
              value: const ['Select', 'Paid', 'Unpaid', 'Refunded'].contains(status) ? status : 'Select',
              items: const ['Select', 'Paid', 'Unpaid', 'Refunded']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => onChangeStatus(v ?? status),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateButton(String label, IconData icon, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(label, overflow: TextOverflow.ellipsis),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFFF7F7F7),
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  final String title;
  final Widget child;
  const _FilterTile({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 700;
    return SizedBox(
      width: isNarrow ? double.infinity : 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

 

class _PeriodChips extends StatelessWidget {
  final String period;
  final ValueChanged<String> onChanged;
  const _PeriodChips({required this.period, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    Widget chip(String v) {
      final active = period == v;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => onChanged(v),
          child: Container(
            decoration: BoxDecoration(
              color: active ? Colors.black87 : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: active ? Colors.black54 : Colors.black26),
              boxShadow: active
                  ? const [BoxShadow(blurRadius: 8, color: Color(0x14000000), offset: Offset(0, 2))]
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(v,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : Colors.black87,
                )),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [chip('ALL'), chip('Financial Year'), chip('Flexible Duration')],
    );
  }
}

class _TableTabs extends StatelessWidget {
  final TabController controller;
  const _TableTabs({required this.controller});
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
          indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: Colors.black87, width: 3)),
          tabs: const [
            Tab(text: 'Slack'),
            Tab(text: 'Club Branches'),
            Tab(text: 'Forum'),
            Tab(text: 'Member'),
            Tab(text: 'User'),
            Tab(text: 'Event'),
          ],
        ),
      ),
    );
  }
}

class _TransactionsTable extends StatelessWidget {
  final bool isWide;
  const _TransactionsTable({required this.isWide});

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

    final rows = List<DataRow>.generate(20, (i) {
      final odd = i % 2 == 1;
      return DataRow(
        color: MaterialStatePropertyAll(odd ? Colors.grey.shade50 : Colors.white),
        cells: [
        DataCell(Text('${i + 1}')),
        const DataCell(Text('02-28-2025')),
        const DataCell(Text('02-28-2026')),
        const DataCell(Text('1,000')),
        const DataCell(Text('Bank Transfer')),
        DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Paid'),
            Row(children: [
              _LinkText('Invoice', onTap: () {}),
              const Text(' | '),
              _LinkText('Receipt', onTap: () {}),
            ]),
          ],
        )),
        const DataCell(Text('Bank Transfer')),
      ]);
    });

    final table = DataTable(
      columns: columns,
      rows: rows,
      headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
      columnSpacing: 28,
      dataRowMinHeight: 52,
      dataRowMaxHeight: 60,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black87, width: 1),
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
              child: SingleChildScrollView(
                child: table,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _LinkText(this.text, {required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(text, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
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
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Partner Logo'),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text('© 2024  SEKAI-ICHI Engineering And IT Solutions Pvt. Ltd'),
          ],
        ),
      ),
    );
  }
}

class _RoundedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _RoundedContainer({required this.child, this.padding});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    );
  }
}
