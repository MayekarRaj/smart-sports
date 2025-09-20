import 'package:flutter/material.dart';
import '../../common/models/booking.dart';

class InvoicePreviewPage extends StatelessWidget {
  final Booking booking;
  const InvoicePreviewPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice / Receipt')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.picture_as_pdf, size: 72),
            const SizedBox(height: 12),
            Text('Invoice for ${booking.id}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const Text('This is a placeholder PDF preview screen.'),
            const SizedBox(height: 12),
            FilledButton(onPressed: () {}, child: const Text('Download')),
          ],
        ),
      ),
    );
  }
}
