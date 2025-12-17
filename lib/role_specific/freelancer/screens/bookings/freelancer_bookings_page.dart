import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sports/bookings/models/booking_model.dart';
import 'package:smart_sports/bookings/services/booking_service.dart';
import 'package:smart_sports/bookings/widgets/filter_bar.dart';
import 'package:smart_sports/bookings/widgets/booking_card.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/bookings/screens/add_booking_screen.dart';
import 'package:smart_sports/bookings/screens/purchase_screen.dart';
import 'package:smart_sports/bookings/screens/repair_screen.dart';
import 'package:smart_sports/bookings/screens/view_booking_screen.dart';

class FreelancerBookingsPage extends StatefulWidget {
  const FreelancerBookingsPage({super.key});

  @override
  State<FreelancerBookingsPage> createState() => _FreelancerBookingsPageState();
}

class _FreelancerBookingsPageState extends State<FreelancerBookingsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  List<BookingModel> _bookings = [];
  List<BookingModel> _filteredBookings = [];
  bool _isLoading = true;
  int _selectedTabIndex = 0; // 0: Upcoming, 1: Archived
  bool _isInitialLoad = true;

  // Debounce timer for filter changes
  Timer? _filterDebounce;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _loadBookings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only refresh on first load, not on every return
    if (_isInitialLoad) {
      _isInitialLoad = false;
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _filterDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;

      final bookingService = BookingService();
      bookingService.initializeBookings();

      setState(() {
        _bookings = bookingService.bookings;
        // Preserve current filter state when refreshing
        if (_filteredBookings.isNotEmpty || _selectedTabIndex != 0) {
          // Re-apply filters to maintain state
          _performFiltering();
        } else {
          _filteredBookings = List.from(_bookings);
        }
        _isLoading = false;
      });

      if (mounted) {
        _fadeController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading bookings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshBookings() async {
    await _loadBookings();
  }

  void _filterBookings({
    String? eventName,
    DateTimeRange? dateRange,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? days,
    String? status,
  }) {
    // Cancel previous debounce timer
    _filterDebounce?.cancel();

    // Set new debounce timer
    _filterDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      _performFiltering(
        eventName: eventName,
        dateRange: dateRange,
        startTime: startTime,
        endTime: endTime,
        days: days,
        status: status,
      );
    });
  }

  void _performFiltering({
    String? eventName,
    DateTimeRange? dateRange,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? days,
    String? status,
  }) {
    setState(() {
      _filteredBookings = List.from(_bookings);

      // Filter by tab (Upcoming vs Archived)
      final now = DateTime.now();
      _filteredBookings = _filteredBookings.where((booking) {
        final bookingDateString = booking.schedule.date;

        // Parse the date string (format: "Thu, Apr 24, 2025")
        DateTime? bookingDate;
        try {
          final parts = bookingDateString.split(', ');

          if (parts.length >= 2) {
            final datePart = parts[1].trim();
            final dateParts = datePart.split(',');
            if (dateParts.length >= 2) {
              final monthDayParts = dateParts[0].trim().split(' ');
              final yearStr = dateParts[1].trim();

              if (monthDayParts.length >= 2) {
                final monthStr = monthDayParts[0];
                final dayStr = monthDayParts[1];

                final monthMap = {
                  'Jan': 1,
                  'Feb': 2,
                  'Mar': 3,
                  'Apr': 4,
                  'May': 5,
                  'Jun': 6,
                  'Jul': 7,
                  'Aug': 8,
                  'Sep': 9,
                  'Oct': 10,
                  'Nov': 11,
                  'Dec': 12,
                };

                final month = monthMap[monthStr] ?? 1;
                final day = int.tryParse(dayStr) ?? 1;
                final year = int.tryParse(yearStr) ?? 2025;

                bookingDate = DateTime(year, month, day);
              }
            }
          }
        } catch (e) {
          print('Error parsing date: $e');
          return false;
        }

        if (bookingDate == null) {
          return false;
        }

        final isUpcoming =
            bookingDate.isAfter(now) ||
            (bookingDate.day == now.day &&
                bookingDate.month == now.month &&
                bookingDate.year == now.year);

        final isArchived =
            bookingDate.isBefore(now) &&
            !(bookingDate.day == now.day &&
                bookingDate.month == now.month &&
                bookingDate.year == now.year);

        if (_selectedTabIndex == 0) {
          return isUpcoming;
        } else {
          return isArchived;
        }
      }).toList();

      // Apply event name filter
      if (eventName != null && eventName.isNotEmpty && eventName != 'Cricket') {
        _filteredBookings = _filteredBookings
            .where(
              (booking) => booking.sportType.toLowerCase().contains(
                eventName.toLowerCase(),
              ),
            )
            .toList();
      }

      // Apply date range filter
      if (dateRange != null) {
        _filteredBookings = _filteredBookings.where((booking) {
          final bookingDateString = booking.schedule.date;
          try {
            final parts = bookingDateString.split(', ');
            if (parts.length >= 2) {
              final datePart = parts[1].trim();
              final dateParts = datePart.split(',');
              if (dateParts.length >= 2) {
                final monthDayParts = dateParts[0].trim().split(' ');
                final yearStr = dateParts[1].trim();

                if (monthDayParts.length >= 2) {
                  final monthStr = monthDayParts[0];
                  final dayStr = monthDayParts[1];

                  final monthMap = {
                    'Jan': 1,
                    'Feb': 2,
                    'Mar': 3,
                    'Apr': 4,
                    'May': 5,
                    'Jun': 6,
                    'Jul': 7,
                    'Aug': 8,
                    'Sep': 9,
                    'Oct': 10,
                    'Nov': 11,
                    'Dec': 12,
                  };

                  final month = monthMap[monthStr] ?? 1;
                  final day = int.tryParse(dayStr) ?? 1;
                  final year = int.tryParse(yearStr) ?? 2025;

                  final bookingDate = DateTime(year, month, day);
                  return bookingDate.isAfter(
                        dateRange.start.subtract(const Duration(days: 1)),
                      ) &&
                      bookingDate.isBefore(
                        dateRange.end.add(const Duration(days: 1)),
                      );
                }
              }
            }
          } catch (e) {
            return false;
          }
          return false;
        }).toList();
      }

      // Apply status filter
      if (status != null && status != 'Select') {
        _filteredBookings = _filteredBookings.where((booking) {
          switch (status.toLowerCase()) {
            case 'waiting':
              return booking.status == BookingStatus.waiting;
            case 'confirmed':
              return booking.status == BookingStatus.confirmed;
            case 'cancelled':
              return booking.status == BookingStatus.cancelled;
            default:
              return true;
          }
        }).toList();
      }
    });
  }

  void _showCancelBookingDialog(BookingModel booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF2C3E50),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Cancel Booking',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure, You want to cancel the Court Booking ?',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Cancellations made 4 hours or more before the booking time are eligible for a full refund. No refund will be issued for cancellations made within 4 hours of the booking.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _cancelBooking(booking);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE74C3C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _cancelBooking(BookingModel booking) {
    setState(() {
      final index = _bookings.indexWhere((b) => b.id == booking.id);
      if (index != -1) {
        _bookings[index] = BookingModel(
          id: booking.id,
          venueName: booking.venueName,
          location: booking.location,
          rating: booking.rating,
          bookingId: booking.bookingId,
          status: BookingStatus.cancelled,
          coach: booking.coach,
          players: booking.players,
          schedule: booking.schedule,
          reservedBy: booking.reservedBy,
          sportType: booking.sportType,
          bookingAs: booking.bookingAs,
          coachRequestStatus: booking.coachRequestStatus,
          equipmentActions: booking.equipmentActions,
        );
        _filteredBookings = List.from(_bookings);
        _performFiltering();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booking cancelled successfully',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showPurchaseBottomSheet() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PurchaseScreen(
          selectedClub: 'Selected Club',
          selectedSport: 'Basketball',
          selectedArea: 'Los Angeles, CA',
          selectedDate: DateTime.now(),
          distanceRange: const RangeValues(0, 50),
          role: UserRole.freelancer,
        ),
      ),
    );
  }

  void _showRepairBottomSheet() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RepairScreen(
          selectedClub: 'Selected Club',
          selectedSport: 'Basketball',
          selectedArea: 'Los Angeles, CA',
          selectedDate: DateTime.now(),
          distanceRange: const RangeValues(0, 50),
          role: UserRole.freelancer,
        ),
      ),
    );
  }

  void _showCreateBookingDialog() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddBookingScreen(role: UserRole.freelancer),
      ),
    );
    // Refresh bookings after returning from add booking screen
    if (mounted) {
      _loadBookings();
    }
  }

  Widget _buildBookingTabs() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _buildTab('Upcoming Booking', 0)),
          const SizedBox(width: 8),
          Expanded(child: _buildTab('Archived Booking', 1)),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = _selectedTabIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
        _performFiltering();
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF007BFF)
              : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: isSelected
              ? null
              : Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 0.2,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Booking Management',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF007BFF), Color(0xFF0056CC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showCreateBookingDialog,
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Create New Booking',
          ),
          IconButton(
            onPressed: _refreshBookings,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh Bookings',
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.freelancer,
            selectedIndex: 4,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.freelancer,
              i,
            ),
            onProfileTap: () async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              RoleNavigationManager.navigateToProfile(
                context,
                UserRole.freelancer,
              );
            },
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBookings,
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: SafeArea(
                child: Column(
                  children: [
                    // Filter Bar
                    FilterBar(
                      onEventNameChanged: (eventName) {
                        _filterBookings(eventName: eventName);
                      },
                      onDateRangeChanged: (dateRange) {
                        _filterBookings(dateRange: dateRange);
                      },
                      onTimeRangeChanged: (startTime, endTime) {
                        _filterBookings(startTime: startTime, endTime: endTime);
                      },
                      onDaysChanged: (days) {
                        _filterBookings(days: days);
                      },
                      onStatusChanged: (status) {
                        _filterBookings(status: status);
                      },
                    ),

                    // Booking Tabs
                    Container(
                      constraints: const BoxConstraints(maxHeight: 50),
                      child: _buildBookingTabs(),
                    ),

                    // Bookings List
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF007BFF),
                                ),
                              ),
                            )
                          : _filteredBookings.isEmpty
                          ? Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.event_busy,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No bookings found',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Try adjusting your filters',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: _filteredBookings.length,
                              itemBuilder: (context, index) {
                                final booking = _filteredBookings[index];
                                return AnimatedContainer(
                                  duration: Duration(
                                    milliseconds: 300 + (index * 100),
                                  ),
                                  child: BookingCard(
                                    booking: booking,
                                    onCancelBooking: () {
                                      _showCancelBookingDialog(booking);
                                    },
                                    onPurchase: _showPurchaseBottomSheet,
                                    onRepair: _showRepairBottomSheet,
                                    onViewBooking: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ViewBookingScreen(
                                            booking: booking,
                                            role: UserRole.freelancer,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
