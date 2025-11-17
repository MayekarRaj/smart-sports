import 'package:flutter/material.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/models/api_models.dart';
import '../../core/exceptions/api_exception.dart';

/// A reusable phone code dropdown that fetches codes from API
class PhoneCodeDropdown extends StatefulWidget {
  final String? value;
  final Function(String?) onChanged;
  final String? label;
  final bool enabled;

  const PhoneCodeDropdown({
    super.key,
    this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
  });

  @override
  State<PhoneCodeDropdown> createState() => _PhoneCodeDropdownState();
}

class _PhoneCodeDropdownState extends State<PhoneCodeDropdown> {
  final AuthRepository _authRepository = AuthRepository();
  List<PhoneCode> _phoneCodes = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPhoneCodes();
  }

  Future<void> _loadPhoneCodes() async {
    if (_hasLoaded) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authRepository.getPhoneCodes();
      
      if (mounted) {
        setState(() {
          _phoneCodes = response.data;
          _isLoading = false;
          _hasLoaded = true;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load phone codes: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  String _formatPhoneCode(PhoneCode code) {
    return '+${code.phonecode}';
  }

  String _getUniqueValue(PhoneCode code) {
    // Use ID to ensure uniqueness, since multiple countries can have same phone code
    return '${code.id}_${code.phonecode}';
  }

  String? _getPhoneCodeFromValue(String? value) {
    if (value == null) return null;
    // Extract phone code from unique value format: "id_phonecode"
    final parts = value.split('_');
    if (parts.length >= 2) {
      return '+${parts[1]}';
    }
    return value; // Fallback to original value if format is unexpected
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: _isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : _errorMessage != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[700], fontSize: 12),
                      ),
                    )
                  : DropdownButtonFormField<String>(
                      value: widget.value != null && _phoneCodes.isNotEmpty
                          ? () {
                              try {
                                final code = _phoneCodes.firstWhere(
                                  (code) => _formatPhoneCode(code) == widget.value,
                                );
                                return _getUniqueValue(code);
                              } catch (e) {
                                return null;
                              }
                            }()
                          : null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      items: _phoneCodes.map((code) {
                        final codeString = _formatPhoneCode(code);
                        final uniqueValue = _getUniqueValue(code);
                        return DropdownMenuItem<String>(
                          value: uniqueValue,
                          child: Text('$codeString ${code.countryName}'),
                        );
                      }).toList(),
                      onChanged: (widget.enabled && _phoneCodes.isNotEmpty) 
                          ? (value) {
                              if (value != null) {
                                final phoneCode = _getPhoneCodeFromValue(value);
                                widget.onChanged(phoneCode);
                              }
                            }
                          : null,
                    ),
        ),
      ],
    );
  }
}

