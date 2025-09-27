import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';

class CorporateAnalyticsDashboardPage extends StatefulWidget {
  const CorporateAnalyticsDashboardPage({super.key});

  @override
  State<CorporateAnalyticsDashboardPage> createState() =>
      _CorporateAnalyticsDashboardPageState();
}

class MediaUtils {
  final BuildContext context;
  MediaUtils(this.context);
  bool get isWide => MediaQuery.of(context).size.width >= 1000;
}

class _CorporateAnalyticsDashboardPageState
    extends State<CorporateAnalyticsDashboardPage>
    with TickerProviderStateMixin {
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
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _tableTabs = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tableTabs.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaUtils(context).isWide;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E293B),
        shadowColor: Colors.black.withValues(alpha: 0.05),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, size: 24),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
              foregroundColor: const Color(0xFF475569),
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
              icon: Icon(
                _showFilters ? Icons.filter_list_off_rounded : Icons.tune_rounded,
                size: 22,
              ),
              style: IconButton.styleFrom(
                backgroundColor: _showFilters 
                  ? const Color(0xFF3B82F6) 
                  : const Color(0xFFF1F5F9),
                foregroundColor: _showFilters 
                  ? Colors.white 
                  : const Color(0xFF475569),
              ),
              tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE2E8F0),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.corporate,
            selectedIndex: 0,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.corporate,
              i,
            ),
            onClose: null,
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.corporate,
            ),
            edgeToEdge: true,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShowAndSearchRow(
                  showEntries: _showEntries,
                  onEntriesChanged: (v) => setState(() => _showEntries = v),
                  searchController: _searchController,
                ),
                const SizedBox(height: 24),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: _showFilters ? null : 0,
                  child: _showFilters
                      ? Column(
                          children: [
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
                            const SizedBox(height: 24),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                _PeriodChips(
                  period: _period,
                  onChanged: (v) => setState(() => _period = v),
                ),
                const SizedBox(height: 24),
                _TableTabs(controller: _tableTabs),
                const SizedBox(height: 20),
                _TransactionsTable(isWide: isWide),
                const SizedBox(height: 32),
                const _FooterSection(),
              ],
            ),
          );
        },
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
    
    final searchField = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Search transactions...',
          hintStyle: TextStyle(
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Color(0xFF64748B),
            size: 20,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Show',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: value,
                    items: valid
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              '$e',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => onEntriesChanged(v ?? value),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'entries',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          searchField,
        ],
      );
    }

    return Row(
      children: [
        const Text(
          'Show',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              items: valid
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          '$e',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (v) => onEntriesChanged(v ?? value),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'entries',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(width: 24),
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
    String fmtDate(DateTime? d) =>
        d == null ? 'Select Date' : dateFmt.formatFullDate(d);
    String fmtTime(TimeOfDay? t) => t == null ? 'Select Time' : t.format(context);

    final isNarrow = MediaQuery.of(context).size.width < 700;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Advanced Filters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _FilterTile(
                title: 'Search Keywords',
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter keywords...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                    suffixIcon: const Icon(
                      Icons.tune_rounded,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              _FilterTile(
                title: 'Date Range',
                child: isNarrow
                    ? Column(
                        children: [
                          _dateButton(
                            fmtDate(fromDate),
                            Icons.calendar_month_rounded,
                            onPickFromDate,
                          ),
                          const SizedBox(height: 12),
                          _dateButton(
                            fmtDate(toDate),
                            Icons.calendar_month_rounded,
                            onPickToDate,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _dateButton(
                              fmtDate(fromDate),
                              Icons.calendar_month_rounded,
                              onPickFromDate,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dateButton(
                              fmtDate(toDate),
                              Icons.calendar_month_rounded,
                              onPickToDate,
                            ),
                          ),
                        ],
                      ),
              ),
              _FilterTile(
                title: 'Time Range',
                child: isNarrow
                    ? Column(
                        children: [
                          _dateButton(
                            fmtTime(fromTime),
                            Icons.schedule_rounded,
                            onPickFromTime,
                          ),
                          const SizedBox(height: 12),
                          _dateButton(
                            fmtTime(toTime),
                            Icons.schedule_rounded,
                            onPickToTime,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _dateButton(
                              fmtTime(fromTime),
                              Icons.schedule_rounded,
                              onPickFromTime,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dateButton(
                              fmtTime(toTime),
                              Icons.schedule_rounded,
                              onPickToTime,
                            ),
                          ),
                        ],
                      ),
              ),
              _FilterTile(
                title: 'Days',
                child: DropdownButtonFormField<String>(
                  value: const ['Select', 'Mon-Fri', 'Sat-Sun'].contains(days)
                      ? days
                      : 'Select',
                  items: const [
                    'Select',
                    'Mon-Fri',
                    'Sat-Sun',
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => onChangeDays(v ?? days),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              _FilterTile(
                title: 'Status',
                child: DropdownButtonFormField<String>(
                  value:
                      const [
                        'Select',
                        'Paid',
                        'Unpaid',
                        'Refunded',
                      ].contains(status)
                      ? status
                      : 'Select',
                  items: const [
                    'Select',
                    'Paid',
                    'Unpaid',
                    'Refunded',
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => onChangeStatus(v ?? status),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateButton(String label, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: const Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
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
      width: isNarrow ? double.infinity : 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 600;
            
            if (isNarrow) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _periodTab('ALL'),
                    const SizedBox(width: 8),
                    _periodTab('Financial Year'),
                    const SizedBox(width: 8),
                    _periodTab('Flexible Duration'),
                  ],
                ),
              );
            }
            
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _periodTab('ALL')),
                  const SizedBox(width: 8),
                  Expanded(child: _periodTab('Financial Year')),
                  const SizedBox(width: 8),
                  Expanded(child: _periodTab('Flexible Duration')),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _periodTab(String value) {
    final active = period == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: active 
                ? const Color(0xFF3B82F6).withValues(alpha: 0.1) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: active 
                    ? const Color(0xFF3B82F6) 
                    : const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _TableTabs extends StatelessWidget {
  final TabController controller;
  const _TableTabs({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: TabBar(
          controller: controller,
          isScrollable: true,
          padding: const EdgeInsets.all(4),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          labelColor: const Color(0xFF3B82F6),
          unselectedLabelColor: const Color(0xFF64748B),
          indicator: BoxDecoration(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Slack'),
              ),
            ),
            Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Corporate Branches'),
              ),
            ),
            Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Forum'),
              ),
            ),
            Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Member'),
              ),
            ),
            Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('User'),
              ),
            ),
            Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Event'),
              ),
            ),
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
    final ScrollController headerScrollController = ScrollController();
    final ScrollController bodyScrollController = ScrollController();

    // Calculate dynamic table width based on column widths
    const double tableWidth = 140 + 120 + 120 + 120 + 160 + 120 + 140 + 48; // +48 for padding

    // Synchronize horizontal scrolling between header and body
    void syncScroll(ScrollController source, ScrollController target) {
      if (source.hasClients && target.hasClients && source.offset != target.offset) {
        target.jumpTo(source.offset);
      }
    }

    headerScrollController.addListener(() {
      syncScroll(headerScrollController, bodyScrollController);
    });

    bodyScrollController.addListener(() {
      syncScroll(bodyScrollController, headerScrollController);
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.table_chart_rounded,
                    size: 20,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Transaction History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '20 Records',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed Table Headers
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Scrollbar(
                  controller: headerScrollController,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  child: SingleChildScrollView(
                    controller: headerScrollController,
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: math.min(constraints.maxWidth, tableWidth),
                      ),
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHeaderCell('Transaction ID', 140),
                            _buildHeaderCell('Start Date', 120),
                            _buildHeaderCell('End Date', 120),
                            _buildHeaderCell('Amount', 120),
                            _buildHeaderCell('Payment Method', 160),
                            _buildHeaderCell('Status', 120),
                            _buildHeaderCell('Actions', 140),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                },
            ),
          ),
          
          // Scrollable Table Body
          SizedBox(
            height: isWide ? 500 : 400,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Scrollbar(
                  controller: bodyScrollController,
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      controller: bodyScrollController,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: math.min(constraints.maxWidth, tableWidth),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: List<Widget>.generate(20, (i) {
                              final odd = i % 2 == 1;
                              return Container(
                                height: 72,
                                color: odd ? const Color(0xFFF8FAFC) : Colors.white,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildDataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '#${(i + 1).toString().padLeft(4, '0')}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Color(0xFFD97706),
                                          ),
                                        ),
                                      ),
                                      140,
                                    ),
                                    _buildDataCell(
                                      const Text(
                                        '28 Feb 2025',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Color(0xFF475569),
                                        ),
                                      ),
                                      120,
                                    ),
                                    _buildDataCell(
                                      const Text(
                                        '28 Feb 2026',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Color(0xFF475569),
                                        ),
                                      ),
                                      120,
                                    ),
                                    _buildDataCell(
                                      const Text(
                                        '₹1,000.00',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF059669),
                                        ),
                                      ),
                                      120,
                                    ),
                                    _buildDataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color(0xFFFBBF24).withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: const Text(
                                          'Bank Transfer',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFD97706),
                                          ),
                                        ),
                                      ),
                                      160,
                                    ),
                                    _buildDataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDCFCE7),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.check_circle_rounded,
                                              size: 12,
                                              color: Color(0xFF059669),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'Paid',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF059669),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      120,
                                    ),
                                    _buildDataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _ActionIconButton(
                                            icon: Icons.receipt_long_rounded,
                                            tooltip: 'Download Invoice',
                                            onTap: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Invoice downloaded'),
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          _ActionIconButton(
                                            icon: Icons.download_rounded,
                                            tooltip: 'Download Receipt',
                                            onTap: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Receipt downloaded'),
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      140,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
                },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, double width) {
    return Container(
      width: width,
      height: 56,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      height: 72,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Icon(
              icon,
              size: 16,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'SEKAI-ICHI',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Flexible(
            child: Text(
              '© 2024 SEKAI-ICHI Engineering And IT Solutions Pvt. Ltd',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
      child: child,
    );
  }
}
