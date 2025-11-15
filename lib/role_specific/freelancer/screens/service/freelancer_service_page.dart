import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/role_specific/freelancer/screens/service/add_service_screen.dart';

class FreelancerServicePage extends StatefulWidget {
  const FreelancerServicePage({super.key});

  @override
  State<FreelancerServicePage> createState() => _FreelancerServicePageState();
}

class _FreelancerServicePageState extends State<FreelancerServicePage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _sportSearchController = TextEditingController();
  final TextEditingController _serviceNameSearchController =
      TextEditingController();
  final TextEditingController _costSearchController = TextEditingController();
  final TextEditingController _daysSearchController = TextEditingController();

  String? _courierDeliveryFilter;

  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController.addListener(_applyFilters);
    _sportSearchController.addListener(_applyFilters);
    _serviceNameSearchController.addListener(_applyFilters);
    _costSearchController.addListener(_applyFilters);
    _daysSearchController.addListener(_applyFilters);
  }

  void _initializeData() {
    _services = [
      {
        'id': '1',
        'sport': 'Football',
        'serviceName': 'Repair Football',
        'serviceImage': 'assets/images/football.jpg', // Placeholder
        'cost': 'USD 50',
        'daysToDeliver': '6 Days',
        'courierDelivery': true,
      },
      {
        'id': '2',
        'sport': 'Tennis',
        'serviceName': 'Repair Tennis',
        'serviceImage': 'assets/images/tennis.jpg', // Placeholder
        'cost': 'USD 250',
        'daysToDeliver': '6 Days',
        'courierDelivery': false,
      },
      {
        'id': '3',
        'sport': 'Badminton',
        'serviceName': 'Repair Racket',
        'serviceImage': 'assets/images/badminton.jpg', // Placeholder
        'cost': 'USD 250',
        'daysToDeliver': '6 Days',
        'courierDelivery': false,
      },
      {
        'id': '4',
        'sport': 'Basketball',
        'serviceName': 'Repair Basketball',
        'serviceImage': 'assets/images/basketball.jpg', // Placeholder
        'cost': 'USD 75',
        'daysToDeliver': '5 Days',
        'courierDelivery': true,
      },
      {
        'id': '5',
        'sport': 'Cricket',
        'serviceName': 'Repair Bat',
        'serviceImage': 'assets/images/cricket.jpg', // Placeholder
        'cost': 'USD 100',
        'daysToDeliver': '7 Days',
        'courierDelivery': true,
      },
    ];
    _filteredServices = List.from(_services);
  }

  void _applyFilters() {
    setState(() {
      _filteredServices = _services.where((service) {
        // Global search filter
        if (_searchController.text.isNotEmpty) {
          final searchLower = _searchController.text.toLowerCase();
          if (!service['sport'].toLowerCase().contains(searchLower) &&
              !service['serviceName'].toLowerCase().contains(searchLower) &&
              !service['cost'].toLowerCase().contains(searchLower)) {
            return false;
          }
        }

        // Column-specific filters
        if (_sportSearchController.text.isNotEmpty) {
          if (!service['sport']
              .toLowerCase()
              .contains(_sportSearchController.text.toLowerCase())) {
            return false;
          }
        }

        if (_serviceNameSearchController.text.isNotEmpty) {
          if (!service['serviceName']
              .toLowerCase()
              .contains(_serviceNameSearchController.text.toLowerCase())) {
            return false;
          }
        }

        if (_costSearchController.text.isNotEmpty) {
          if (!service['cost']
              .toLowerCase()
              .contains(_costSearchController.text.toLowerCase())) {
            return false;
          }
        }

        if (_daysSearchController.text.isNotEmpty) {
          if (!service['daysToDeliver']
              .toLowerCase()
              .contains(_daysSearchController.text.toLowerCase())) {
            return false;
          }
        }

        // Courier Delivery filter
        if (_courierDeliveryFilter != null) {
          final filterValue = _courierDeliveryFilter == 'Yes';
          if (service['courierDelivery'] != filterValue) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void _handleViewService(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('View Service - ${service['serviceName']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Sport:', service['sport']),
              _buildDetailRow('Service Name:', service['serviceName']),
              _buildDetailRow('Cost:', service['cost']),
              _buildDetailRow('Days To Deliver:', service['daysToDeliver']),
              _buildDetailRow(
                'Courier Delivery:',
                service['courierDelivery'] ? 'Yes' : 'No',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleEditService(Map<String, dynamic> service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit service: ${service['serviceName']}'),
        backgroundColor: Colors.orange,
      ),
    );
    // TODO: Navigate to edit service screen
  }

  void _handleDeleteService(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text(
          'Are you sure you want to delete "${service['serviceName']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _services.removeWhere((s) => s['id'] == service['id']);
                _applyFilters();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${service['serviceName']} deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleAddService() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddServiceScreen(),
      ),
    );

    if (result != null && mounted) {
      // Add the new service to the list
      setState(() {
        final newService = Map<String, dynamic>.from(result);
        newService['id'] = (_services.length + 1).toString();
        newService['serviceImage'] = 'assets/images/${newService['sport'].toString().toLowerCase()}.jpg';
        _services.add(newService);
        _applyFilters();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Service added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sportSearchController.dispose();
    _serviceNameSearchController.dispose();
    _costSearchController.dispose();
    _daysSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 768;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Service'),
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
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: _handleAddService,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Services'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF232534),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.freelancer,
            selectedIndex: 2,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.freelancer,
              i,
            ),
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.freelancer,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isMobile ? 12 : 16,
          16,
          isMobile ? 12 : 16,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Global Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black26),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Here',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Services Table
            _ServicesTable(
              isMobile: isMobile,
              services: _filteredServices,
              sportSearchController: _sportSearchController,
              serviceNameSearchController: _serviceNameSearchController,
              costSearchController: _costSearchController,
              daysSearchController: _daysSearchController,
              courierDeliveryFilter: _courierDeliveryFilter,
              onCourierDeliveryFilterChanged: (value) {
                setState(() {
                  _courierDeliveryFilter = value;
                  _applyFilters();
                });
              },
              onView: _handleViewService,
              onEdit: _handleEditService,
              onDelete: _handleDeleteService,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicesTable extends StatelessWidget {
  final bool isMobile;
  final List<Map<String, dynamic>> services;
  final TextEditingController sportSearchController;
  final TextEditingController serviceNameSearchController;
  final TextEditingController costSearchController;
  final TextEditingController daysSearchController;
  final String? courierDeliveryFilter;
  final ValueChanged<String?> onCourierDeliveryFilterChanged;
  final Function(Map<String, dynamic>) onView;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;

  const _ServicesTable({
    required this.isMobile,
    required this.services,
    required this.sportSearchController,
    required this.serviceNameSearchController,
    required this.costSearchController,
    required this.daysSearchController,
    required this.courierDeliveryFilter,
    required this.onCourierDeliveryFilterChanged,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
      child: isMobile ? _buildMobileView() : _buildDesktopView(),
    );
  }

  Widget _buildMobileView() {
    return Column(
      children: services.map((service) {
        return Container(
          margin: const EdgeInsets.all(12),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service['serviceName'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service['sport'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildActionButtons(service),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Service Image placeholder
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.image,
                      color: Colors.grey.shade400,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMobileRow('Cost:', service['cost']),
                        const SizedBox(height: 4),
                        _buildMobileRow('Days:', service['daysToDeliver']),
                        const SizedBox(height: 4),
                        _buildMobileRow(
                          'Courier:',
                          service['courierDelivery'] ? 'Yes' : 'No',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobileRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopView() {
    return Column(
      children: [
        _TableHeader(
          sportSearchController: sportSearchController,
          serviceNameSearchController: serviceNameSearchController,
          costSearchController: costSearchController,
          daysSearchController: daysSearchController,
          courierDeliveryFilter: courierDeliveryFilter,
          onCourierDeliveryFilterChanged: onCourierDeliveryFilterChanged,
        ),
        ...services.asMap().entries.map((entry) {
          final index = entry.key;
          final service = entry.value;
          final odd = index % 2 == 1;

          return Container(
            color: odd ? const Color(0xFFF9FAFB) : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: [
                // Action
                SizedBox(
                  width: 120,
                  child: _buildActionButtons(service),
                ),
                // Sport
                Expanded(
                  flex: 1,
                  child: Text(
                    service['sport'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Service Name
                Expanded(
                  flex: 2,
                  child: Text(
                    service['serviceName'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Service Image
                SizedBox(
                  width: 80,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.image,
                      color: Colors.grey.shade400,
                      size: 30,
                    ),
                  ),
                ),
                // Cost
                Expanded(
                  flex: 1,
                  child: Text(
                    service['cost'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF059669),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Days To Deliver
                Expanded(
                  flex: 1,
                  child: Text(
                    service['daysToDeliver'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Courier Delivery
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: service['courierDelivery']
                          ? const Color(0xFF059669).withValues(alpha: 0.1)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          service['courierDelivery']
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 18,
                          color: service['courierDelivery']
                              ? const Color(0xFF059669)
                              : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          service['courierDelivery'] ? 'Yes' : 'No',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: service['courierDelivery']
                                ? const Color(0xFF059669)
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> service) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => onView(service),
          icon: const Icon(Icons.visibility, size: 18, color: Colors.blue),
          tooltip: 'View',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () => onEdit(service),
          icon: const Icon(Icons.edit, size: 18, color: Colors.orange),
          tooltip: 'Edit',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () => onDelete(service),
          icon: const Icon(Icons.delete, size: 18, color: Colors.red),
          tooltip: 'Delete',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  final TextEditingController sportSearchController;
  final TextEditingController serviceNameSearchController;
  final TextEditingController costSearchController;
  final TextEditingController daysSearchController;
  final String? courierDeliveryFilter;
  final ValueChanged<String?> onCourierDeliveryFilterChanged;

  const _TableHeader({
    required this.sportSearchController,
    required this.serviceNameSearchController,
    required this.costSearchController,
    required this.daysSearchController,
    required this.courierDeliveryFilter,
    required this.onCourierDeliveryFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF232534),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Action
          SizedBox(
            width: 120,
            child: const Text(
              'Action',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          // Sport
          Expanded(
            flex: 1,
            child: _ColumnHeaderWithSearch(
              label: 'Sport',
              searchController: sportSearchController,
            ),
          ),
          // Service Name
          Expanded(
            flex: 2,
            child: _ColumnHeaderWithSearch(
              label: 'Service Name',
              searchController: serviceNameSearchController,
            ),
          ),
          // Service Image
          SizedBox(
            width: 80,
            child: const Text(
              'Service Image',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          // Cost
          Expanded(
            flex: 1,
            child: _ColumnHeaderWithSearch(
              label: 'Cost',
              searchController: costSearchController,
            ),
          ),
          // Days To Deliver
          Expanded(
            flex: 1,
            child: _ColumnHeaderWithSearch(
              label: 'Days To Deliver',
              searchController: daysSearchController,
            ),
          ),
          // Courier Delivery
          Expanded(
            flex: 1,
            child: _ColumnHeaderWithDropdown(
              label: 'Courier Delivery',
              value: courierDeliveryFilter,
              onChanged: onCourierDeliveryFilterChanged,
            ),
          ),
        ],
      ),
    );
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
              icon: const Icon(Icons.filter_list, size: 18, color: Colors.white),
              onPressed: () {
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

class _ColumnHeaderWithDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;

  const _ColumnHeaderWithDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: const Text('All', style: TextStyle(fontSize: 12)),
              isDense: true,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: null, child: Text('All')),
                DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                DropdownMenuItem(value: 'No', child: Text('No')),
              ],
              onChanged: onChanged,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
