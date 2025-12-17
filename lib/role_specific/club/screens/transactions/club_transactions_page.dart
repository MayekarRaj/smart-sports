import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/club/widgets/club_phone_filters.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';

class ClubTransactionsPage extends StatefulWidget {
  const ClubTransactionsPage({super.key});

  @override
  State<ClubTransactionsPage> createState() => _ClubTransactionsPageState();
}

class MediaUtils {
  final BuildContext context;
  MediaUtils(this.context);
  bool get isWide => MediaQuery.of(context).size.width >= 1000;
}

class _ClubTransactionsPageState extends State<ClubTransactionsPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tableTabs;
  final ScrollController _scrollController = ScrollController();
  final PageStorageKey<String> _storageKey = const PageStorageKey<String>(
    'club_transactions_scroll',
  );

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
  String _searchQuery = '';
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _filteredTransactions = [];
  int _currentPage = 0;

  // Financial Year filters
  String _financialYearStartMonth = 'JAN';
  final TextEditingController _financialYearStartYearController =
      TextEditingController();
  String _financialYearEndMonth = 'DEC';
  final TextEditingController _financialYearEndYearController =
      TextEditingController();

  // Flexible Duration filters (using existing _fromDate and _toDate)

  // Column-specific filters
  final TextEditingController _transactionIdFilterController =
      TextEditingController();
  final TextEditingController _amountFilterController = TextEditingController();
  final TextEditingController _paymentMethodFilterController =
      TextEditingController();
  final TextEditingController _paymentStatusFilterController =
      TextEditingController();
  DateTime? _startDateFilter;
  DateTime? _endDateFilter;
  DateTime? _paymentDateFilter;

  @override
  void initState() {
    super.initState();
    _tableTabs = TabController(length: 6, vsync: this);
    _tableTabs.addListener(_onTabChanged);
    _initializeData();
    _searchController.addListener(_onSearchChanged);

    // Add listeners for column filters
    _transactionIdFilterController.addListener(_onColumnFilterChanged);
    _amountFilterController.addListener(_onColumnFilterChanged);
    _paymentMethodFilterController.addListener(_onColumnFilterChanged);
    _paymentStatusFilterController.addListener(_onColumnFilterChanged);

    // Initialize financial year with current year
    final now = DateTime.now();
    _financialYearStartYearController.text = now.year.toString();
    _financialYearEndYearController.text = now.year.toString();
  }

  void _onColumnFilterChanged() {
    setState(() {
      _applyFilters();
    });
  }

  void _onTabChanged() {
    if (_tableTabs.indexIsChanging) {
      setState(() {
        _applyFilters();
      });
    }
  }

  void _initializeData() {
    _transactions = _generateSampleTransactions();
    _filteredTransactions = List.from(_transactions);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFilters();
    });
  }

  void _applyFilters() {
    _filteredTransactions = _transactions.where((transaction) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        if (!transaction['id'].toLowerCase().contains(searchLower) &&
            !transaction['amount'].toLowerCase().contains(searchLower) &&
            !transaction['paymentMethod'].toLowerCase().contains(searchLower) &&
            !transaction['type'].toLowerCase().contains(searchLower)) {
          return false;
        }
      }

      // Column-specific filters
      // Transaction ID filter
      if (_transactionIdFilterController.text.isNotEmpty) {
        if (!transaction['id'].toLowerCase().contains(
          _transactionIdFilterController.text.toLowerCase(),
        )) {
          return false;
        }
      }

      // Amount filter
      if (_amountFilterController.text.isNotEmpty) {
        if (!transaction['amount'].toLowerCase().contains(
          _amountFilterController.text.toLowerCase(),
        )) {
          return false;
        }
      }

      // Payment Method filter
      if (_paymentMethodFilterController.text.isNotEmpty) {
        if (!transaction['paymentMethod'].toLowerCase().contains(
          _paymentMethodFilterController.text.toLowerCase(),
        )) {
          return false;
        }
      }

      // Payment Status filter
      if (_paymentStatusFilterController.text.isNotEmpty) {
        if (!transaction['status'].toLowerCase().contains(
          _paymentStatusFilterController.text.toLowerCase(),
        )) {
          return false;
        }
      }

      // Start Date filter
      if (_startDateFilter != null) {
        final transactionDate = DateTime(
          transaction['date'].year,
          transaction['date'].month,
          transaction['date'].day,
        );
        final filterDate = DateTime(
          _startDateFilter!.year,
          _startDateFilter!.month,
          _startDateFilter!.day,
        );
        if (transactionDate.isBefore(filterDate)) {
          return false;
        }
      }

      // End Date filter
      if (_endDateFilter != null) {
        final transactionDate = DateTime(
          transaction['date'].year,
          transaction['date'].month,
          transaction['date'].day,
        );
        final filterDate = DateTime(
          _endDateFilter!.year,
          _endDateFilter!.month,
          _endDateFilter!.day,
        );
        if (transactionDate.isAfter(filterDate)) {
          return false;
        }
      }

      // Payment Date filter
      if (_paymentDateFilter != null) {
        final transactionDate = DateTime(
          transaction['date'].year,
          transaction['date'].month,
          transaction['date'].day,
        );
        final filterDate = DateTime(
          _paymentDateFilter!.year,
          _paymentDateFilter!.month,
          _paymentDateFilter!.day,
        );
        if (transactionDate.year != filterDate.year ||
            transactionDate.month != filterDate.month ||
            transactionDate.day != filterDate.day) {
          return false;
        }
      }

      // Status filter
      if (_status != 'Select' && transaction['status'] != _status) {
        return false;
      }

      // Date range filter (only for ALL period, period-specific filters handle their own dates)
      if (_period == 'ALL') {
        if (_fromDate != null && transaction['date'].isBefore(_fromDate!)) {
          return false;
        }
        if (_toDate != null && transaction['date'].isAfter(_toDate!)) {
          return false;
        }
      }

      // Period filter (applies date range based on period type)
      if (_period == 'Financial Year') {
        // Filter based on selected start month/year to end month/year
        final startYear =
            int.tryParse(_financialYearStartYearController.text) ??
            DateTime.now().year;
        final endYear =
            int.tryParse(_financialYearEndYearController.text) ??
            DateTime.now().year;
        final startMonth = _getMonthNumber(_financialYearStartMonth);
        final endMonth = _getMonthNumber(_financialYearEndMonth);

        final financialYearStart = DateTime(startYear, startMonth, 1);
        // Get last day of end month
        final financialYearEnd = DateTime(
          endYear,
          endMonth + 1,
          0,
        ); // Last day of end month

        if (transaction['date'].isBefore(financialYearStart) ||
            transaction['date'].isAfter(financialYearEnd)) {
          return false;
        }
      } else if (_period == 'Flexible Duration') {
        // Filter based on selected start date to end date
        if (_fromDate != null && transaction['date'].isBefore(_fromDate!)) {
          return false;
        }
        if (_toDate != null) {
          // Include the entire end date (set to end of day)
          final endOfDay = DateTime(
            _toDate!.year,
            _toDate!.month,
            _toDate!.day,
            23,
            59,
            59,
          );
          if (transaction['date'].isAfter(endOfDay)) {
            return false;
          }
        }
      }

      // Tab filter - filter by transaction type
      final currentTab = _tableTabs.index;
      final tabTypes = [
        'Slack',
        'Club Branches',
        'Forum',
        'Member',
        'User',
        'Event',
      ];
      if (currentTab < tabTypes.length &&
          transaction['type'] != tabTypes[currentTab]) {
        return false;
      }

      return true;
    }).toList();
  }

  List<Map<String, dynamic>> _generateSampleTransactions() {
    final List<Map<String, dynamic>> transactions = [];
    final List<String> paymentMethods = [
      'Bank Transfer',
      'Credit Card',
      'UPI',
      'Net Banking',
    ];
    final List<String> statuses = ['Paid', 'Unpaid', 'Refunded', 'Pending'];

    for (int i = 0; i < 50; i++) {
      transactions.add({
        'id': '#${(i + 1).toString().padLeft(4, '0')}',
        'date': DateTime.now().subtract(Duration(days: i)),
        'amount': '₹${(1000 + (i * 100)).toString()}',
        'paymentMethod': paymentMethods[i % paymentMethods.length],
        'status': statuses[i % statuses.length],
        'type': _getTransactionType(i),
      });
    }
    return transactions;
  }

  String _getTransactionType(int index) {
    final types = [
      'Slack',
      'Club Branches',
      'Forum',
      'Member',
      'User',
      'Event',
    ];
    return types[index % types.length];
  }

  @override
  void dispose() {
    _tableTabs.dispose();
    _searchController.dispose();
    _financialYearStartYearController.dispose();
    _financialYearEndYearController.dispose();
    _transactionIdFilterController.dispose();
    _amountFilterController.dispose();
    _paymentMethodFilterController.dispose();
    _paymentStatusFilterController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showInvoiceDialog(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invoice - ${transaction['id']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInvoiceRow('Transaction ID:', transaction['id']),
              _buildInvoiceRow('Date:', _formatDate(transaction['date'])),
              _buildInvoiceRow('Amount:', transaction['amount']),
              _buildInvoiceRow('Payment Method:', transaction['paymentMethod']),
              _buildInvoiceRow('Status:', transaction['status']),
              _buildInvoiceRow('Type:', transaction['type']),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Invoice for ${transaction['id']} downloaded successfully',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Download PDF'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInvoiceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  int _getMonthNumber(String monthAbbr) {
    const months = {
      'JAN': 1,
      'FEB': 2,
      'MAR': 3,
      'APR': 4,
      'MAY': 5,
      'JUN': 6,
      'JUL': 7,
      'AUG': 8,
      'SEP': 9,
      'OCT': 10,
      'NOV': 11,
      'DEC': 12,
    };
    return months[monthAbbr] ?? 1;
  }

  void _downloadReceipt(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Download Receipt'),
          content: Text(
            'Are you sure you want to download the receipt for ${transaction['id']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Receipt for ${transaction['id']} downloaded successfully',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Download'),
            ),
          ],
        );
      },
    );
  }

  void _onFilterChanged() {
    setState(() {
      _applyFilters();
    });
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context); // for AutomaticKeepAliveClientMixin
    final isWide = MediaUtils(context).isWide;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Transactions'),
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
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: Colors.black87,
            ),
            tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.club,
            selectedIndex: 0,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.club,
              i,
            ),
            onProfileTap: () =>
                RoleNavigationManager.navigateToProfile(context, UserRole.club),
            edgeToEdge: true,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            key: _storageKey,
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
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
                if (_showFilters)
                  ClubPhoneFilters(
                    initiallyExpanded: true,
                    searchController: _searchController,
                    fromDate: _fromDate,
                    toDate: _toDate,
                    fromTime: _fromTime,
                    toTime: _toTime,
                    onPickFromDate: () async {
                      final result = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2100),
                        initialDate: _fromDate ?? DateTime.now(),
                      );
                      if (!mounted) return;
                      if (result != null) {
                        setState(() => _fromDate = result);
                        _onFilterChanged();
                      }
                    },
                    onPickToDate: () async {
                      final result = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2100),
                        initialDate: _toDate ?? DateTime.now(),
                      );
                      if (!mounted) return;
                      if (result != null) {
                        setState(() => _toDate = result);
                        _onFilterChanged();
                      }
                    },
                    onPickFromTime: () async {
                      final result = await showTimePicker(
                        context: context,
                        initialTime: _fromTime ?? TimeOfDay.now(),
                      );
                      if (!mounted) return;
                      if (result != null) {
                        setState(() => _fromTime = result);
                        _onFilterChanged();
                      }
                    },
                    onPickToTime: () async {
                      final result = await showTimePicker(
                        context: context,
                        initialTime: _toTime ?? TimeOfDay.now(),
                      );
                      if (!mounted) return;
                      if (result != null) {
                        setState(() => _toTime = result);
                        _onFilterChanged();
                      }
                    },
                    days: _days,
                    onChangeDays: (v) {
                      setState(() => _days = v);
                      _onFilterChanged();
                    },
                    status: _status,
                    onChangeStatus: (v) {
                      setState(() => _status = v);
                      _onFilterChanged();
                    },
                  ),
                if (_showFilters) const SizedBox(height: 16),
                const SizedBox(height: 16),
                _PeriodChips(
                  period: _period,
                  onChanged: (v) {
                    setState(() => _period = v);
                    _onFilterChanged();
                  },
                ),
                const SizedBox(height: 16),
                // Period-specific filters
                if (_period == 'Financial Year')
                  _FinancialYearFilters(
                    startMonth: _financialYearStartMonth,
                    startYear: _financialYearStartYearController,
                    endMonth: _financialYearEndMonth,
                    endYear: _financialYearEndYearController,
                    onStartMonthChanged: (value) {
                      setState(() {
                        _financialYearStartMonth = value;
                        _onFilterChanged();
                      });
                    },
                    onStartYearChanged: () {
                      setState(() {
                        _onFilterChanged();
                      });
                    },
                    onEndMonthChanged: (value) {
                      setState(() {
                        _financialYearEndMonth = value;
                        _onFilterChanged();
                      });
                    },
                    onEndYearChanged: () {
                      setState(() {
                        _onFilterChanged();
                      });
                    },
                  ),
                if (_period == 'Financial Year') const SizedBox(height: 16),
                if (_period == 'Flexible Duration')
                  _FlexibleDurationFilters(
                    startDate: _fromDate,
                    endDate: _toDate,
                    onStartDateChanged: () async {
                      final result = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2100),
                        initialDate: _fromDate ?? DateTime.now(),
                      );
                      if (!mounted) return;
                      if (result != null) {
                        setState(() {
                          _fromDate = result;
                          _onFilterChanged();
                        });
                      }
                    },
                    onEndDateChanged: () async {
                      final result = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2100),
                        initialDate: _toDate ?? DateTime.now(),
                      );
                      if (!mounted) return;
                      if (result != null) {
                        setState(() {
                          _toDate = result;
                          _onFilterChanged();
                        });
                      }
                    },
                  ),
                if (_period == 'Flexible Duration') const SizedBox(height: 16),
                _TableTabs(controller: _tableTabs),
                const SizedBox(height: 12),
                _TableFilterRow(
                  transactionIdFilterController: _transactionIdFilterController,
                  amountFilterController: _amountFilterController,
                  paymentMethodFilterController: _paymentMethodFilterController,
                  paymentStatusFilterController: _paymentStatusFilterController,
                  startDateFilter: _startDateFilter,
                  endDateFilter: _endDateFilter,
                  paymentDateFilter: _paymentDateFilter,
                  onStartDateFilterChanged: () async {
                    final result = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2100),
                      initialDate: _startDateFilter ?? DateTime.now(),
                    );
                    if (!mounted) return;
                    if (result != null) {
                      setState(() {
                        _startDateFilter = result;
                        _onFilterChanged();
                      });
                    }
                  },
                  onEndDateFilterChanged: () async {
                    final result = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2100),
                      initialDate: _endDateFilter ?? DateTime.now(),
                    );
                    if (!mounted) return;
                    if (result != null) {
                      setState(() {
                        _endDateFilter = result;
                        _onFilterChanged();
                      });
                    }
                  },
                  onPaymentDateFilterChanged: () async {
                    final result = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2100),
                      initialDate: _paymentDateFilter ?? DateTime.now(),
                    );
                    if (!mounted) return;
                    if (result != null) {
                      setState(() {
                        _paymentDateFilter = result;
                        _onFilterChanged();
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                _TransactionsTable(
                  isWide: isWide,
                  transactions: _filteredTransactions,
                  showEntries: _showEntries,
                  currentPage: _currentPage,
                  transactionIdFilterController: _transactionIdFilterController,
                  amountFilterController: _amountFilterController,
                  paymentMethodFilterController: _paymentMethodFilterController,
                  paymentStatusFilterController: _paymentStatusFilterController,
                  startDateFilter: _startDateFilter,
                  endDateFilter: _endDateFilter,
                  paymentDateFilter: _paymentDateFilter,
                  onStartDateFilterChanged: () async {
                    final result = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2100),
                      initialDate: _startDateFilter ?? DateTime.now(),
                    );
                    if (!mounted) return;
                    if (result != null) {
                      setState(() {
                        _startDateFilter = result;
                        _onFilterChanged();
                      });
                    }
                  },
                  onEndDateFilterChanged: () async {
                    final result = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2100),
                      initialDate: _endDateFilter ?? DateTime.now(),
                    );
                    if (!mounted) return;
                    if (result != null) {
                      setState(() {
                        _endDateFilter = result;
                        _onFilterChanged();
                      });
                    }
                  },
                  onPaymentDateFilterChanged: () async {
                    final result = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2100),
                      initialDate: _paymentDateFilter ?? DateTime.now(),
                    );
                    if (!mounted) return;
                    if (result != null) {
                      setState(() {
                        _paymentDateFilter = result;
                        _onFilterChanged();
                      });
                    }
                  },
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  onEntriesChanged: (entries) {
                    setState(() {
                      _showEntries = entries;
                      _currentPage =
                          0; // Reset to first page when changing entries
                    });
                  },
                  onShowInvoice: _showInvoiceDialog,
                  onDownloadReceipt: _downloadReceipt,
                ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: value,
                    items: valid
                        .map(
                          (e) => DropdownMenuItem(value: e, child: Text('$e')),
                        )
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

// NOTE: Replaced by ClubPhoneFilters; keeping implementation commented out
/* class _FiltersCard extends StatelessWidget {
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
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
                        Icons.calendar_today,
                        onPickFromDate,
                      ),
                      const SizedBox(height: 8),
                      _dateButton(
                        fmtDate(toDate),
                        Icons.calendar_today,
                        onPickToDate,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _dateButton(
                          fmtDate(fromDate),
                          Icons.calendar_today,
                          onPickFromDate,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _dateButton(
                          fmtDate(toDate),
                          Icons.calendar_today,
                          onPickToDate,
                        ),
                      ),
                    ],
                  ),
          ),
          _FilterTile(
            title: 'Time',
            child: isNarrow
                ? Column(
                    children: [
                      _dateButton(
                        fmtTime(fromTime),
                        Icons.schedule,
                        onPickFromTime,
                      ),
                      const SizedBox(height: 8),
                      _dateButton(
                        fmtTime(toTime),
                        Icons.schedule,
                        onPickToTime,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _dateButton(
                          fmtTime(fromTime),
                          Icons.schedule,
                          onPickFromTime,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _dateButton(
                          fmtTime(toTime),
                          Icons.schedule,
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
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
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
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
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
} */

// Obsolete, kept to preserve edit history while we migrate to ClubPhoneFilters
// class _FilterTile extends StatelessWidget { ... }

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
          labelColor: const Color(0xFF1E40AF),
          unselectedLabelColor: const Color(0xFF4B5563),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: Color(0xFF1E40AF), width: 3),
            insets: EdgeInsets.symmetric(horizontal: 16),
          ),
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

class _TableFilterRow extends StatelessWidget {
  final TextEditingController transactionIdFilterController;
  final TextEditingController amountFilterController;
  final TextEditingController paymentMethodFilterController;
  final TextEditingController paymentStatusFilterController;
  final DateTime? startDateFilter;
  final DateTime? endDateFilter;
  final DateTime? paymentDateFilter;
  final VoidCallback onStartDateFilterChanged;
  final VoidCallback onEndDateFilterChanged;
  final VoidCallback onPaymentDateFilterChanged;

  const _TableFilterRow({
    required this.transactionIdFilterController,
    required this.amountFilterController,
    required this.paymentMethodFilterController,
    required this.paymentStatusFilterController,
    required this.startDateFilter,
    required this.endDateFilter,
    required this.paymentDateFilter,
    required this.onStartDateFilterChanged,
    required this.onEndDateFilterChanged,
    required this.onPaymentDateFilterChanged,
  });

  String _formatDateForFilter(DateTime? date) {
    if (date == null) return '';
    return '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}-${date.year}';
  }

  Widget _buildSearchFilter({
    required TextEditingController controller,
    required String hintText,
    bool isMobile = false,
  }) {
    final height = isMobile ? 36.0 : 40.0;
    final fontSize = isMobile ? 13.0 : 14.0;
    final iconSize = isMobile ? 16.0 : 18.0;
    final padding = isMobile ? 10.0 : 12.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: iconSize,
            color: const Color(0xFF6B7280),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: isMobile ? 8 : 10,
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildDateFilter({
    required DateTime? date,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    final height = isMobile ? 36.0 : 40.0;
    final fontSize = isMobile ? 13.0 : 14.0;
    final iconSize = isMobile ? 16.0 : 18.0;
    final padding = isMobile ? 10.0 : 12.0;
    final spacing = isMobile ? 6.0 : 8.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: isMobile ? 8 : 10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                _formatDateForFilter(date),
                style: TextStyle(
                  fontSize: fontSize,
                  color: date == null ? Colors.grey[600] : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: spacing),
            Icon(
              Icons.calendar_today,
              size: iconSize,
              color: const Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCell({
    required Widget child,
    bool showFilterIcon = true,
    bool isMobile = false,
  }) {
    final padding = isMobile ? 10.0 : 12.0;
    final iconSize = isMobile ? 18.0 : 20.0;
    final spacing = isMobile ? 8.0 : 10.0;

    return Container(
      padding: EdgeInsets.all(padding),
      constraints: BoxConstraints(minHeight: isMobile ? 44 : 48),
      child: showFilterIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: child),
                SizedBox(width: spacing),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.filter_list,
                    size: iconSize,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : child,
    );
  }

  Widget _buildFilterItem({
    required Widget child,
    required String label,
    bool showFilterIcon = true,
    bool isMobile = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: isMobile ? 8.0 : 10.0, left: 4),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isMobile ? 11.5 : 12.5,
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        _buildFilterCell(
          showFilterIcon: showFilterIcon,
          isMobile: isMobile,
          child: child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    final containerPadding = isMobile ? 16.0 : 20.0;
    final spacing = isMobile ? 12.0 : 16.0;

    if (isMobile) {
      // Mobile: Split into 2 rows - 4 filters in first row, 3 in second row
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF374151), const Color(0xFF4B5563)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(containerPadding),
        child: Column(
          children: [
            // First Row: 4 filters
            Row(
              children: [
                Expanded(
                  child: _buildFilterItem(
                    label: 'Transaction ID',
                    showFilterIcon: true,
                    isMobile: isMobile,
                    child: _buildSearchFilter(
                      controller: transactionIdFilterController,
                      hintText: 'Search',
                      isMobile: isMobile,
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: _buildFilterItem(
                    label: 'Start Date',
                    showFilterIcon: false,
                    isMobile: isMobile,
                    child: _buildDateFilter(
                      date: startDateFilter,
                      onTap: onStartDateFilterChanged,
                      isMobile: isMobile,
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: _buildFilterItem(
                    label: 'End Date',
                    showFilterIcon: false,
                    isMobile: isMobile,
                    child: _buildDateFilter(
                      date: endDateFilter,
                      onTap: onEndDateFilterChanged,
                      isMobile: isMobile,
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: _buildFilterItem(
                    label: 'Amount',
                    showFilterIcon: true,
                    isMobile: isMobile,
                    child: _buildSearchFilter(
                      controller: amountFilterController,
                      hintText: 'Search',
                      isMobile: isMobile,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing + 8),
            // Second Row: 3 filters
            Row(
              children: [
                Expanded(
                  child: _buildFilterItem(
                    label: 'Payment Method',
                    showFilterIcon: true,
                    isMobile: isMobile,
                    child: _buildSearchFilter(
                      controller: paymentMethodFilterController,
                      hintText: 'Search',
                      isMobile: isMobile,
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: _buildFilterItem(
                    label: 'Payment Status',
                    showFilterIcon: true,
                    isMobile: isMobile,
                    child: _buildSearchFilter(
                      controller: paymentStatusFilterController,
                      hintText: 'Search',
                      isMobile: isMobile,
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: _buildFilterItem(
                    label: 'Payment Date',
                    showFilterIcon: false,
                    isMobile: isMobile,
                    child: _buildDateFilter(
                      date: paymentDateFilter,
                      onTap: onPaymentDateFilterChanged,
                      isMobile: isMobile,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // Desktop: All filters in one row
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF374151), const Color(0xFF4B5563)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(containerPadding),
        child: Row(
          children: [
            Expanded(
              child: _buildFilterItem(
                label: 'Transaction ID',
                showFilterIcon: true,
                isMobile: isMobile,
                child: _buildSearchFilter(
                  controller: transactionIdFilterController,
                  hintText: 'Search',
                  isMobile: isMobile,
                ),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildFilterItem(
                label: 'Start Date',
                showFilterIcon: false,
                isMobile: isMobile,
                child: _buildDateFilter(
                  date: startDateFilter,
                  onTap: onStartDateFilterChanged,
                  isMobile: isMobile,
                ),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildFilterItem(
                label: 'End Date',
                showFilterIcon: false,
                isMobile: isMobile,
                child: _buildDateFilter(
                  date: endDateFilter,
                  onTap: onEndDateFilterChanged,
                  isMobile: isMobile,
                ),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildFilterItem(
                label: 'Amount',
                showFilterIcon: true,
                isMobile: isMobile,
                child: _buildSearchFilter(
                  controller: amountFilterController,
                  hintText: 'Search',
                  isMobile: isMobile,
                ),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildFilterItem(
                label: 'Payment Method',
                showFilterIcon: true,
                isMobile: isMobile,
                child: _buildSearchFilter(
                  controller: paymentMethodFilterController,
                  hintText: 'Search',
                  isMobile: isMobile,
                ),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildFilterItem(
                label: 'Payment Status',
                showFilterIcon: true,
                isMobile: isMobile,
                child: _buildSearchFilter(
                  controller: paymentStatusFilterController,
                  hintText: 'Search',
                  isMobile: isMobile,
                ),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildFilterItem(
                label: 'Payment Date',
                showFilterIcon: false,
                isMobile: isMobile,
                child: _buildDateFilter(
                  date: paymentDateFilter,
                  onTap: onPaymentDateFilterChanged,
                  isMobile: isMobile,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _TransactionsTable extends StatelessWidget {
  final bool isWide;
  final List<Map<String, dynamic>> transactions;
  final int showEntries;
  final int currentPage;
  final TextEditingController transactionIdFilterController;
  final TextEditingController amountFilterController;
  final TextEditingController paymentMethodFilterController;
  final TextEditingController paymentStatusFilterController;
  final DateTime? startDateFilter;
  final DateTime? endDateFilter;
  final DateTime? paymentDateFilter;
  final VoidCallback onStartDateFilterChanged;
  final VoidCallback onEndDateFilterChanged;
  final VoidCallback onPaymentDateFilterChanged;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onEntriesChanged;
  final Function(Map<String, dynamic>) onShowInvoice;
  final Function(Map<String, dynamic>) onDownloadReceipt;

  const _TransactionsTable({
    required this.isWide,
    required this.transactions,
    required this.showEntries,
    required this.currentPage,
    required this.transactionIdFilterController,
    required this.amountFilterController,
    required this.paymentMethodFilterController,
    required this.paymentStatusFilterController,
    required this.startDateFilter,
    required this.endDateFilter,
    required this.paymentDateFilter,
    required this.onStartDateFilterChanged,
    required this.onEndDateFilterChanged,
    required this.onPaymentDateFilterChanged,
    required this.onPageChanged,
    required this.onEntriesChanged,
    required this.onShowInvoice,
    required this.onDownloadReceipt,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Color _getPaymentMethodColor(String method) {
    switch (method) {
      case 'Bank Transfer':
        return const Color(0xFF1E40AF);
      case 'Credit Card':
        return const Color(0xFF7C3AED);
      case 'UPI':
        return const Color(0xFF059669);
      case 'Net Banking':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color(0xFF059669);
      case 'Unpaid':
        return const Color(0xFFDC2626);
      case 'Refunded':
        return const Color(0xFF7C3AED);
      case 'Pending':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Widget _buildCustomTable(
    BuildContext context,
    List<Map<String, dynamic>> paginatedTransactions,
    bool isNarrow,
  ) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1.3),
        2: FlexColumnWidth(1.3),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(1.5),
        5: FlexColumnWidth(1.8),
        6: FlexColumnWidth(1.3),
      },
      border: TableBorder(
        top: BorderSide(color: Colors.grey[300]!),
        bottom: BorderSide(color: Colors.grey[300]!),
        horizontalInside: BorderSide(color: Colors.grey[200]!),
        verticalInside: BorderSide(color: Colors.grey[200]!),
      ),
      children: [
        // Header Row
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFF3F4F6)),
          children: [
            _buildHeaderCell('Transaction ID'),
            _buildHeaderCell('Start Date'),
            _buildHeaderCell('End Date'),
            _buildHeaderCell('Amount'),
            _buildHeaderCell('Payment Method'),
            _buildHeaderCell('Payment Status'),
            _buildHeaderCell('Payment Date'),
          ],
        ),
        // Data Rows
        ...paginatedTransactions.asMap().entries.map((entry) {
          final i = entry.key;
          final transaction = entry.value;
          final odd = i % 2 == 1;
          return TableRow(
            decoration: BoxDecoration(
              color: odd ? const Color(0xFFF9FAFB) : Colors.white,
            ),
            children: [
              _buildDataCell(
                child: Text(
                  transaction['id'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1E40AF),
                  ),
                ),
              ),
              _buildDataCell(
                child: Text(
                  _formatDate(transaction['date']),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              _buildDataCell(
                child: Text(
                  _formatDate(
                    transaction['date'].add(const Duration(days: 365)),
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              _buildDataCell(
                child: Text(
                  transaction['amount'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
              _buildDataCell(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getPaymentMethodColor(
                      transaction['paymentMethod'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    transaction['paymentMethod'],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _getPaymentMethodColor(
                        transaction['paymentMethod'],
                      ),
                    ),
                  ),
                ),
              ),
              _buildDataCell(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          transaction['status'],
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        transaction['status'],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(transaction['status']),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => onShowInvoice(transaction),
                      child: const Text(
                        'Invoice',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1E40AF),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => onDownloadReceipt(transaction),
                      child: const Text(
                        'Receipt',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1E40AF),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildDataCell(
                child: Text(
                  _formatDate(transaction['date']),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildDataCell({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 700;

    final startIndex = currentPage * showEntries;
    final endIndex = (startIndex + showEntries).clamp(0, transactions.length);
    final paginatedTransactions = transactions.sublist(startIndex, endIndex);

    // Build custom table with filter row
    final table = _buildCustomTable(context, paginatedTransactions, isNarrow);

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
      child: isNarrow
          ? Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: paginatedTransactions.length,
                  itemBuilder: (context, i) {
                    final transaction = paginatedTransactions[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                transaction['id'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E40AF),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    transaction['status'],
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  transaction['status'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(
                                      transaction['status'],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.event,
                                size: 16,
                                color: Color(0xFF6B7280),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${_formatDate(transaction['date'])} → ${_formatDate(transaction['date'].add(const Duration(days: 365)))}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF374151),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getPaymentMethodColor(
                                    transaction['paymentMethod'],
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  transaction['paymentMethod'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: _getPaymentMethodColor(
                                      transaction['paymentMethod'],
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                transaction['amount'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => onShowInvoice(transaction),
                                child: const Text(
                                  'Invoice',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1E40AF),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => onDownloadReceipt(transaction),
                                child: const Text(
                                  'Receipt',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1E40AF),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildPaginationControls(),
              ],
            )
          : Column(
              children: [
                SizedBox(
                  height: isWide ? 520 : 420,
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 1200),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: table,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPaginationControls(),
              ],
            ),
    );
  }

  Widget _buildPaginationControls() {
    final totalPages = (transactions.length / showEntries).ceil();
    final startItem = transactions.length > 0
        ? currentPage * showEntries + 1
        : 0;
    final endItem = ((currentPage + 1) * showEntries).clamp(
      0,
      transactions.length,
    );

    // Handle edge case when there are no transactions
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Center(
          child: Text(
            'No transactions found',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $startItem to $endItem of ${transactions.length} entries',
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          Row(
            children: [
              IconButton(
                onPressed: currentPage > 0
                    ? () => onPageChanged(currentPage - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
                iconSize: 20,
              ),
              ...List.generate(totalPages.clamp(0, 5), (index) {
                final pageIndex = currentPage < 3
                    ? index
                    : currentPage - 2 + index;
                if (pageIndex >= totalPages) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Material(
                    color: pageIndex == currentPage
                        ? const Color(0xFF1E40AF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      onTap: () => onPageChanged(pageIndex),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Text(
                          '${pageIndex + 1}',
                          style: TextStyle(
                            color: pageIndex == currentPage
                                ? Colors.white
                                : const Color(0xFF6B7280),
                            fontWeight: pageIndex == currentPage
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              IconButton(
                onPressed: currentPage < totalPages - 1
                    ? () => onPageChanged(currentPage + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
                iconSize: 20,
              ),
            ],
          ),
        ],
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

class _FooterSection extends StatelessWidget {
  const _FooterSection();
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

class _FinancialYearFilters extends StatelessWidget {
  final String startMonth;
  final TextEditingController startYear;
  final String endMonth;
  final TextEditingController endYear;
  final ValueChanged<String> onStartMonthChanged;
  final VoidCallback onStartYearChanged;
  final ValueChanged<String> onEndMonthChanged;
  final VoidCallback onEndYearChanged;

  const _FinancialYearFilters({
    required this.startMonth,
    required this.startYear,
    required this.endMonth,
    required this.endYear,
    required this.onStartMonthChanged,
    required this.onStartYearChanged,
    required this.onEndMonthChanged,
    required this.onEndYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    const monthOptions = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Financial Year Filter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Month',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: startMonth,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              items: monthOptions.map((String month) {
                                return DropdownMenuItem<String>(
                                  value: month,
                                  child: Text(month),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  onStartMonthChanged(value);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: TextFormField(
                              controller: startYear,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Year',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              onChanged: (_) => onStartYearChanged(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'End Month',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: endMonth,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              items: monthOptions.map((String month) {
                                return DropdownMenuItem<String>(
                                  value: month,
                                  child: Text(month),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  onEndMonthChanged(value);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: TextFormField(
                              controller: endYear,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Year',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              onChanged: (_) => onEndYearChanged(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlexibleDurationFilters extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onStartDateChanged;
  final VoidCallback onEndDateChanged;

  const _FlexibleDurationFilters({
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${_getMonthAbbr(date.month)}-${date.day.toString().padLeft(2, '0')}-${date.year}';
  }

  String _getMonthAbbr(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Flexible Duration Filter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: onStartDateChanged,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(startDate),
                              style: TextStyle(
                                fontSize: 16,
                                color: startDate == null
                                    ? Colors.grey[400]
                                    : Colors.black87,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: Color(0xFF64748B),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'End Date',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: onEndDateChanged,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(endDate),
                              style: TextStyle(
                                fontSize: 16,
                                color: endDate == null
                                    ? Colors.grey[400]
                                    : Colors.black87,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: Color(0xFF64748B),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
