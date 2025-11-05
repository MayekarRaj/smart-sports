import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/coach/widgets/coach_phone_filters.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';

class CoachTransactionsPage extends StatefulWidget {
  const CoachTransactionsPage({super.key});

  @override
  State<CoachTransactionsPage> createState() => _CoachTransactionsPageState();
}

class MediaUtils {
  final BuildContext context;
  MediaUtils(this.context);
  bool get isWide => MediaQuery.of(context).size.width >= 1000;
}

class _CoachTransactionsPageState extends State<CoachTransactionsPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tableTabs;
  final ScrollController _scrollController = ScrollController();
  final PageStorageKey<String> _storageKey = const PageStorageKey<String>(
    'coach_transactions_scroll',
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

  @override
  void initState() {
    super.initState();
    _tableTabs = TabController(length: 6, vsync: this);
    _tableTabs.addListener(_onTabChanged);
    _initializeData();
    _searchController.addListener(_onSearchChanged);
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

      // Status filter
      if (_status != 'Select' && transaction['status'] != _status) {
        return false;
      }

      // Date range filter
      if (_fromDate != null && transaction['date'].isBefore(_fromDate!)) {
        return false;
      }
      if (_toDate != null && transaction['date'].isAfter(_toDate!)) {
        return false;
      }

      // Period filter
      if (_period == 'Financial Year') {
        // Filter for current financial year (April to March)
        final now = DateTime.now();
        final currentYear = now.month >= 4 ? now.year : now.year - 1;
        final financialYearStart = DateTime(currentYear, 4, 1);
        final financialYearEnd = DateTime(currentYear + 1, 3, 31);

        if (transaction['date'].isBefore(financialYearStart) ||
            transaction['date'].isAfter(financialYearEnd)) {
          return false;
        }
      } else if (_period == 'Flexible Duration') {
        // Show only last 30 days
        final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
        if (transaction['date'].isBefore(thirtyDaysAgo)) {
          return false;
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
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF232534), Color(0xFF2C3BC5)],
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
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.coach,
            selectedIndex: 1,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.coach,
              i,
            ),
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.coach,
            ),
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
                  CoachPhoneFilters(
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
                _TableTabs(controller: _tableTabs),
                const SizedBox(height: 12),
                _TransactionsTable(
                  isWide: isWide,
                  transactions: _filteredTransactions,
                  showEntries: _showEntries,
                  currentPage: _currentPage,
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

class _TransactionsTable extends StatelessWidget {
  final bool isWide;
  final List<Map<String, dynamic>> transactions;
  final int showEntries;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onEntriesChanged;
  final Function(Map<String, dynamic>) onShowInvoice;
  final Function(Map<String, dynamic>) onDownloadReceipt;

  const _TransactionsTable({
    required this.isWide,
    required this.transactions,
    required this.showEntries,
    required this.currentPage,
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

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 700;
    final columns = [
      DataColumn(
        label: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Text(
            'Transaction ID',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
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
              fontSize: 16,
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
              fontSize: 16,
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
              fontSize: 16,
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
              fontSize: 16,
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
              fontSize: 16,
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
              fontSize: 16,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ),
    ];

    final startIndex = currentPage * showEntries;
    final endIndex = (startIndex + showEntries).clamp(0, transactions.length);
    final paginatedTransactions = transactions.sublist(startIndex, endIndex);

    final rows = paginatedTransactions.asMap().entries.map((entry) {
      final i = entry.key;
      final transaction = entry.value;
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
                transaction['id'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _formatDate(transaction['date']),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF374151),
                ),
              ),
            ),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _formatDate(transaction['date'].add(const Duration(days: 365))),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF374151),
                ),
              ),
            ),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                transaction['amount'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
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
                      onShowInvoice(transaction);
                    },
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.download,
                    label: 'Receipt',
                    onTap: () {
                      onDownloadReceipt(transaction);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();

    final table = DataTable(
      columns: columns,
      rows: rows,
      headingRowColor: MaterialStateProperty.all(const Color(0xFFF3F4F6)),
      columnSpacing: 24,
      dataRowMinHeight: 64,
      dataRowMaxHeight: 64,
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
                              _ActionButton(
                                icon: Icons.receipt,
                                label: 'Invoice',
                                onTap: () {
                                  onShowInvoice(transaction);
                                },
                              ),
                              const SizedBox(width: 8),
                              _ActionButton(
                                icon: Icons.download,
                                label: 'Receipt',
                                onTap: () {
                                  onDownloadReceipt(transaction);
                                },
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
                        constraints: const BoxConstraints(minWidth: 1100),
                        child: SingleChildScrollView(child: table),
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
