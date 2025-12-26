import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/booking_model.dart';
import 'coach_tile.dart';
import 'player_avatar_row.dart';

class BookingCard extends StatefulWidget {
  final BookingModel booking;
  final VoidCallback? onCancelBooking;
  final VoidCallback? onPurchase;
  final VoidCallback? onRepair;
  final VoidCallback? onViewBooking;

  const BookingCard({
    Key? key,
    required this.booking,
    this.onCancelBooking,
    this.onPurchase,
    this.onRepair,
    this.onViewBooking,
  }) : super(key: key);

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with Archived badge
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.booking.venueName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Booking ID ${widget.booking.bookingId}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF007BFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Archived badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Archived',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main content - Mobile vertical layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Venue Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1534158914592-062992fbe900?w=800',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.sports_basketball,
                          size: 50,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Location
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF007BFF),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.booking.location,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF007BFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Club Rating with title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Club Rating',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          widget.booking.rating.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 6),
                        ...List.generate(5, (index) {
                          return Icon(
                            index < widget.booking.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Coach
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coach',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    CoachTile(
                      name: widget.booking.coach.name,
                      email: widget.booking.coach.email,
                      imageUrl: widget.booking.coach.imageUrl,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Reserved By
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reserved By',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        widget.booking.reservedBy,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Booking Schedule (always visible)
                _buildBookingSchedule(),
                const SizedBox(height: 12),
                
                // Booking As, Sport Type, Payment Status
                _buildInfoButtons(),
                const SizedBox(height: 12),
                
                // Invoice and Receipt links
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'invoice',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF007BFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Receipt',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF007BFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Game Equipments title
                Text(
                  'Game Equipments',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Purchase and Repair buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onPurchase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          'Purchase',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onRepair,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF007BFF),
                          side: const BorderSide(
                            color: Color(0xFF007BFF),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          'Repair',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Players section - Show IGVAE image for Elite Arena, otherwise show player avatars
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Players',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_isEliteArena())
                      // IGVAE Image as circular avatars with shadows (exact match to image)
                      SizedBox(
                        height: 32,
                        child: Stack(
                          children: List.generate(4, (index) {
                            return Positioned(
                              left: index * 24.0, // Overlap by 8px (32 - 24 = 8)
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/igvae_image.png',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade300,
                                          child: Icon(
                                            Icons.image,
                                            size: 18,
                                            color: Colors.grey.shade600,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      )
                    else
                      // Player avatars
                      PlayerAvatarRow(
                        players: widget.booking.players,
                        maxVisible: 4,
                        avatarSize: 32,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Request Status (for Elite Arena)
                if (_isEliteArena())
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Request Status',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getRequestStatusColor(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getRequestStatusIcon(),
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _getRequestStatusText(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Cancel and Waiting buttons at bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onCancelBooking,
                    icon: const Icon(Icons.cancel, size: 16),
                    label: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.hourglass_empty, size: 16),
                    label: Text(
                      _getStatusText(),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getStatusColor(),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (widget.booking.status) {
      case BookingStatus.waiting:
        return const Color(0xFFFF9800);
      case BookingStatus.waitListConfirmed:
        return const Color(0xFFFFD600);
      case BookingStatus.confirmed:
        return const Color(0xFF4CAF50);
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText() {
    switch (widget.booking.status) {
      case BookingStatus.waiting:
        return 'Waiting';
      case BookingStatus.waitListConfirmed:
        return 'Wait List Confirmed';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Widget _buildBookingSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Schedule',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: '${widget.booking.schedule.court}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: ', '),
                TextSpan(
                  text: '${widget.booking.schedule.slots} Slots',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: ', '),
                TextSpan(text: widget.booking.schedule.date),
                const TextSpan(text: ', '),
                TextSpan(text: widget.booking.schedule.time),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoButtons() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        // Booking As
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF007BFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.booking.bookingAs,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Sport Type
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF007BFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.booking.sportType,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Payment Status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Paid',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  bool _isEliteArena() {
    return widget.booking.venueName.toLowerCase().contains('elite');
  }

  Color _getRequestStatusColor() {
    switch (widget.booking.coachRequestStatus) {
      case CoachRequestStatus.pending:
        return Colors.orange;
      case CoachRequestStatus.accepted:
        return Colors.green;
      case CoachRequestStatus.rejected:
        return Colors.red;
    }
  }

  IconData _getRequestStatusIcon() {
    switch (widget.booking.coachRequestStatus) {
      case CoachRequestStatus.pending:
        return Icons.pending;
      case CoachRequestStatus.accepted:
        return Icons.check_circle;
      case CoachRequestStatus.rejected:
        return Icons.cancel;
    }
  }

  String _getRequestStatusText() {
    switch (widget.booking.coachRequestStatus) {
      case CoachRequestStatus.pending:
        return 'Pending';
      case CoachRequestStatus.accepted:
        return 'Accepted';
      case CoachRequestStatus.rejected:
        return 'Rejected';
    }
  }

}
