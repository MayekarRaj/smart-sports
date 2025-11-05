import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddInventoryScreen extends StatefulWidget {
  final Map<String, dynamic>? existingInventory;
  final bool isEditMode;

  const AddInventoryScreen({
    super.key,
    this.existingInventory,
    this.isEditMode = false,
  });

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  // Form controllers
  final TextEditingController _totalCostController = TextEditingController();
  final TextEditingController _daysToDeliverController =
      TextEditingController();
  final TextEditingController _newProductNameController =
      TextEditingController();

  // Dropdown values
  String _selectedType = 'Product';
  String _selectedSport = 'Tennis';
  String _selectedProductName = 'Tennis';
  String _selectedCurrency = 'USD';

  // Checkbox value
  bool _courierDeliveryAccepted = true;

  // Kit products list
  final List<Map<String, dynamic>> _kitProducts = [
    {
      'id': 1,
      'name': 'Racket',
      'image': 'assets/images/tennis_racket.jpg',
      'isRemovable': true,
    },
    {
      'id': 2,
      'name': 'Ball',
      'image': 'assets/images/tennis_ball.jpg',
      'isRemovable': true,
    },
    {
      'id': 3,
      'name': 'Racket',
      'image': 'assets/images/tennis_racket2.jpg',
      'isRemovable': true,
    },
    {
      'id': 4,
      'name': 'Racket',
      'image': 'assets/images/placeholder.jpg',
      'isRemovable': false, // This is the "add new" placeholder
    },
  ];

  // Uploaded images
  final List<File> _images = [];

  // Sample data for dropdowns
  final List<String> _types = ['Product', 'Service', 'Kit'];
  final List<String> _sports = [
    'Tennis',
    'Football',
    'Basketball',
    'Cricket',
    'Badminton',
  ];
  final List<String> _productNames = [
    'Tennis',
    'Football',
    'Basketball',
    'Cricket',
    'Badminton',
  ];
  final List<String> _currencies = ['USD', 'EUR', 'INR', 'GBP'];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.isEditMode && widget.existingInventory != null) {
      final inventory = widget.existingInventory!;
      _selectedType = inventory['type'] ?? 'Product';
      _selectedSport = inventory['sport'] ?? 'Tennis';
      _selectedProductName = inventory['productName'] ?? 'Tennis';
      _selectedCurrency = inventory['currency'] ?? 'USD';
      _totalCostController.text = inventory['totalCost'] ?? '320';
      _daysToDeliverController.text = inventory['daysToDeliver'] ?? '6';
      _courierDeliveryAccepted = inventory['courierDeliveryAccepted'] ?? true;

      // Load existing kit products if any
      if (inventory['kitProducts'] != null) {
        _kitProducts.clear();
        _kitProducts.addAll(
          List<Map<String, dynamic>>.from(inventory['kitProducts']),
        );
        // Ensure there's an "add new" placeholder entry so users can add more
        // kit items while editing (matches Add Inventory behavior).
        final hasPlaceholder = _kitProducts.any(
          (p) => p['isRemovable'] == false,
        );
        if (!hasPlaceholder) {
          _kitProducts.add({
            'id': DateTime.now().millisecondsSinceEpoch,
            'name': 'Racket',
            'image': 'assets/images/placeholder.jpg',
            'isRemovable': false,
          });
        }
      }
      // Load existing images if any
      if (inventory['images'] != null) {
        try {
          final imgs = List<String>.from(inventory['images']);
          for (final p in imgs) {
            if (p.isNotEmpty) {
              _images.add(File(p));
            }
          }
        } catch (_) {
          // ignore malformed image lists
        }
      }
    } else {
      _totalCostController.text = '320';
      _daysToDeliverController.text = '6';
    }
  }

  @override
  void dispose() {
    _totalCostController.dispose();
    _daysToDeliverController.dispose();
    _newProductNameController.dispose();
    // no controllers for images
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.isEditMode ? 'EDIT INVENTORY' : 'ADD INVENTORY',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF009A69),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main form card
            _buildFormCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type dropdown
            _buildDropdownField('Type', _selectedType, _types, (value) {
              setState(() {
                _selectedType = value ?? 'Product';
              });
            }),
            const SizedBox(height: 20),

            // Sport dropdown
            _buildDropdownField('Sport', _selectedSport, _sports, (value) {
              setState(() {
                _selectedSport = value ?? 'Tennis';
              });
            }),
            const SizedBox(height: 20),

            // Product Name dropdown
            _buildDropdownField(
              'Product Name',
              _selectedProductName,
              _productNames,
              (value) {
                setState(() {
                  _selectedProductName = value ?? 'Tennis';
                });
              },
            ),
            const SizedBox(height: 20),

            // Image upload / preview section
            if (!widget.isEditMode) ...[
              _buildImageUploadSection(),
              const SizedBox(height: 20),
            ] else if (_images.isNotEmpty) ...[
              // In edit mode, show only preview thumbnails (read-only)
              _buildImagePreviewSection(),
              const SizedBox(height: 20),
            ],

            // Kit Products section
            _buildKitProductsSection(),
            const SizedBox(height: 20),

            // Total Cost section
            _buildTotalCostSection(),
            const SizedBox(height: 20),

            // Days To Deliver
            _buildDaysToDeliverField(),
            const SizedBox(height: 20),

            // Courier Delivery checkbox
            _buildCourierDeliveryCheckbox(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: GoogleFonts.poppins()),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildKitProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kit Products',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile layout - vertical scroll
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _kitProducts
                      .map((product) => _buildKitProductCard(product))
                      .toList(),
                ),
              );
            } else {
              // Desktop layout - horizontal row
              return Row(
                children: _kitProducts
                    .map((product) => _buildKitProductCard(product))
                    .toList(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Image',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // Input text with attach icon
        Row(
          children: [
            Expanded(
              child: TextFormField(
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Input Text',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: _pickImages,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Dotted / dashed like drop area (clickable)
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image_outlined, size: 36, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to upload images',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Thumbnails
        if (_images.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _images.asMap().entries.map((entry) {
              final idx = entry.key;
              final file = entry.value;
              return Stack(
                children: [
                  Container(
                    width: 100,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  // Remove / indicator
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeImage(idx),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildImagePreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Images',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _images.map((file) {
            return Container(
              width: 100,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  file,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, color: Colors.grey[400]),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      // pickMultiple images if supported
      final List<XFile>? picked = await picker.pickMultiImage(imageQuality: 80);
      if (picked != null && picked.isNotEmpty) {
        setState(() {
          for (final x in picked) {
            final p = x.path;
            if (p.isNotEmpty) {
              _images.add(File(p));
            }
          }
        });
      }
    } catch (e) {
      // ignore errors for now, show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick images', style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Widget _buildKitProductCard(Map<String, dynamic> product) {
    final bool isAddNew = !product['isRemovable'];

    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          // Product image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: isAddNew
                ? Icon(
                    Icons.add_photo_alternate,
                    size: 40,
                    color: Colors.grey[400],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image,
                          color: Colors.grey[400],
                          size: 40,
                        );
                      },
                    ),
                  ),
          ),
          const SizedBox(height: 8),

          // Product name
          if (isAddNew)
            TextFormField(
              controller: _newProductNameController,
              style: GoogleFonts.poppins(fontSize: 12),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter name',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  _addNewKitProduct(value);
                }
              },
            )
          else
            Text(
              product['name'],
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

          // Remove button
          if (product['isRemovable'])
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _removeKitProduct(product),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalCostSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Cost',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 400) {
              // Mobile layout - stack vertically
              return Column(
                children: [
                  _buildCurrencyDropdown(),
                  const SizedBox(height: 8),
                  _buildCostInputField(),
                ],
              );
            } else {
              // Desktop layout - side by side
              return Row(
                children: [
                  _buildCurrencyDropdown(),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCostInputField()),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdown() {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCurrency,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey,
          size: 16,
        ),
        items: _currencies.map((String currency) {
          return DropdownMenuItem<String>(
            value: currency,
            child: Text(currency, style: GoogleFonts.poppins(fontSize: 12)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCurrency = value ?? 'USD';
          });
        },
      ),
    );
  }

  Widget _buildCostInputField() {
    return TextFormField(
      controller: _totalCostController,
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter cost',
        hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildDaysToDeliverField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Days To Deliver',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _daysToDeliverController,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter days',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourierDeliveryCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _courierDeliveryAccepted,
          onChanged: (value) {
            setState(() {
              _courierDeliveryAccepted = value ?? false;
            });
          },
          activeColor: const Color(0xFF009A69),
        ),
        Text(
          'Courier Delivery Accepted ?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Action methods
  void _removeKitProduct(Map<String, dynamic> product) {
    setState(() {
      _kitProducts.remove(product);
    });
  }

  void _addNewKitProduct(String name) {
    setState(() {
      _kitProducts.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': name,
        'image': 'assets/images/placeholder.jpg',
        'isRemovable': true,
      });
      _newProductNameController.clear();
    });
  }

  void _handleSave() {
    // Validate form
    if (_totalCostController.text.isEmpty ||
        _daysToDeliverController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all required fields',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Collect form data
    final inventoryData = {
      'id':
          widget.existingInventory?['id'] ??
          DateTime.now().millisecondsSinceEpoch,
      'type': _selectedType,
      'sport': _selectedSport,
      'productName': _selectedProductName,
      'kitProducts': _kitProducts.where((p) => p['isRemovable']).toList(),
      'currency': _selectedCurrency,
      'totalCost': _totalCostController.text,
      'daysToDeliver': _daysToDeliverController.text,
      'courierDeliveryAccepted': _courierDeliveryAccepted,
      'images': _images.map((f) => f.path).toList(),
      'createdAt':
          widget.existingInventory?['createdAt'] ??
          DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEditMode
              ? 'Inventory updated successfully!'
              : 'Inventory added successfully!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate back with the saved data
    Navigator.of(context).pop(inventoryData);
  }
}
