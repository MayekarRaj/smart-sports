/// Utility class for parsing phone numbers
/// Handles formats like "+91 - 9876543210" or "91-9876543210"
class PhoneParser {
  /// Parse phone number string into extension and number
  /// Returns Map with 'ext' and 'number' keys
  static Map<String, String> parsePhoneNumber(String phoneString) {
    if (phoneString.isEmpty) {
      return {'ext': '', 'number': ''};
    }

    // Remove spaces and common separators
    final cleaned = phoneString.replaceAll(RegExp(r'\s+'), '').trim();
    
    // Try to extract extension (format: +91-9876543210 or 91-9876543210)
    final parts = cleaned.split('-');
    
    if (parts.length >= 2) {
      // Has extension
      String ext = parts[0].replaceAll('+', '');
      String number = parts.sublist(1).join('');
      return {'ext': ext, 'number': number};
    } else {
      // No extension, try to extract from + prefix
      if (cleaned.startsWith('+')) {
        // Try to extract country code (1-3 digits after +)
        final match = RegExp(r'^\+(\d{1,3})(\d+)$').firstMatch(cleaned);
        if (match != null) {
          return {'ext': match.group(1) ?? '', 'number': match.group(2) ?? ''};
        }
      }
      // No extension found, return as number
      return {'ext': '', 'number': cleaned.replaceAll('+', '')};
    }
  }

  /// Format phone number for display
  static String formatPhoneNumber(String ext, String number) {
    if (ext.isEmpty) {
      return number;
    }
    return '+$ext - $number';
  }
}

