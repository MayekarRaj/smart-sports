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

class _BookingCardState extends State<BookingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Header with status badges
                        Row(
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
                            _buildStatusBadges(),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Location and rating
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF007BFF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(
                                    0xFF007BFF,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                widget.booking.location,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF007BFF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(
                                  widget.booking.rating.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 4),
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

                        const SizedBox(height: 16),

                        // Coach details
                        CoachTile(
                          name: widget.booking.coach.name,
                          email: widget.booking.coach.email,
                          imageUrl: widget.booking.coach.imageUrl,
                        ),

                        const SizedBox(height: 12),

                        // Players
                        Row(
                          children: [
                            Text(
                              'Players:',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            PlayerAvatarRow(
                              players: widget.booking.players,
                              maxVisible: 4,
                              avatarSize: 28,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Equipment actions
                        Row(
                          children: widget.booking.equipmentActions.map((
                            action,
                          ) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: ElevatedButton(
                                  onPressed: action.type == 'purchase'
                                      ? widget.onPurchase
                                      : widget.onRepair,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: action.type == 'purchase'
                                        ? const Color(0xFF007BFF)
                                        : Colors.white,
                                    foregroundColor: action.type == 'purchase'
                                        ? Colors.white
                                        : const Color(0xFF007BFF),
                                    side: BorderSide(
                                      color: const Color(0xFF007BFF),
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child: Text(
                                    action.label,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 12),

                        // View Booking Button
                        if (widget.onViewBooking != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ElevatedButton(
                              onPressed: widget.onViewBooking,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007BFF),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.visibility, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'View Booking',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Reserved by
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            'Reserved By: ${widget.booking.reservedBy}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),

                        // Expandable content
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: _isExpanded ? null : 0,
                          child: _isExpanded
                              ? Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    _buildBookingSchedule(),
                                    const SizedBox(height: 12),
                                    _buildChips(),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadges() {
    List<Widget> badges = [];

    // Cancel Booking button
    badges.add(
      Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: ElevatedButton(
          onPressed: widget.onCancelBooking,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            minimumSize: Size.zero,
          ),
          child: Text(
            'Cancel Booking',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );

    // Status badge
    Color statusColor;
    String statusText;
    Color textColor = Colors.white;

    switch (widget.booking.status) {
      case BookingStatus.waiting:
        statusColor = const Color(0xFFFF9800);
        statusText = 'Waiting';
        break;
      case BookingStatus.waitListConfirmed:
        statusColor = const Color(0xFFFFD600);
        statusText = 'Wait List Confirmed';
        textColor = Colors.black;
        break;
      case BookingStatus.confirmed:
        statusColor = const Color(0xFF4CAF50);
        statusText = 'Confirmed';
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'Cancelled';
        break;
    }

    badges.add(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          statusText,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );

    // Wait List payment warning
    if (widget.booking.status == BookingStatus.waitListConfirmed) {
      badges.add(
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            'Pay by Wed, 23 Apr 2025 or wait list will be canceled.',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: badges);
  }

  Widget _buildBookingSchedule() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Schedule',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildScheduleItem(
                  'Court',
                  widget.booking.schedule.court,
                  Icons.sports,
                ),
              ),
              Expanded(
                child: _buildScheduleItem(
                  'Slots',
                  '${widget.booking.schedule.slots}',
                  Icons.schedule,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildScheduleItem(
                  'Date',
                  widget.booking.schedule.date,
                  Icons.calendar_today,
                ),
              ),
              Expanded(
                child: _buildScheduleItem(
                  'Time',
                  widget.booking.schedule.time,
                  Icons.access_time,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.blue.shade600),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildChips() {
    return Row(
      children: [
        // Booking As chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF007BFF)),
          ),
          child: Text(
            widget.booking.bookingAs,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF007BFF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Sport Type chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF007BFF)),
          ),
          child: Text(
            widget.booking.sportType,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF007BFF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Coach Request chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getCoachRequestColor(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _getCoachRequestText(),
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: _getCoachRequestTextColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Color _getCoachRequestColor() {
    switch (widget.booking.coachRequestStatus) {
      case CoachRequestStatus.pending:
        return Colors.grey.shade300;
      case CoachRequestStatus.accepted:
        return const Color(0xFFFF9800);
      case CoachRequestStatus.rejected:
        return Colors.red.shade300;
    }
  }

  Color _getCoachRequestTextColor() {
    switch (widget.booking.coachRequestStatus) {
      case CoachRequestStatus.pending:
        return Colors.grey.shade600;
      case CoachRequestStatus.accepted:
        return Colors.white;
      case CoachRequestStatus.rejected:
        return Colors.red.shade700;
    }
  }

  String _getCoachRequestText() {
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
