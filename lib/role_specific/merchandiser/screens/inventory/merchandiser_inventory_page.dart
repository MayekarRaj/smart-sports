import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'add_inventory_screen.dart';
import 'view_inventory_screen.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';

class MerchandiserInventoryPage extends StatefulWidget {
  const MerchandiserInventoryPage({super.key});

  @override
  State<MerchandiserInventoryPage> createState() =>
      _MerchandiserInventoryPageState();
}

class _MerchandiserInventoryPageState extends State<MerchandiserInventoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _globalSearchController = TextEditingController();
  final TextEditingController _entriesController = TextEditingController(
    text: '10',
  );

  // Search controllers for each column
  final TextEditingController _sportSearchController = TextEditingController();
  final TextEditingController _productNameSearchController =
      TextEditingController();
  final TextEditingController _costSearchController = TextEditingController();
  final TextEditingController _daysSearchController = TextEditingController();

  String _selectedCourierDelivery = 'Yes';
  int _currentPage = 1;
  int _itemsPerPage = 10;

  // Sample inventory data
  final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'sport': 'Football',
      'productName': 'Football',
      'productImage': 'assets/images/football.jpg',
      'cost': 'USD 50',
      'daysToDeliver': '6 Days',
      'courierDelivery': true,
    },
    {
      'id': 2,
      'sport': 'Football',
      'productName': 'Football Kit',
      'productImage': 'assets/images/football_kit.jpg',
      'cost': 'USD 250',
      'daysToDeliver': '6 Days',
      'courierDelivery': false,
    },
    {
      'id': 3,
      'sport': 'Tennis',
      'productName': 'Tennis Kit',
      'productImage': 'assets/images/tennis_kit.jpg',
      'cost': 'USD 250',
      'daysToDeliver': '6 Days',
      'courierDelivery': false,
    },
    {
      'id': 4,
      'sport': 'Basketball',
      'productName': 'Basketball',
      'productImage': 'assets/images/basketball.jpg',
      'cost': 'USD 75',
      'daysToDeliver': '4 Days',
      'courierDelivery': true,
    },
    {
      'id': 5,
      'sport': 'Cricket',
      'productName': 'Cricket Bat',
      'productImage': 'assets/images/cricket_bat.jpg',
      'cost': 'USD 120',
      'daysToDeliver': '5 Days',
      'courierDelivery': true,
    },
  ];

  final List<Map<String, dynamic>> _services = [
    {
      'id': 1,
      'serviceName': 'Equipment Maintenance',
      'category': 'Maintenance',
      'cost': 'USD 100',
      'duration': '2 Hours',
      'availability': true,
    },
    {
      'id': 2,
      'serviceName': 'Court Setup',
      'category': 'Setup',
      'cost': 'USD 50',
      'duration': '1 Hour',
      'availability': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _globalSearchController.dispose();
    _entriesController.dispose();
    _sportSearchController.dispose();
    _productNameSearchController.dispose();
    _costSearchController.dispose();
    _daysSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Inventory Management',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF009A69),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Open Menu',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _handleAddItem,
            tooltip: 'Add Item',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _handleMoreOptions,
            tooltip: 'More Options',
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.merchandiser,
            selectedIndex: 2, // Inventory is at index 2
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.merchandiser,
              i,
            ),
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.merchandiser,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pagination and Search Section
            _buildTopSection(),
            const SizedBox(height: 16),

            // Main Content Card
            _buildMainContentCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - stack vertically
          return Column(
            children: [
              _buildPaginationControl(),
              const SizedBox(height: 12),
              _buildGlobalSearch(),
            ],
          );
        } else {
          // Tablet/Desktop layout - side by side
          return Row(
            children: [
              _buildPaginationControl(),
              const SizedBox(width: 16),
              Expanded(child: _buildGlobalSearch()),
            ],
          );
        }
      },
    );
  }

  Widget _buildPaginationControl() {
    return Row(
      children: [
        Text(
          'Show',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 60,
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF009A69), width: 1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextFormField(
            controller: _entriesController,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            onChanged: (value) {
              setState(() {
                _itemsPerPage = int.tryParse(value) ?? 10;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Entries',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalSearch() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _globalSearchController,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search Here',
          hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        onChanged: (value) {
          setState(() {
            // Trigger search
          });
        },
      ),
    );
  }

  Widget _buildMainContentCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tab Bar
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF009A69),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Products'),
                Tab(text: 'Services'),
              ],
            ),
          ),

          // Tab Content
          SizedBox(
            height: 600, // Fixed height for the content area
            child: TabBarView(
              controller: _tabController,
              children: [_buildProductsTab(), _buildServicesTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Total width of all columns on desktop/tablet
        const double tableWidth = 80 + 100 + 150 + 120 + 100 + 120 + 140; // 810

        if (constraints.maxWidth < 600) {
          // Mobile: keep vertical scrolling and card-based layout
          return SingleChildScrollView(
            child: Column(
              children: [
                // Table Header
                _buildTableHeader(),

                // Table Content
                _buildProductsTable(),

                // Pagination
                _buildPagination(),
              ],
            ),
          );
        }

        // Desktop / Tablet: allow horizontal scroll so columns don't wrap or overflow.
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: math.max(constraints.maxWidth, tableWidth),
            child: SingleChildScrollView(
              // keep vertical scroll for rows inside the fixed-width table
              child: Column(
                children: [
                  // Table Header (will use the fixed widths for each column)
                  _buildTableHeader(),

                  // Table Content
                  _buildProductsTable(),

                  // Pagination
                  _buildPagination(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF009A69),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout - simplified header
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'PRODUCTS',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _handleAddProduct,
                    icon: const Icon(Icons.add, color: Colors.white),
                    tooltip: 'Add Product',
                  ),
                ],
              ),
            );
          } else {
            // Desktop layout - full table header
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  _buildHeaderColumn('Action', 80),
                  _buildHeaderColumnWithSearch(
                    'Sport',
                    100,
                    _sportSearchController,
                  ),
                  _buildHeaderColumnWithSearch(
                    'Product Name',
                    150,
                    _productNameSearchController,
                  ),
                  _buildHeaderColumn('Product Image', 120),
                  _buildHeaderColumnWithSearch(
                    'Cost',
                    100,
                    _costSearchController,
                  ),
                  _buildHeaderColumnWithSearch(
                    'Days To Deliver',
                    120,
                    _daysSearchController,
                  ),
                  _buildHeaderColumnWithDropdown('Courier Delivery', 140),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeaderColumn(String title, double width) {
    return SizedBox(
      width: width,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHeaderColumnWithSearch(
    String title,
    double width,
    TextEditingController controller,
  ) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    controller: controller,
                    style: GoogleFonts.poppins(fontSize: 10),
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.filter_list, color: Colors.white, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderColumnWithDropdown(String title, double width) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedCourierDelivery,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
              ),
              style: GoogleFonts.poppins(fontSize: 10),
              items: ['Yes', 'No'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCourierDelivery = value ?? 'Yes';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - card-based
          return Column(
            children: _products
                .map((product) => _buildMobileProductCard(product))
                .toList(),
          );
        } else {
          // Desktop layout - table
          return Column(
            children: _products
                .map((product) => _buildDesktopProductRow(product))
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildMobileProductCard(Map<String, dynamic> product) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions
          Row(
            children: [
              Expanded(
                child: Text(
                  product['productName'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              _buildActionButtons(product),
            ],
          ),
          const SizedBox(height: 8),

          // Product details
          Row(
            children: [
              // Product image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    product['productImage'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image,
                        color: Colors.grey[400],
                        size: 30,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMobileDetailRow('Sport', product['sport']),
                    _buildMobileDetailRow('Cost', product['cost']),
                    _buildMobileDetailRow('Delivery', product['daysToDeliver']),
                    _buildMobileDetailRow(
                      'Courier',
                      product['courierDelivery'] ? 'Yes' : 'No',
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

  Widget _buildMobileDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopProductRow(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            _buildActionButtons(product),
            const SizedBox(width: 8),
            _buildCell(product['sport'], 100),
            _buildCell(product['productName'], 150),
            _buildImageCell(product['productImage']),
            _buildCell(product['cost'], 100),
            _buildCell(product['daysToDeliver'], 120),
            _buildCheckboxCell(product['courierDelivery']),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildImageCell(String imagePath) {
    return SizedBox(
      width: 120,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image, color: Colors.grey[400], size: 20);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxCell(bool value) {
    return SizedBox(
      width: 140,
      child: Checkbox(
        value: value,
        onChanged: (newValue) {
          setState(() {
            // Update the value
          });
        },
        activeColor: const Color(0xFF009A69),
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> product) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _handleViewProduct(product),
          icon: const Icon(Icons.visibility, size: 18, color: Colors.blue),
          tooltip: 'View',
        ),
        IconButton(
          onPressed: () => _handleEditProduct(product),
          icon: const Icon(Icons.edit, size: 18, color: Colors.orange),
          tooltip: 'Edit',
        ),
        IconButton(
          onPressed: () => _handleDeleteProduct(product),
          icon: const Icon(Icons.delete, size: 18, color: Colors.red),
          tooltip: 'Delete',
        ),
      ],
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${_currentPage} to ${_itemsPerPage} of ${_products.length} entries',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _currentPage > 1 ? _previousPage : null,
                icon: const Icon(Icons.chevron_left),
                color: _currentPage > 1 ? const Color(0xFF009A69) : Colors.grey,
              ),
              Text(
                '$_currentPage',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF009A69),
                ),
              ),
              IconButton(
                onPressed:
                    _currentPage < (_products.length / _itemsPerPage).ceil()
                    ? _nextPage
                    : null,
                icon: const Icon(Icons.chevron_right),
                color: _currentPage < (_products.length / _itemsPerPage).ceil()
                    ? const Color(0xFF009A69)
                    : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Services Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Color(0xFF009A69)),
            child: Row(
              children: [
                Text(
                  'SERVICES',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _handleAddService,
                  icon: const Icon(Icons.add, color: Colors.white),
                  tooltip: 'Add Service',
                ),
              ],
            ),
          ),

          // Services List
          ..._services.map((service) => _buildServiceCard(service)).toList(),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  service['serviceName'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              _buildActionButtons(service),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildServiceDetail('Category', service['category']),
              ),
              Expanded(child: _buildServiceDetail('Cost', service['cost'])),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _buildServiceDetail('Duration', service['duration']),
              ),
              Expanded(
                child: _buildServiceDetail(
                  'Available',
                  service['availability'] ? 'Yes' : 'No',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  // Action Methods
  void _handleAddItem() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddInventoryScreen()));

    if (result != null) {
      setState(() {
        _products.add({
          'id': result['id'],
          'sport': result['sport'],
          'productName': result['productName'],
          'productImage': 'assets/images/placeholder.jpg',
          'cost': '${result['currency']} ${result['totalCost']}',
          'daysToDeliver': '${result['daysToDeliver']} Days',
          'courierDelivery': result['courierDeliveryAccepted'],
          'inventoryData': result, // Store full inventory data for viewing
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Inventory added successfully!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: Text('Export Data', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Exporting data...',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: Text('Import Data', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Importing data...',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('Settings', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Opening settings...',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddProduct() {
    _handleAddItem();
  }

  void _handleAddService() {
    _handleAddItem();
  }

  void _handleViewProduct(Map<String, dynamic> product) async {
    // Open a full-screen view page with the product / inventory data
    final existing =
        product['inventoryData'] ??
        {
          'id': product['id'] ?? DateTime.now().millisecondsSinceEpoch,
          'type': 'Product',
          'sport': product['sport'] ?? 'Tennis',
          'productName': product['productName'] ?? 'Item',
          'kitProducts': product['kitProducts'] ?? [],
          'currency':
              (product['cost'] is String &&
                  (product['cost'] as String).contains(' '))
              ? (product['cost'] as String).split(' ').first
              : 'USD',
          'totalCost':
              (product['cost'] is String &&
                  (product['cost'] as String).contains(' '))
              ? (product['cost'] as String).split(' ').skip(1).join(' ')
              : (product['cost'] ?? ''),
          'daysToDeliver': (product['daysToDeliver'] is String)
              ? (product['daysToDeliver'] as String).split(' ').first
              : product['daysToDeliver'] ?? '0',
          'courierDeliveryAccepted': product['courierDelivery'] ?? false,
          'images': product['images'] ?? [],
          'createdAt': product['createdAt'] ?? DateTime.now().toIso8601String(),
        };

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => ViewInventoryScreen(inventory: existing),
      ),
    );

    // If the view screen returned an updated inventory (via its Edit action), apply it
    if (result != null) {
      setState(() {
        product['inventoryData'] = result;
        product['sport'] = result['sport'];
        product['productName'] = result['productName'];
        product['cost'] = '${result['currency']} ${result['totalCost']}';
        product['daysToDeliver'] = '${result['daysToDeliver']} Days';
        product['courierDelivery'] = result['courierDeliveryAccepted'];
        if (result['images'] != null) {
          product['images'] = List<String>.from(result['images']);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Inventory updated successfully!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleEditProduct(Map<String, dynamic> product) async {
    // Construct an editable inventory payload from the product if explicit
    // inventory data isn't present (so sample rows are editable too).
    final existing =
        product['inventoryData'] ??
        {
          'id': product['id'] ?? DateTime.now().millisecondsSinceEpoch,
          'type': 'Product',
          'sport': product['sport'] ?? 'Tennis',
          'productName': product['productName'] ?? 'Item',
          'kitProducts': product['kitProducts'] ?? [],
          // Parse cost into currency + totalCost when possible (e.g. "USD 50")
          'currency':
              (product['cost'] is String &&
                  (product['cost'] as String).contains(' '))
              ? (product['cost'] as String).split(' ').first
              : 'USD',
          'totalCost':
              (product['cost'] is String &&
                  (product['cost'] as String).contains(' '))
              ? (product['cost'] as String).split(' ').skip(1).join(' ')
              : (product['cost'] ?? ''),
          // Parse daysToDeliver like "6 Days" -> 6
          'daysToDeliver': (product['daysToDeliver'] is String)
              ? (product['daysToDeliver'] as String).split(' ').first
              : product['daysToDeliver'] ?? '0',
          'courierDeliveryAccepted': product['courierDelivery'] ?? false,
          'images': product['images'] ?? [],
          'createdAt': product['createdAt'] ?? DateTime.now().toIso8601String(),
        };

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AddInventoryScreen(existingInventory: existing, isEditMode: true),
      ),
    );

    if (result != null) {
      setState(() {
        product['inventoryData'] = result;
        product['sport'] = result['sport'];
        product['productName'] = result['productName'];
        product['cost'] = '${result['currency']} ${result['totalCost']}';
        product['daysToDeliver'] = '${result['daysToDeliver']} Days';
        product['courierDelivery'] = result['courierDeliveryAccepted'];
        // If the edit screen returned images, store them on the product too
        if (result['images'] != null) {
          product['images'] = List<String>.from(result['images']);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Inventory updated successfully!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleDeleteProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product', style: GoogleFonts.poppins()),
        content: Text(
          'Are you sure you want to delete ${product['productName']}?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _products.remove(product);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${product['productName']} deleted successfully!',
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Delete', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 1) {
        _currentPage--;
      }
    });
  }

  void _nextPage() {
    setState(() {
      if (_currentPage < (_products.length / _itemsPerPage).ceil()) {
        _currentPage++;
      }
    });
  }
}
