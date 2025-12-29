import 'dart:convert';

/// JSON Serialization Helpers
/// Utility functions for safe JSON parsing and serialization

class JsonHelpers {
  /// Safely parse a JSON string
  static Map<String, dynamic>? parseJson(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      return json.decode(jsonString) as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  /// Safely parse a JSON string to a list
  static List<dynamic>? parseJsonList(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      return json.decode(jsonString) as List<dynamic>?;
    } catch (e) {
      return null;
    }
  }

  /// Safely encode an object to JSON string
  static String? encodeJson(dynamic object) {
    try {
      return json.encode(object);
    } catch (e) {
      return null;
    }
  }

  /// Get a value from JSON map safely
  static T? getValue<T>(Map<String, dynamic>? json, String key) {
    if (json == null || !json.containsKey(key)) return null;
    try {
      return json[key] as T?;
    } catch (e) {
      return null;
    }
  }

  /// Get a value with a default
  static T getValueOrDefault<T>(
    Map<String, dynamic>? json,
    String key,
    T defaultValue,
  ) {
    return getValue<T>(json, key) ?? defaultValue;
  }

  /// Parse a date string from JSON
  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) {
      // Unix timestamp in seconds
      try {
        return DateTime.fromMillisecondsSinceEpoch(value * 1000);
      } catch (e) {
        return null;
      }
    }
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Format a date to ISO string
  static String? formatDate(DateTime? date) {
    if (date == null) return null;
    return date.toIso8601String();
  }

  /// Parse a list from JSON
  static List<T> parseList<T>(
    dynamic json,
    T Function(Map<String, dynamic>) parser,
  ) {
    if (json == null) return [];
    if (json is! List) return [];
    return json
        .whereType<Map<String, dynamic>>()
        .map(parser)
        .toList();
  }

  /// Parse a nullable list from JSON
  static List<T>? parseNullableList<T>(
    dynamic json,
    T Function(Map<String, dynamic>) parser,
  ) {
    if (json == null) return null;
    return parseList(json, parser);
  }

  /// Parse an enum from string
  static T? parseEnum<T>(
    dynamic value,
    List<T> enumValues,
    T Function(String)? fromString,
  ) {
    if (value == null) return null;
    if (value is T) return value;
    if (value is String) {
      if (fromString != null) {
        try {
          return fromString(value);
        } catch (e) {
          return null;
        }
      }
      // Try to find enum by name
      try {
        return enumValues.firstWhere(
          (e) => e.toString().split('.').last.toLowerCase() == value.toLowerCase(),
          orElse: () => enumValues.first,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Convert enum to string
  static String enumToString<T>(T enumValue) {
    return enumValue.toString().split('.').last;
  }

  /// Deep merge two maps
  static Map<String, dynamic> mergeMaps(
    Map<String, dynamic> map1,
    Map<String, dynamic> map2,
  ) {
    final result = Map<String, dynamic>.from(map1);
    map2.forEach((key, value) {
      if (value is Map<String, dynamic> && result[key] is Map<String, dynamic>) {
        result[key] = mergeMaps(
          result[key] as Map<String, dynamic>,
          value,
        );
      } else {
        result[key] = value;
      }
    });
    return result;
  }
}

