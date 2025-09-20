import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/models/booking.dart';
import '../../core/theme/app_theme.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onTap;
  final VoidCallback onCancel;
  final VoidCallback onPurchaseRepair;
  final VoidCallback onInvoice;
  final VoidCallback? onTooltip;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
    required this.onCancel,
    required this.onPurchaseRepair,
    required this.onInvoice,
    this.onTooltip,
  });

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('EEE, MMM d, yyyy');
    final timeFmt = DateFormat('HH:mm');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with status badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        booking.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(child: Icon(Icons.image, size: 48)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(booking.status),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        booking.status.label,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Title and id row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.clubName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _locationChip(booking.location),
                            _ratingRow(booking.rating),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    booking.id,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Coach and players
              Row(
                children: [
                  const Icon(Icons.person, size: 18, color: Colors.black87),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      booking.coachName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // tiny players avatars as initials
                  Row(
                    children: booking.players.take(4).map((p) => _avatar(p)).toList(),
                  )
                ],
              ),
              const SizedBox(height: 8),
              // Schedule
              _scheduleTile(
                title: 'Booking Schedule',
                values: [
                  booking.court,
                  '${booking.slots} Slots',
                  dateFmt.format(booking.dateTimeStart),
                  '${timeFmt.format(booking.dateTimeStart)} - ${timeFmt.format(booking.dateTimeEnd)}',
                ],
              ),
              const SizedBox(height: 8),
              // Chips row
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _chip(label: booking.role.label, icon: Icons.verified_user),
                  _chip(label: booking.sportType.label, icon: Icons.sports_tennis),
                  _chip(
                    label: booking.paymentStatus.label,
                    icon: Icons.payment,
                    background: booking.paymentStatus.color,
                    foreground: Colors.black,
                  ),
                  if (booking.waitListConfirmed)
                    GestureDetector(
                      onTap: onTooltip,
                      child: _chip(
                        label: 'Wait List Confirmed',
                        icon: Icons.hourglass_bottom,
                        background: Colors.yellow.shade700,
                        foreground: Colors.white,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Actions
              Row(
                children: [
                  _smallOutlinedButton(
                    context,
                    label: 'Cancel',
                    onPressed: onCancel,
                    icon: Icons.cancel_outlined,
                  ),
                  const SizedBox(width: 8),
                  _smallFilledButton(
                    context,
                    label: 'Purchase / Repair',
                    onPressed: onPurchaseRepair,
                    icon: Icons.shopping_bag_outlined,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onInvoice,
                    child: const Text('Invoice / Receipt'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(BookingStatus s) {
    switch (s) {
      case BookingStatus.upcoming:
        return AppTheme.primary;
      case BookingStatus.waiting:
        return Colors.orange;
      case BookingStatus.paid:
        return AppTheme.success;
      case BookingStatus.archived:
        return Colors.grey.shade700;
      case BookingStatus.cancelled:
        return AppTheme.error;
    }
  }

  Widget _locationChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on_outlined, size: 14),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _ratingRow(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(width: 4),
        const Icon(Icons.star, color: Colors.amber, size: 16),
      ],
    );
  }

  Widget _avatar(String initial) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: CircleAvatar(
        radius: 12,
        backgroundColor: Colors.grey.shade300,
        child: Text(initial, style: const TextStyle(fontSize: 12, color: Colors.black)),
      ),
    );
  }

  Widget _scheduleTile({required String title, required List<String> values}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: values.map((v) => _pill(v)).toList(),
          )
        ],
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFDFE3E8)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _chip({required String label, required IconData icon, Color? background, Color? foreground}) {
    return Chip(
      label: Text(label, style: TextStyle(fontSize: 12, color: foreground)),
      avatar: Icon(icon, size: 16, color: foreground ?? Colors.black87),
      backgroundColor: background ?? const Color(0xFFEFF3F8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _smallOutlinedButton(BuildContext context, {required String label, required VoidCallback onPressed, required IconData icon}) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: const BorderSide(color: Color(0xFFDFE3E8)),
      ),
    );
  }

  Widget _smallFilledButton(BuildContext context, {required String label, required VoidCallback onPressed, required IconData icon}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    );
  }
}
