import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';

class MemberTransactionsPage extends StatefulWidget {
  const MemberTransactionsPage({super.key});

  @override
  State<MemberTransactionsPage> createState() => _MemberTransactionsPageState();
}

class _MemberTransactionsPageState extends State<MemberTransactionsPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tableTabs;
  final ScrollController _scrollController = ScrollController();
  final PageStorageKey<String> _storageKey = const PageStorageKey<String>(
    'member_transactions_scroll',
  );

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _transactionIdSearchController =
      TextEditingController();
  final TextEditingController _amountSearchController = TextEditingController();
  final TextEditingController _paymentMethodSearchController =
      TextEditingController();
  final TextEditingController _paymentStatusSearchController =
      TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _paymentDate;
  String _period = 'ALL'; // ALL, Financial Year, Flexible Duration
  String _searchQuery = '';
  int _showEntries = 10;
  int _currentPage = 0;

  // Financial Year filters
  String _financialYearStartMonth = 'JAN';
  final TextEditingController _financialYearStartYearController =
      TextEditingController(text: '2021');
  String _financialYearEndMonth = 'DEC';
  final TextEditingController _financialYearEndYearController =
      TextEditingController(text: '2021');

  // Flexible Duration date filters
  DateTime? _flexibleStartDate;
  DateTime? _flexibleEndDate;

  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _tableTabs = TabController(length: 4, vsync: this);
    _initializeData();
    _tableTabs.addListener(_onTabChanged);
    _searchController.addListener(_onSearchChanged);
    // Delay adding listeners to ensure TabController is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _transactionIdSearchController.addListener(_applyFilters);
        _amountSearchController.addListener(_applyFilters);
        _paymentMethodSearchController.addListener(_applyFilters);
        _paymentStatusSearchController.addListener(_applyFilters);
        _applyFilters(); // Initial filter application
      }
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
    if (!mounted) return;
    setState(() {
      _filteredTransactions = _transactions.where((transaction) {
        // Global search filter
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          if (!transaction['id'].toLowerCase().contains(searchLower) &&
              !transaction['amount'].toLowerCase().contains(searchLower) &&
              !transaction['paymentMethod'].toLowerCase().contains(
                searchLower,
              ) &&
              !transaction['status'].toLowerCase().contains(searchLower)) {
            return false;
          }
        }

        // Column-specific search filters
        if (_transactionIdSearchController.text.isNotEmpty) {
          if (!transaction['id'].toLowerCase().contains(
            _transactionIdSearchController.text.toLowerCase(),
          )) {
            return false;
          }
        }

        if (_amountSearchController.text.isNotEmpty) {
          if (!transaction['amount'].toLowerCase().contains(
            _amountSearchController.text.toLowerCase(),
          )) {
            return false;
          }
        }

        if (_paymentMethodSearchController.text.isNotEmpty) {
          if (!transaction['paymentMethod'].toLowerCase().contains(
            _paymentMethodSearchController.text.toLowerCase(),
          )) {
            return false;
          }
        }

        if (_paymentStatusSearchController.text.isNotEmpty) {
          if (!transaction['status'].toLowerCase().contains(
            _paymentStatusSearchController.text.toLowerCase(),
          )) {
            return false;
          }
        }

        // Period filter
        if (_period == 'Financial Year') {
          final startYear =
              int.tryParse(_financialYearStartYearController.text) ?? 2021;
          final endYear =
              int.tryParse(_financialYearEndYearController.text) ?? 2021;
          final startMonth = _getMonthNumber(_financialYearStartMonth);
          final endMonth = _getMonthNumber(_financialYearEndMonth);

          final periodStart = DateTime(startYear, startMonth, 1);
          final periodEnd = DateTime(endYear, endMonth + 1, 0);

          if (transaction['startDate'].isBefore(periodStart) ||
              transaction['startDate'].isAfter(periodEnd)) {
            return false;
          }
        } else if (_period == 'Flexible Duration') {
          if (_flexibleStartDate != null &&
              transaction['startDate'].isBefore(_flexibleStartDate!)) {
            return false;
          }
          if (_flexibleEndDate != null &&
              transaction['endDate'].isAfter(_flexibleEndDate!)) {
            return false;
          }
        }

        // Date filters
        if (_startDate != null &&
            transaction['startDate'].isBefore(_startDate!)) {
          return false;
        }
        if (_endDate != null && transaction['endDate'].isAfter(_endDate!)) {
          return false;
        }
        if (_paymentDate != null &&
            !_isSameDay(transaction['paymentDate'], _paymentDate!)) {
          return false;
        }

        // Tab filter - filter by transaction type
        try {
          final currentTab = _tableTabs.index;
          final tabTypes = ['Slack', 'Club', 'Forum', 'Event/Tournament'];
          if (currentTab < tabTypes.length &&
              transaction['type'] != tabTypes[currentTab]) {
            return false;
          }
        } catch (e) {
          // TabController not ready yet, skip tab filtering
        }

        return true;
      }).toList();
      _currentPage = 0; // Reset to first page when filters change
    });
  }

  int _getMonthNumber(String month) {
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
    return months[month] ?? 1;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<Map<String, dynamic>> _generateSampleTransactions() {
    final List<Map<String, dynamic>> transactions = [];
    final List<String> paymentMethods = [
      'Bank Transfer',
      'Credit Card',
      'UPI',
      'Net Banking',
      'PayPal',
    ];
    final List<String> statuses = ['Paid', 'Unpaid', 'Refunded', 'Pending'];
    final List<String> types = [
      'Slack',
      'Club',
      'Forum',
      'Member',
      'Event/Tournament',
    ];

    for (int i = 0; i < 30; i++) {
      final startDate = DateTime(2021, 1, 1).add(Duration(days: i * 30));
      final endDate = startDate.add(const Duration(days: 365));
      final paymentDate = startDate.add(const Duration(days: 5));

      transactions.add({
        'id': (i + 1).toString(),
        'startDate': startDate,
        'endDate': endDate,
        'paymentDate': paymentDate,
        'amount': 'USD ${(1000 + (i * 100)).toString()}',
        'paymentMethod': paymentMethods[i % paymentMethods.length],
        'status': statuses[i % statuses.length],
        'type': types[i % types.length],
      });
    }
    return transactions;
  }

  @override
  void dispose() {
    _tableTabs.dispose();
    _searchController.dispose();
    _transactionIdSearchController.dispose();
    _amountSearchController.dispose();
    _paymentMethodSearchController.dispose();
    _paymentStatusSearchController.dispose();
    _financialYearStartYearController.dispose();
    _financialYearEndYearController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showInvoiceDialog(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invoice - Transaction ${transaction['id']}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInvoiceRow('Transaction ID:', transaction['id']),
                _buildInvoiceRow(
                  'Start Date:',
                  _formatDate(transaction['startDate']),
                ),
                _buildInvoiceRow(
                  'End Date:',
                  _formatDate(transaction['endDate']),
                ),
                _buildInvoiceRow('Amount:', transaction['amount']),
                _buildInvoiceRow(
                  'Payment Method:',
                  transaction['paymentMethod'],
                ),
                _buildInvoiceRow('Status:', transaction['status']),
                _buildInvoiceRow('Type:', transaction['type']),
                _buildInvoiceRow(
                  'Payment Date:',
                  _formatDate(transaction['paymentDate']),
                ),
              ],
            ),
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
                      'Invoice for Transaction ${transaction['id']} downloaded successfully',
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

  void _downloadReceipt(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Download Receipt'),
          content: Text(
            'Are you sure you want to download the receipt for Transaction ${transaction['id']}?',
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
                      'Receipt for Transaction ${transaction['id']} downloaded successfully',
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
    _applyFilters();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 768;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Transactions'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF009A69), Color(0xFF232534)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
            role: UserRole.member,
            selectedIndex: 1,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.member,
              i,
            ),
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.member,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            key: _storageKey,
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              isMobile ? 12 : 16,
              16,
              isMobile ? 12 : 16,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShowAndSearchRow(
                  showEntries: _showEntries,
                  onEntriesChanged: (v) {
                    setState(() {
                      _showEntries = v;
                      _currentPage = 0;
                    });
                  },
                  searchController: _searchController,
                  isMobile: isMobile,
                ),
                const SizedBox(height: 16),
                _PeriodChips(
                  period: _period,
                  onChanged: (v) {
                    setState(() {
                      _period = v;
                      _onFilterChanged();
                    });
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _TableTabs(controller: _tableTabs),
                      if (_period == 'Financial Year' ||
                          _period == 'Flexible Duration') ...[
                        const SizedBox(height: 16),
                        _DateRangeFilters(
                          period: _period,
                          financialYearStartMonth: _financialYearStartMonth,
                          financialYearStartYear:
                              _financialYearStartYearController,
                          financialYearEndMonth: _financialYearEndMonth,
                          financialYearEndYear: _financialYearEndYearController,
                          flexibleStartDate: _flexibleStartDate,
                          flexibleEndDate: _flexibleEndDate,
                          onFinancialYearStartMonthChanged: (month) {
                            setState(() {
                              _financialYearStartMonth = month;
                              _onFilterChanged();
                            });
                          },
                          onFinancialYearStartYearChanged: (year) {
                            _onFilterChanged();
                          },
                          onFinancialYearEndMonthChanged: (month) {
                            setState(() {
                              _financialYearEndMonth = month;
                              _onFilterChanged();
                            });
                          },
                          onFinancialYearEndYearChanged: (year) {
                            _onFilterChanged();
                          },
                          onFlexibleStartDateChanged: (date) {
                            setState(() {
                              _flexibleStartDate = date;
                              _onFilterChanged();
                            });
                          },
                          onFlexibleEndDateChanged: (date) {
                            setState(() {
                              _flexibleEndDate = date;
                              _onFilterChanged();
                            });
                          },
                          isMobile: isMobile,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _FilterBar(
                  isMobile: isMobile,
                  transactionIdSearchController: _transactionIdSearchController,
                  amountSearchController: _amountSearchController,
                  paymentMethodSearchController: _paymentMethodSearchController,
                  paymentStatusSearchController: _paymentStatusSearchController,
                  paymentDate: _paymentDate,
                  onPaymentDateChanged: (date) {
                    setState(() {
                      _paymentDate = date;
                      _onFilterChanged();
                    });
                  },
                ),
                const SizedBox(height: 16),
                _TransactionsTable(
                  isMobile: isMobile,
                  transactions: _filteredTransactions,
                  showEntries: _showEntries,
                  currentPage: _currentPage,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  transactionIdSearchController: _transactionIdSearchController,
                  amountSearchController: _amountSearchController,
                  paymentMethodSearchController: _paymentMethodSearchController,
                  paymentStatusSearchController: _paymentStatusSearchController,
                  paymentDate: _paymentDate,
                  onPaymentDateChanged: (date) {
                    setState(() {
                      _paymentDate = date;
                      _onFilterChanged();
                    });
                  },
                  onShowInvoice: _showInvoiceDialog,
                  onDownloadReceipt: _downloadReceipt,
                ),
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
  final bool isMobile;
  const _ShowAndSearchRow({
    required this.showEntries,
    required this.onEntriesChanged,
    required this.searchController,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final valid = const [10, 25, 50, 100];
    final value = valid.contains(showEntries) ? showEntries : 10;
    final searchField = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF009A69), width: 1.5),
      ),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Search Here',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Color(0xFF009A69)),
          suffixIcon: Icon(Icons.search, color: Color(0xFF009A69)),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Show'),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF009A69),
                    width: 1.5,
                  ),
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

class _RoundedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _RoundedContainer({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26),
      ),
      child: child,
    );
  }
}

class _PeriodChips extends StatelessWidget {
  final String period;
  final ValueChanged<String> onChanged;
  const _PeriodChips({required this.period, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    Widget chip(String v) {
      final active = period == v;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => onChanged(v),
          child: Container(
            decoration: BoxDecoration(
              gradient: active
                  ? const LinearGradient(
                      colors: [Color(0xFF009A69), Color(0xFF232534)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: active ? null : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: active ? Colors.transparent : Colors.black26,
                width: 1.5,
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        blurRadius: 8,
                        color: const Color(0xFF009A69).withValues(alpha: 0.3),
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 14 : 16,
              vertical: isMobile ? 10 : 12,
            ),
            child: Text(
              v,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 13 : 14,
                color: active ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      );
    }

    final chips = [
      chip('ALL'),
      chip('Financial Year'),
      chip('Flexible Duration'),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...chips,
            const SizedBox(width: 12), // Extra padding at end
          ],
        ),
      );
    }

    return Wrap(spacing: 12, runSpacing: 12, children: chips);
  }
}

class _TableTabs extends StatelessWidget {
  final TabController controller;
  const _TableTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

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
          labelColor: const Color(0xFF009A69),
          unselectedLabelColor: const Color(0xFF4B5563),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isMobile ? 14 : 16,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isMobile ? 14 : 16,
          ),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: Color(0xFF009A69), width: 3),
            insets: EdgeInsets.symmetric(horizontal: 16),
          ),
          tabs: const [
            Tab(text: 'Slack Transaction'),
            Tab(text: 'Club Transaction'),
            Tab(text: 'Forum Transaction'),
            Tab(text: 'Event / Tournament'),
          ],
        ),
      ),
    );
  }
}

class _DateRangeFilters extends StatelessWidget {
  final String period;
  final String financialYearStartMonth;
  final TextEditingController financialYearStartYear;
  final String financialYearEndMonth;
  final TextEditingController financialYearEndYear;
  final DateTime? flexibleStartDate;
  final DateTime? flexibleEndDate;
  final ValueChanged<String> onFinancialYearStartMonthChanged;
  final ValueChanged<String> onFinancialYearStartYearChanged;
  final ValueChanged<String> onFinancialYearEndMonthChanged;
  final ValueChanged<String> onFinancialYearEndYearChanged;
  final ValueChanged<DateTime?> onFlexibleStartDateChanged;
  final ValueChanged<DateTime?> onFlexibleEndDateChanged;
  final bool isMobile;

  const _DateRangeFilters({
    required this.period,
    required this.financialYearStartMonth,
    required this.financialYearStartYear,
    required this.financialYearEndMonth,
    required this.financialYearEndYear,
    required this.flexibleStartDate,
    required this.flexibleEndDate,
    required this.onFinancialYearStartMonthChanged,
    required this.onFinancialYearStartYearChanged,
    required this.onFinancialYearEndMonthChanged,
    required this.onFinancialYearEndYearChanged,
    required this.onFlexibleStartDateChanged,
    required this.onFlexibleEndDateChanged,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (period == 'Financial Year') {
      return isMobile
          ? Column(
              children: [
                _FinancialYearField(
                  label: 'Start Month',
                  month: financialYearStartMonth,
                  year: financialYearStartYear,
                  onMonthChanged: onFinancialYearStartMonthChanged,
                  onYearChanged: onFinancialYearStartYearChanged,
                ),
                const SizedBox(height: 12),
                _FinancialYearField(
                  label: 'End Month',
                  month: financialYearEndMonth,
                  year: financialYearEndYear,
                  onMonthChanged: onFinancialYearEndMonthChanged,
                  onYearChanged: onFinancialYearEndYearChanged,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _FinancialYearField(
                    label: 'Start Month',
                    month: financialYearStartMonth,
                    year: financialYearStartYear,
                    onMonthChanged: onFinancialYearStartMonthChanged,
                    onYearChanged: onFinancialYearStartYearChanged,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _FinancialYearField(
                    label: 'End Month',
                    month: financialYearEndMonth,
                    year: financialYearEndYear,
                    onMonthChanged: onFinancialYearEndMonthChanged,
                    onYearChanged: onFinancialYearEndYearChanged,
                  ),
                ),
              ],
            );
    } else if (period == 'Flexible Duration') {
      return isMobile
          ? Column(
              children: [
                _FlexibleDateField(
                  label: 'Start Date',
                  date: flexibleStartDate,
                  onDateChanged: onFlexibleStartDateChanged,
                ),
                const SizedBox(height: 12),
                _FlexibleDateField(
                  label: 'End Date',
                  date: flexibleEndDate,
                  onDateChanged: onFlexibleEndDateChanged,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _FlexibleDateField(
                    label: 'Start Date',
                    date: flexibleStartDate,
                    onDateChanged: onFlexibleStartDateChanged,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _FlexibleDateField(
                    label: 'End Date',
                    date: flexibleEndDate,
                    onDateChanged: onFlexibleEndDateChanged,
                  ),
                ),
              ],
            );
    }
    return const SizedBox.shrink();
  }
}

class _FinancialYearField extends StatelessWidget {
  final String label;
  final String month;
  final TextEditingController year;
  final ValueChanged<String> onMonthChanged;
  final ValueChanged<String> onYearChanged;

  const _FinancialYearField({
    required this.label,
    required this.month,
    required this.year,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: month,
                    isExpanded: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                    items:
                        const [
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
                            ]
                            .map(
                              (m) => DropdownMenuItem(value: m, child: Text(m)),
                            )
                            .toList(),
                    onChanged: (v) => onMonthChanged(v ?? month),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: year,
                onChanged: onYearChanged,
                style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FlexibleDateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final ValueChanged<DateTime?> onDateChanged;

  const _FlexibleDateField({
    required this.label,
    required this.date,
    required this.onDateChanged,
  });

  String _formatDate(DateTime date) {
    final months = [
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
    return '${months[date.month - 1]}-${date.day.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final result = await showDatePicker(
              context: context,
              firstDate: DateTime(2018),
              lastDate: DateTime(2100),
              initialDate: date ?? DateTime.now(),
            );
            if (result != null) {
              onDateChanged(result);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null ? _formatDate(date!) : 'Select Date',
                    style: TextStyle(
                      fontSize: 14,
                      color: date != null
                          ? const Color(0xFF374151)
                          : Colors.grey,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  final bool isMobile;
  final TextEditingController transactionIdSearchController;
  final TextEditingController amountSearchController;
  final TextEditingController paymentMethodSearchController;
  final TextEditingController paymentStatusSearchController;
  final DateTime? paymentDate;
  final ValueChanged<DateTime?> onPaymentDateChanged;

  const _FilterBar({
    required this.isMobile,
    required this.transactionIdSearchController,
    required this.amountSearchController,
    required this.paymentMethodSearchController,
    required this.paymentStatusSearchController,
    required this.paymentDate,
    required this.onPaymentDateChanged,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Widget _buildSearchFilter({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Icon(
                      Icons.search,
                      size: 16,
                      color: Color(0xFF009A69),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(
                Icons.filter_list,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () {
                // Show filter dialog for this column
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateFilter({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null ? _formatDate(date) : '02-28-2025',
                    style: TextStyle(
                      fontSize: 12,
                      color: date != null ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterContent = Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF009A69), Color(0xFF232534)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(
            width: isMobile ? 180 : 200,
            child: _buildSearchFilter(
              label: 'Transaction ID',
              controller: transactionIdSearchController,
            ),
          ),
          SizedBox(width: isMobile ? 16 : 24),
          SizedBox(
            width: isMobile ? 180 : 200,
            child: _buildSearchFilter(
              label: 'Amount',
              controller: amountSearchController,
            ),
          ),
          SizedBox(width: isMobile ? 16 : 24),
          SizedBox(
            width: isMobile ? 180 : 200,
            child: _buildSearchFilter(
              label: 'Payment Method',
              controller: paymentMethodSearchController,
            ),
          ),
          SizedBox(width: isMobile ? 16 : 24),
          SizedBox(
            width: isMobile ? 180 : 200,
            child: _buildSearchFilter(
              label: 'Payment Status',
              controller: paymentStatusSearchController,
            ),
          ),
          SizedBox(width: isMobile ? 16 : 24),
          SizedBox(
            width: isMobile ? 180 : 200,
            child: _buildDateFilter(
              label: 'Payment Date',
              date: paymentDate,
              onTap: () async {
                final result = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2018),
                  lastDate: DateTime(2100),
                  initialDate: paymentDate ?? DateTime.now(),
                );
                if (result != null) {
                  onPaymentDateChanged(result);
                }
              },
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: filterContent,
      );
    }

    return filterContent;
  }
}

class _TransactionsTable extends StatelessWidget {
  final bool isMobile;
  final List<Map<String, dynamic>> transactions;
  final int showEntries;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final TextEditingController transactionIdSearchController;
  final TextEditingController amountSearchController;
  final TextEditingController paymentMethodSearchController;
  final TextEditingController paymentStatusSearchController;
  final DateTime? paymentDate;
  final ValueChanged<DateTime?> onPaymentDateChanged;
  final Function(Map<String, dynamic>) onShowInvoice;
  final Function(Map<String, dynamic>) onDownloadReceipt;

  const _TransactionsTable({
    required this.isMobile,
    required this.transactions,
    required this.showEntries,
    required this.currentPage,
    required this.onPageChanged,
    required this.transactionIdSearchController,
    required this.amountSearchController,
    required this.paymentMethodSearchController,
    required this.paymentStatusSearchController,
    required this.paymentDate,
    required this.onPaymentDateChanged,
    required this.onShowInvoice,
    required this.onDownloadReceipt,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Color _getPaymentMethodColor(String method) {
    switch (method) {
      case 'Bank Transfer':
        return const Color(0xFF009A69);
      case 'Credit Card':
        return const Color(0xFF7C3AED);
      case 'UPI':
        return const Color(0xFF059669);
      case 'Net Banking':
        return const Color(0xFFDC2626);
      case 'PayPal':
        return const Color(0xFF232534);
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

  @override
  Widget build(BuildContext context) {
    final startIndex = currentPage * showEntries;
    final endIndex = (startIndex + showEntries).clamp(0, transactions.length);
    final paginatedTransactions = transactions.sublist(startIndex, endIndex);
    final totalPages = (transactions.length / showEntries).ceil();

    if (isMobile) {
      return Column(
        children: [
          Container(
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
            child: Column(
              children: [
                ...paginatedTransactions.map((transaction) {
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
                                color: Color(0xFF009A69),
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
                                  color: _getStatusColor(transaction['status']),
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
                            Expanded(
                              child: Text(
                                '${_formatDate(transaction['startDate'])} → ${_formatDate(transaction['endDate'])}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF374151),
                                  fontWeight: FontWeight.w500,
                                ),
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
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () => onShowInvoice(transaction),
                                icon: const Icon(Icons.receipt, size: 16),
                                label: const Text('Invoice'),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF009A69),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () => onDownloadReceipt(transaction),
                                icon: const Icon(Icons.download, size: 16),
                                label: const Text('Receipt'),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF059669),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
                if (totalPages > 1)
                  _PaginationControls(
                    currentPage: currentPage,
                    totalPages: totalPages,
                    onPageChanged: onPageChanged,
                    totalEntries: transactions.length,
                    showEntries: showEntries,
                    startIndex: startIndex + 1,
                    endIndex: endIndex,
                  ),
              ],
            ),
          ),
        ],
      );
    }

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
      child: Column(
        children: [
          _TableHeader(
            isMobile: isMobile,
            transactionIdSearchController: transactionIdSearchController,
            amountSearchController: amountSearchController,
            paymentMethodSearchController: paymentMethodSearchController,
            paymentStatusSearchController: paymentStatusSearchController,
            paymentDate: paymentDate,
            onPaymentDateChanged: onPaymentDateChanged,
          ),
          const SizedBox(height: 8),
          _TableBody(
            isMobile: isMobile,
            transactions: paginatedTransactions,
            onShowInvoice: onShowInvoice,
            onDownloadReceipt: onDownloadReceipt,
            formatDate: _formatDate,
            getPaymentMethodColor: _getPaymentMethodColor,
            getStatusColor: _getStatusColor,
          ),
          if (totalPages > 1)
            _PaginationControls(
              currentPage: currentPage,
              totalPages: totalPages,
              onPageChanged: onPageChanged,
              totalEntries: transactions.length,
              showEntries: showEntries,
              startIndex: startIndex + 1,
              endIndex: endIndex,
            ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final bool isMobile;
  final TextEditingController transactionIdSearchController;
  final TextEditingController amountSearchController;
  final TextEditingController paymentMethodSearchController;
  final TextEditingController paymentStatusSearchController;
  final DateTime? paymentDate;
  final ValueChanged<DateTime?> onPaymentDateChanged;

  const _TableHeader({
    required this.isMobile,
    required this.transactionIdSearchController,
    required this.amountSearchController,
    required this.paymentMethodSearchController,
    required this.paymentStatusSearchController,
    required this.paymentDate,
    required this.onPaymentDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final headerContent = Container(
      decoration: BoxDecoration(
        color: const Color(0xFF009A69),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(
            width: isMobile ? 180 : 200,
            child: _ColumnHeaderWithSearch(
              label: 'Transaction ID',
              searchController: transactionIdSearchController,
            ),
          ),
          SizedBox(
            width: isMobile ? 180 : 200,
            child: _ColumnHeaderWithSearch(
              label: 'Amount',
              searchController: amountSearchController,
            ),
          ),
          SizedBox(
            width: isMobile ? 180 : 200,
            child: _ColumnHeaderWithSearch(
              label: 'Payment Method',
              searchController: paymentMethodSearchController,
            ),
          ),
          SizedBox(
            width: isMobile ? 180 : 200,
            child: _ColumnHeaderWithSearch(
              label: 'Payment Status',
              searchController: paymentStatusSearchController,
            ),
          ),
          SizedBox(
            width: isMobile ? 180 : 200,
            child: _ColumnHeaderWithDate(
              label: 'Payment Date',
              date: paymentDate,
              onDateChanged: onPaymentDateChanged,
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: headerContent,
      );
    }

    return headerContent;
  }
}

class _ColumnHeaderWithSearch extends StatelessWidget {
  final String label;
  final TextEditingController searchController;

  const _ColumnHeaderWithSearch({
    required this.label,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Icon(Icons.search, size: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(
                Icons.filter_list,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () {
                // Show filter dialog for this column
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Filter $label'),
                    content: const Text('Filter options for this column'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }
}

class _ColumnHeaderWithDate extends StatelessWidget {
  final String label;
  final DateTime? date;
  final ValueChanged<DateTime?> onDateChanged;

  const _ColumnHeaderWithDate({
    required this.label,
    required this.date,
    required this.onDateChanged,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final result = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2100),
                    initialDate: date ?? DateTime.now(),
                  );
                  if (result != null) {
                    onDateChanged(result);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          date != null ? _formatDate(date!) : 'Select Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: date != null ? Colors.black87 : Colors.grey,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(
                Icons.filter_list,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () {
                // Show filter dialog for this column
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Filter $label'),
                    content: const Text('Filter options for this column'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }
}

class _TableBody extends StatelessWidget {
  final bool isMobile;
  final List<Map<String, dynamic>> transactions;
  final Function(Map<String, dynamic>) onShowInvoice;
  final Function(Map<String, dynamic>) onDownloadReceipt;
  final String Function(DateTime) formatDate;
  final Color Function(String) getPaymentMethodColor;
  final Color Function(String) getStatusColor;

  const _TableBody({
    required this.isMobile,
    required this.transactions,
    required this.onShowInvoice,
    required this.onDownloadReceipt,
    required this.formatDate,
    required this.getPaymentMethodColor,
    required this.getStatusColor,
  });

  @override
  Widget build(BuildContext context) {
    final tableContent = Column(
      children: transactions.asMap().entries.map((entry) {
        final i = entry.key;
        final transaction = entry.value;
        final odd = i % 2 == 1;

        return Container(
          color: odd ? const Color(0xFFF9FAFB) : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              SizedBox(
                width: isMobile ? 180 : 200,
                child: Text(
                  transaction['id'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF009A69),
                  ),
                ),
              ),
              SizedBox(
                width: isMobile ? 180 : 200,
                child: Text(
                  transaction['amount'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
              SizedBox(
                width: isMobile ? 180 : 200,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getPaymentMethodColor(
                      transaction['paymentMethod'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    transaction['paymentMethod'],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: getPaymentMethodColor(
                        transaction['paymentMethod'],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: isMobile ? 180 : 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(
                          transaction['status'],
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        transaction['status'],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: getStatusColor(transaction['status']),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => onShowInvoice(transaction),
                          child: const Text(
                            'Invoice',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF009A69),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Text(
                          ' | ',
                          style: TextStyle(color: Color(0xFF009A69)),
                        ),
                        InkWell(
                          onTap: () => onDownloadReceipt(transaction),
                          child: const Text(
                            'Receipt',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF009A69),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: isMobile ? 180 : 200,
                child: Text(
                  formatDate(transaction['paymentDate']),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: tableContent,
      );
    }

    return tableContent;
  }
}

class _PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final int totalEntries;
  final int showEntries;
  final int startIndex;
  final int endIndex;

  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    required this.totalEntries,
    required this.showEntries,
    required this.startIndex,
    required this.endIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $startIndex To $endIndex Of $totalEntries Entries',
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          Row(
            children: [
              TextButton(
                onPressed: currentPage > 0
                    ? () => onPageChanged(currentPage - 1)
                    : null,
                child: const Text('Previous'),
              ),
              ...List.generate(
                totalPages,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => onPageChanged(index),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? const Color(0xFF009A69)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: currentPage == index
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: currentPage < totalPages - 1
                    ? () => onPageChanged(currentPage + 1)
                    : null,
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
