import 'package:flutter/material.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/models/api_models.dart';
import '../../core/exceptions/api_exception.dart';

class PhoneCodeDropdown extends StatefulWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final bool enabled;

  const PhoneCodeDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<PhoneCodeDropdown> createState() => _PhoneCodeDropdownState();
}

class _PhoneCodeDropdownState extends State<PhoneCodeDropdown> {
  final AuthRepository _authRepository = AuthRepository();
  List<PhoneCode> _phoneCodes = [];
  bool _isLoading = true;
  String? _selectedValue;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
    _loadPhoneCodes();
  }

  @override
  void didUpdateWidget(PhoneCodeDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selectedValue = widget.value;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPhoneCodes() async {
    try {
      final response = await _authRepository.getPhoneCodes();
      if (mounted) {
        setState(() {
          _phoneCodes = response.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading phone codes: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load phone codes: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getUniqueValue(PhoneCode phoneCode) {
    // Use id_phonecode format to ensure uniqueness
    return '${phoneCode.id}_${phoneCode.phonecode}';
  }

  PhoneCode? _getPhoneCodeFromValue(String? value) {
    if (value == null) return null;
    try {
      final parts = value.split('_');
      if (parts.length >= 2) {
        final id = int.parse(parts[0]);
        return _phoneCodes.firstWhere((pc) => pc.id == id);
      }
    } catch (e) {
      debugPrint('Error parsing phone code value: $e');
    }
    return null;
  }

  String _formatPhoneCode(PhoneCode phoneCode) {
    return '+${phoneCode.phonecode}';
  }

  List<PhoneCode> _getFilteredPhoneCodes(String query) {
    if (query.isEmpty) return _phoneCodes;
    final lowerQuery = query.toLowerCase();
    return _phoneCodes.where((phoneCode) {
      return phoneCode.countryName.toLowerCase().contains(lowerQuery) ||
          phoneCode.phonecode.toString().contains(query) ||
          (phoneCode.countryShortName?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  void _showSearchableDialog() {
    _searchController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final filteredCodes = _getFilteredPhoneCodes(_searchController.text);
          return Container(
            color: Colors.white,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search field
                TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search country or code...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setModalState(() {
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setModalState(() {});
                  },
                ),
                const SizedBox(height: 16),
                // List of phone codes
                Expanded(
                  child: filteredCodes.isEmpty
                      ? const Center(
                          child: Text('No results found'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredCodes.length,
                          itemBuilder: (context, index) {
                            final phoneCode = filteredCodes[index];
                            final uniqueValue = _getUniqueValue(phoneCode);
                            final isSelected = _selectedValue == uniqueValue;
                            
                            return ListTile(
                              leading: Text(
                                _formatPhoneCode(phoneCode),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              title: Text(phoneCode.countryName),
                              trailing: isSelected
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedValue = uniqueValue;
                                });
                                widget.onChanged?.call(uniqueValue);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PhoneCode? _getSelectedPhoneCode() {
    if (_selectedValue == null) return null;
    return _getPhoneCodeFromValue(_selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Loading...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    if (_phoneCodes.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: const Text('No phone codes available', style: TextStyle(color: Colors.grey)),
      );
    }

    final selectedPhoneCode = _getSelectedPhoneCode();
    final displayText = selectedPhoneCode != null
        ? '${_formatPhoneCode(selectedPhoneCode)} ${selectedPhoneCode.countryName}'
        : 'Select Code';

    return InkWell(
      onTap: widget.enabled ? _showSearchableDialog : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: selectedPhoneCode != null
                      ? Colors.black
                      : Colors.grey.shade400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}

