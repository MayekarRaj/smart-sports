import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_models.dart';

class EventHeaderCard extends StatelessWidget {
  final EventInfo info;
  final VoidCallback? onConnectOrganiser;
  final VoidCallback? onSubscribe;
  const EventHeaderCard({super.key, required this.info, this.onConnectOrganiser, this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    final dateRange = '${DateFormat('EEE, MMM d, yyyy').format(info.eventStart)}  •  ${DateFormat('EEE, MMM d, yyyy').format(info.eventEnd)}';
    final regLast = DateFormat('EEE, MMM d, yyyy').format(info.registrationLastDate);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image
          AspectRatio(
            // Slightly taller to avoid content overflow on small devices
            aspectRatio: 16 / 10,
            child: Ink.image(
              image: NetworkImage(info.imageUrl),
              fit: BoxFit.cover,
              child: const SizedBox.shrink(),
            ),
          ),
          // Dark gradient overlay for legibility
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.15), Colors.black.withOpacity(0.6)],
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(info.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _pill(Icons.location_on_outlined, '${info.venue}'),
                      const SizedBox(width: 8),
                      _pill(Icons.place_outlined, info.location),
                      const Spacer(),
                      Row(children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(info.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                      ])
                    ],
                  ),
                  const Spacer(),
                  // Sports chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: info.sports.map((s) => Chip(label: Text(s), backgroundColor: Colors.white.withOpacity(0.9))).toList(),
                  ),
                  const SizedBox(height: 8),
                  // Schedule
                  Row(children: [
                    Expanded(
                      child: _glassTile(
                        icon: Icons.event,
                        title: 'Event Date',
                        value: dateRange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _glassTile(
                        icon: Icons.schedule,
                        title: 'Registration Last Date',
                        value: regLast,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          // Organiser mini-card
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 136,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x33000000), offset: Offset(0, 4))],
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ORGANISER', style: TextStyle(color: Colors.grey.shade700, fontSize: 10, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(info.organiserName, style: const TextStyle(fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(info.organiserEmail, style: const TextStyle(color: Colors.black54, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  FilledButton(
                    onPressed: onConnectOrganiser,
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(32)),
                    child: const Text('Connect'),
                  )
                ],
              ),
            ),
          ),
          // Subscribe badge/button bottom-right
          if (onSubscribe != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [BoxShadow(blurRadius: 8, color: Color(0x33000000), offset: Offset(0, 2))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Material(
                    color: Colors.green,
                    child: InkWell(
                      onTap: onSubscribe,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Row(children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Subscribe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _pill(IconData icon, String text) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(children: [Icon(icon, size: 14, color: Colors.white), const SizedBox(width: 6), Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))]),
    );
  }

  Widget _glassTile({required IconData icon, required String title, required String value}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w600)),
                Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
