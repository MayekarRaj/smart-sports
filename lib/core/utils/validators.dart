// validators.dart
import 'package:email_validator/email_validator.dart';

class Validators {
  static String? required(String? v, {String field = 'This field'}) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? email(String? v) {
    if ((v ?? '').isEmpty) return 'Email is required';
    if (!EmailValidator.validate(v!.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? v) {
    if ((v ?? '').isEmpty) return 'Password is required';
    if (v!.length < 8) return 'Min 8 characters';
    return null;
  }

  static String? confirmPassword(String? v, String? other) {
    if ((v ?? '').isEmpty) return 'Confirm your password';
    if (v != other) return 'Password and Confirm Password do not match';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty)
      return null; // Optional, or handled by required() if needed
    // remove any non-digit chars if you want to be stricter, but simple length check is asked
    if (v.trim().length < 10) return 'Min 10 digits required';
    return null;
  }
}
