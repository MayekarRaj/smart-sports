import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_inventory_screen.dart';

class ViewInventoryScreen extends StatelessWidget {
  final Map<String, dynamic> inventory;

  const ViewInventoryScreen({super.key, required this.inventory});

  Widget _buildLabel(String text) => Text(
    text,
    style: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.grey[700],
    ),
  );

  Widget _buildValue(String text) => Text(
    text,
    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
  );

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: _buildValue(value),
        ),
      ],
    );
  }

  Widget _buildKitProducts(List<dynamic> kits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Kit Products'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: kits.map<Widget>((k) {
            final name = k['name'] ?? '';
            final image = k['image'] ?? '';
            Widget img;
            if (image is String && image.startsWith('assets/')) {
              img = Image.asset(image, fit: BoxFit.cover);
            } else if (image is String && image.isNotEmpty) {
              img = Image.file(File(image), fit: BoxFit.cover);
            } else {
              img = Icon(Icons.image, color: Colors.grey[400], size: 40);
            }

            return Column(
              children: [
                Container(
                  width: 140,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: img,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 140,
                  child: Text(
                    name,
                    style: GoogleFonts.poppins(fontSize: 12),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImages(List<dynamic> imgs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Service Images'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: imgs.map<Widget>((p) {
            Widget img;
            if (p is String && p.startsWith('assets/')) {
              img = Image.asset(p, fit: BoxFit.cover);
            } else if (p is String && p.isNotEmpty) {
              img = Image.file(File(p), fit: BoxFit.cover);
            } else {
              img = Icon(Icons.broken_image, color: Colors.grey[400]);
            }

            return Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: img,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sport = inventory['sport']?.toString() ?? '';
    final productName = inventory['productName']?.toString() ?? '';
    final currency = inventory['currency']?.toString() ?? '';
    final totalCost = inventory['totalCost']?.toString() ?? '';
    final days = inventory['daysToDeliver']?.toString() ?? '';
    final courier = (inventory['courierDeliveryAccepted'] == true)
        ? 'Yes'
        : 'No';
    final kitProducts = inventory['kitProducts'] ?? <dynamic>[];
    final images = inventory['images'] ?? <dynamic>[];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'VIEW INVENTORY',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF009A69),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              // Open edit screen and if saved, return the updated inventory to the caller
              final result = await Navigator.of(context)
                  .push<Map<String, dynamic>>(
                    MaterialPageRoute(
                      builder: (context) => AddInventoryScreen(
                        existingInventory: inventory,
                        isEditMode: true,
                      ),
                    ),
                  );

              if (result != null) {
                Navigator.of(context).pop(result);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField('Type', inventory['type']?.toString() ?? ''),
                  const SizedBox(height: 12),
                  _buildField('Sport', sport),
                  const SizedBox(height: 12),
                  _buildField('Product Name', productName),
                  const SizedBox(height: 12),
                  if (kitProducts.isNotEmpty) _buildKitProducts(kitProducts),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          'Total Cost',
                          '$currency $totalCost',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _buildField('Days To Deliver', days)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildField('Courier Delivery Accepted ?', courier),
                  const SizedBox(height: 12),
                  if (images.isNotEmpty) _buildImages(images),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
