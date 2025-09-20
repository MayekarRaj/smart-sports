import 'package:flutter/material.dart';
import '../../common/models/booking.dart';
import '../../core/theme/app_theme.dart';

class BookingDetailPage extends StatelessWidget {
  final Booking booking;
  const BookingDetailPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(booking.imageUrl, height: 180, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          Text(booking.clubName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 4),
              Text(booking.location, style: TextStyle(color: Colors.grey.shade700)),
              const Spacer(),
              const Icon(Icons.star, color: Colors.amber, size: 16),
              Text(booking.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 16),
          _infoTile('Coach', booking.coachName, Icons.person_outline),
          const SizedBox(height: 8),
          _infoTile('Court', booking.court, Icons.sports_tennis),
          const SizedBox(height: 8),
          _infoTile('Slots', '${booking.slots}', Icons.event_seat_outlined),
          const SizedBox(height: 8),
          _infoTile('Sport', booking.sportType.label, Icons.sports_baseball_outlined),
          const SizedBox(height: 8),
          _infoTile('Payment', booking.paymentStatus.label, Icons.payment),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
            child: const Text('Book Again'),
          )
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDFE3E8)),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
