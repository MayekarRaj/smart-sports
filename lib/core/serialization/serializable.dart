import 'dart:convert';

/// Base interface for all serializable models
/// Provides consistent fromJson/toJson pattern
abstract class Serializable {
  /// Convert object to JSON map
  Map<String, dynamic> toJson();

  /// Create object from JSON map
  /// This is a factory constructor that should be implemented in each model
  // factory Serializable.fromJson(Map<String, dynamic> json);
}

/// Extension methods for easier JSON handling
extension SerializableExtension on Serializable {
  /// Convert to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }
}

/// Helper function for JSON encoding
String jsonEncode(Object? object) => json.encode(object);

/// Helper function for safe JSON parsing
T? safeJsonParse<T>(dynamic value, T Function(dynamic) parser) {
  try {
    if (value == null) return null;
    return parser(value);
  } catch (e) {
    return null;
  }
}

/// Helper function for parsing lists
List<T> parseList<T>(dynamic json, T Function(Map<String, dynamic>) parser) {
  if (json == null) return [];
  if (json is! List) return [];
  return json
      .whereType<Map<String, dynamic>>()
      .map(parser)
      .toList();
}

/// Helper function for parsing nullable lists
List<T>? parseNullableList<T>(
  dynamic json,
  T Function(Map<String, dynamic>) parser,
) {
  if (json == null) return null;
  return parseList(json, parser);
}

/// Helper function for parsing enums from strings
T? parseEnum<T>(String? value, List<T> enumValues) {
  if (value == null) return null;
  try {
    return enumValues.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == value.toLowerCase(),
      orElse: () => enumValues.first,
    );
  } catch (e) {
    return null;
  }
}

/// Helper function for enum to string conversion
String enumToString<T>(T enumValue) {
  return enumValue.toString().split('.').last;
}

