import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/financial_summary_card.dart';
import 'widgets/date_filter_widget.dart';

class BankDetailsTab extends StatefulWidget {
  final Color roleColor;
  final bool isMobile;

  const BankDetailsTab({
    super.key,
    required this.roleColor,
    required this.isMobile,
  });

  @override
  State<BankDetailsTab> createState() => _BankDetailsTabState();
}

class _BankDetailsTabState extends State<BankDetailsTab> {
  // Bank Details Controllers
  final _accountNameController = TextEditingController(text: 'Bank Account Name');
  final _bankNameController = TextEditingController(text: 'Bank Name');
  final _branchNameController = TextEditingController(text: 'Bank Branch');
  final _accountNumberController = TextEditingController(text: 'XXXXXXXXX');
  final _swiftCodeController = TextEditingController(text: 'XXXXXXX');
  final _ifscCodeController = TextEditingController(text: 'XXXXXXX');
  final _stripeIdController = TextEditingController(text: 'XXXXXXX');
  final _stripeSecretKeyController = TextEditingController(text: 'XXXXXXX');
  final _paypalIdController = TextEditingController(text: 'artist1234@gmail.com');
  final _paypalUrlController = TextEditingController(text: 'XXXXXXX');
  final _zelleIdController = TextEditingController(text: 'XXXXXXX');

  String _accountType = 'SAVING';
  File? _bankPassbookImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isEditMode = false;

  // Revenue Earned Filters
  String _revenueFilter = 'Financial Year';
  String _revenueStartMonth = 'JAN';
  String _revenueStartYear = '2021';
  String _revenueEndMonth = 'DEC';
  String _revenueEndYear = '2021';

  // Subscription Expenses Filters
  String _expensesFilter = 'Financial Year';
  String _expensesStartMonth = 'JAN';
  String _expensesStartYear = '2021';
  String _expensesEndMonth = 'DEC';
  String _expensesEndYear = '2021';
  DateTime? _expensesFlexibleStartDate;
  DateTime? _expensesFlexibleEndDate;

  // Dummy Financial Data
  final double _totalRevenues = 50000.0;
  final double _paymentReleased = 30000.0;
  final double _paymentPending = 20000.0;
  final double _totalExpenses = 30000.0;
  final double _expensesReleased = 30000.0;
  final double _expensesPending = 0.0;

  @override
  void dispose() {
    _accountNameController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _accountNumberController.dispose();
    _swiftCodeController.dispose();
    _ifscCodeController.dispose();
    _stripeIdController.dispose();
    _stripeSecretKeyController.dispose();
    _paypalIdController.dispose();
    _paypalUrlController.dispose();
    _zelleIdController.dispose();
    super.dispose();
  }

  Future<void> _pickBankPassbookImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        final fileSizeInMB = await file.length() / (1024 * 1024);

        if (fileSizeInMB > 10) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File size must be less than 10 MB'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        setState(() {
          _bankPassbookImage = file;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Edit/Save Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isEditMode = !_isEditMode;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isEditMode ? 'Changes saved' : 'Edit mode enabled'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                icon: Icon(_isEditMode ? Icons.save : Icons.edit),
                label: Text(_isEditMode ? 'Save' : 'Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.roleColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Bank Details Section
          _buildBankDetailsSection(),
          const SizedBox(height: 32),
          // Financials Section
          _buildFinancialsSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBankDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.roleColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.account_balance,
                  color: widget.roleColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Bank Details & Financials',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: widget.roleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Bank Details Form
          widget.isMobile
              ? _buildMobileBankDetailsForm()
              : _buildDesktopBankDetailsForm(),
        ],
      ),
    );
  }

  Widget _buildMobileBankDetailsForm() {
    return Column(
      children: [
        _buildFormField('Account Name', _accountNameController),
        const SizedBox(height: 16),
        _buildFormField('Bank Name', _bankNameController),
        const SizedBox(height: 16),
        _buildFormField('Branch Name', _branchNameController),
        const SizedBox(height: 16),
        _buildAccountTypeDropdown(),
        const SizedBox(height: 16),
        _buildFormField('Account Number', _accountNumberController),
        const SizedBox(height: 16),
        _buildFormField('Swift Code', _swiftCodeController),
        const SizedBox(height: 16),
        _buildFormField('IFSC Code', _ifscCodeController),
        const SizedBox(height: 16),
        _buildFormField('Stripe ID', _stripeIdController),
        const SizedBox(height: 16),
        _buildFormField('Stripe Secret Key', _stripeSecretKeyController),
        const SizedBox(height: 16),
        _buildFormField('PayPal ID', _paypalIdController),
        const SizedBox(height: 16),
        _buildFormField('PayPal URL', _paypalUrlController),
        const SizedBox(height: 16),
        _buildFormField('Zelle ID', _zelleIdController),
        const SizedBox(height: 24),
        _buildBankPassbookSection(),
      ],
    );
  }

  Widget _buildDesktopBankDetailsForm() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Side - Form Fields
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildFormField('Account Name', _accountNameController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFormField('Bank Name', _bankNameController)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildFormField('Branch Name', _branchNameController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildAccountTypeDropdown()),
                ],
              ),
              const SizedBox(height: 16),
              _buildFormField('Account Number', _accountNumberController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildFormField('Swift Code', _swiftCodeController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFormField('IFSC Code', _ifscCodeController)),
                ],
              ),
              const SizedBox(height: 16),
              _buildFormField('Stripe ID', _stripeIdController),
              const SizedBox(height: 16),
              _buildFormField('Stripe Secret Key', _stripeSecretKeyController),
              const SizedBox(height: 16),
              _buildFormField('PayPal ID', _paypalIdController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildFormField('PayPal URL', _paypalUrlController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFormField('Zelle ID', _zelleIdController)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Right Side - Bank Passbook
        Expanded(
          flex: 1,
          child: _buildBankPassbookSection(),
        ),
      ],
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: _isEditMode,
          readOnly: !_isEditMode,
          style: TextStyle(
            fontSize: 15,
            color: _isEditMode ? Colors.black87 : Colors.grey.shade700,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: _isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.roleColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _isEditMode ? Colors.grey.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _accountType,
              isExpanded: true,
              style: TextStyle(
                fontSize: 15,
                color: _isEditMode ? Colors.black87 : Colors.grey.shade700,
              ),
              items: const ['SAVING', 'CURRENT'].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: _isEditMode
                  ? (value) {
                      if (value != null) {
                        setState(() {
                          _accountType = value;
                        });
                      }
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBankPassbookSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bank Passbook',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '(The File Size Must Be Less Than 10 MB Only)',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _isEditMode ? _pickBankPassbookImage : null,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            child: _bankPassbookImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _bankPassbookImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Click to Upload',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (_bankPassbookImage != null && _isEditMode) ...[
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _bankPassbookImage = null;
              });
            },
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Remove Image'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFinancialsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Financials Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              'Financials',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Revenue Earned Section
          _buildRevenueEarnedSection(),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 32),
          // Subscription Expenses Section
          _buildSubscriptionExpensesSection(),
        ],
      ),
    );
  }

  Widget _buildRevenueEarnedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'REVENUE EARNED',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        DateFilterWidget(
          selectedFilter: _revenueFilter,
          onFilterChanged: (filter) {
            setState(() {
              _revenueFilter = filter;
            });
          },
          startMonth: _revenueStartMonth,
          startYear: _revenueStartYear,
          endMonth: _revenueEndMonth,
          endYear: _revenueEndYear,
          onStartMonthChanged: (month) {
            setState(() {
              _revenueStartMonth = month;
            });
          },
          onStartYearChanged: (year) {
            setState(() {
              _revenueStartYear = year;
            });
          },
          onEndMonthChanged: (month) {
            setState(() {
              _revenueEndMonth = month;
            });
          },
          onEndYearChanged: (year) {
            setState(() {
              _revenueEndYear = year;
            });
          },
        ),
        const SizedBox(height: 24),
        // Summary Cards
        widget.isMobile
            ? Column(
                children: [
                  FinancialSummaryCard(
                    title: 'TOTAL REVENUES',
                    amount: 'USD ${_formatCurrency(_totalRevenues)}',
                    cardColor: const Color(0xFF3B82F6),
                    icon: Icons.account_balance_wallet,
                    isExpanded: false,
                  ),
                  const SizedBox(height: 16),
                  FinancialSummaryCard(
                    title: 'PAYMENT RELEASED BY SEKAI-ICHI',
                    amount: 'USD ${_formatCurrency(_paymentReleased)}',
                    cardColor: const Color(0xFF10B981),
                    icon: Icons.check_circle,
                    isExpanded: false,
                  ),
                  const SizedBox(height: 16),
                  FinancialSummaryCard(
                    title: 'PAYMENT PENDING',
                    amount: 'USD ${_formatCurrency(_paymentPending)}',
                    cardColor: const Color(0xFFEF4444),
                    icon: Icons.pending,
                    isExpanded: false,
                  ),
                ],
              )
            : Row(
                children: [
                  FinancialSummaryCard(
                    title: 'TOTAL REVENUES',
                    amount: 'USD ${_formatCurrency(_totalRevenues)}',
                    cardColor: const Color(0xFF3B82F6),
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(width: 16),
                  FinancialSummaryCard(
                    title: 'PAYMENT RELEASED BY SEKAI-ICHI',
                    amount: 'USD ${_formatCurrency(_paymentReleased)}',
                    cardColor: const Color(0xFF10B981),
                    icon: Icons.check_circle,
                  ),
                  const SizedBox(width: 16),
                  FinancialSummaryCard(
                    title: 'PAYMENT PENDING',
                    amount: 'USD ${_formatCurrency(_paymentPending)}',
                    cardColor: const Color(0xFFEF4444),
                    icon: Icons.pending,
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildSubscriptionExpensesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUBSCRIPTION EXPENSES',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        DateFilterWidget(
          selectedFilter: _expensesFilter,
          onFilterChanged: (filter) {
            setState(() {
              _expensesFilter = filter;
            });
          },
          startMonth: _expensesStartMonth,
          startYear: _expensesStartYear,
          endMonth: _expensesEndMonth,
          endYear: _expensesEndYear,
          onStartMonthChanged: (month) {
            setState(() {
              _expensesStartMonth = month;
            });
          },
          onStartYearChanged: (year) {
            setState(() {
              _expensesStartYear = year;
            });
          },
          onEndMonthChanged: (month) {
            setState(() {
              _expensesEndMonth = month;
            });
          },
          onEndYearChanged: (year) {
            setState(() {
              _expensesEndYear = year;
            });
          },
          showFlexibleDuration: true,
          flexibleStartDate: _expensesFlexibleStartDate,
          flexibleEndDate: _expensesFlexibleEndDate,
          onFlexibleStartDateChanged: (date) {
            setState(() {
              _expensesFlexibleStartDate = date;
            });
          },
          onFlexibleEndDateChanged: (date) {
            setState(() {
              _expensesFlexibleEndDate = date;
            });
          },
        ),
        const SizedBox(height: 24),
        // Summary Cards
        widget.isMobile
            ? Column(
                children: [
                  FinancialSummaryCard(
                    title: 'TOTAL EXPENSES',
                    amount: 'USD ${_formatCurrency(_totalExpenses)}',
                    cardColor: const Color(0xFF3B82F6),
                    icon: Icons.account_balance_wallet,
                    isExpanded: false,
                  ),
                  const SizedBox(height: 16),
                  FinancialSummaryCard(
                    title: 'PAYMENT RELEASED TO SEKAI-ICHI',
                    amount: 'USD ${_formatCurrency(_expensesReleased)}',
                    cardColor: const Color(0xFF10B981),
                    icon: Icons.check_circle,
                    isExpanded: false,
                  ),
                  const SizedBox(height: 16),
                  FinancialSummaryCard(
                    title: 'PAYMENT PENDING',
                    amount: 'USD ${_formatCurrency(_expensesPending)}',
                    cardColor: const Color(0xFFEF4444),
                    icon: Icons.pending,
                    isExpanded: false,
                  ),
                ],
              )
            : Row(
                children: [
                  FinancialSummaryCard(
                    title: 'TOTAL EXPENSES',
                    amount: 'USD ${_formatCurrency(_totalExpenses)}',
                    cardColor: const Color(0xFF3B82F6),
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(width: 16),
                  FinancialSummaryCard(
                    title: 'PAYMENT RELEASED TO SEKAI-ICHI',
                    amount: 'USD ${_formatCurrency(_expensesReleased)}',
                    cardColor: const Color(0xFF10B981),
                    icon: Icons.check_circle,
                  ),
                  const SizedBox(width: 16),
                  FinancialSummaryCard(
                    title: 'PAYMENT PENDING',
                    amount: 'USD ${_formatCurrency(_expensesPending)}',
                    cardColor: const Color(0xFFEF4444),
                    icon: Icons.pending,
                  ),
                ],
              ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

