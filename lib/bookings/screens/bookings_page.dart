import 'package:flutter/material.dart';
import '../../common/models/booking.dart';
import '../widgets/booking_card.dart';
import 'invoice_preview_page.dart';
import 'booking_detail_page.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> with TickerProviderStateMixin {
  late List<Booking> _bookings;

  @override
  void initState() {
    super.initState();
    _bookings = mockBookings();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookings'),
          bottom: const TabBar(
            isScrollable: false,
            tabs: [
              Tab(text: 'Upcoming Bookings'),
              Tab(text: 'Archived Bookings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookingsList(context, (b) => b.status == BookingStatus.upcoming || b.status == BookingStatus.waiting || b.status == BookingStatus.paid),
            _buildBookingsList(context, (b) => b.status == BookingStatus.archived),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context, bool Function(Booking) filter) {
    final list = _bookings.where(filter).toList();
    if (list.isEmpty) {
      return const Center(child: Text('No bookings yet'));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final booking = list[index];
        return BookingCard(
          booking: booking,
          onTap: () => _openDetails(booking),
          onCancel: () => _cancelBooking(booking),
          onPurchaseRepair: () => _openPurchaseRepair(booking),
          onInvoice: () => _openInvoice(booking),
          onTooltip: () => _showWaitListInfo(booking),
        );
      },
    );
  }

  void _cancelBooking(Booking b) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: Text('Are you sure you want to cancel ${b.id}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          FilledButton.tonal(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes, cancel')),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() {
        _bookings = _bookings.map((x) => x.id == b.id ? Booking(
          id: x.id,
          clubName: x.clubName,
          location: x.location,
          rating: x.rating,
          coachName: x.coachName,
          players: x.players,
          court: x.court,
          slots: x.slots,
          dateTimeStart: x.dateTimeStart,
          dateTimeEnd: x.dateTimeEnd,
          status: BookingStatus.cancelled,
          paymentStatus: x.paymentStatus,
          sportType: x.sportType,
          role: x.role,
          imageUrl: x.imageUrl,
          waitListConfirmed: x.waitListConfirmed,
        ) : x).toList();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking cancelled')));
      }
    }
  }

  void _openPurchaseRepair(Booking b) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Actions for ${b.clubName}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.shopping_cart_outlined),
                  title: const Text('Purchase Game Equipment'),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: const Icon(Icons.build_circle_outlined),
                  title: const Text('Request Repair / Maintenance'),
                  onTap: () => Navigator.pop(ctx),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openInvoice(Booking b) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => InvoicePreviewPage(booking: b)));
  }

  void _openDetails(Booking b) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookingDetailPage(booking: b)));
  }

  void _showWaitListInfo(Booking b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Wait List Confirmed'),
        content: const Text('Your wait list is confirmed. Please complete payment before the deadline to avoid cancellation.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }
}
