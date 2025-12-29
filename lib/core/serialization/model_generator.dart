/// Model Generator Helper
/// This file contains utilities to help generate models from API responses
///
/// Usage: When you provide API responses, I'll use these helpers to generate
/// proper Dart models with fromJson/toJson methods

class ModelGenerator {
  /// Generate model from JSON structure
  /// This is a helper to understand the structure and generate models
  static String generateModelTemplate({
    required String className,
    required Map<String, dynamic> jsonStructure,
    String? parentClass,
  }) {
    final buffer = StringBuffer();

    // Class definition
    buffer.writeln(
      'class $className${parentClass != null ? ' extends $parentClass' : ''} {',
    );

    // Generate fields
    final fields = <String, String>{};
    jsonStructure.forEach((key, value) {
      final dartType = _getDartType(value);
      final fieldName = _camelCase(key);
      fields[fieldName] = dartType;
      buffer.writeln('  final $dartType $fieldName;');
    });

    buffer.writeln();

    // Constructor
    buffer.writeln('  $className({');
    fields.forEach((name, type) {
      final isRequired = !type.contains('?');
      final requiredStr = isRequired ? 'required ' : '';
      buffer.writeln('    $requiredStr$type $name,');
    });
    buffer.writeln('  });');
    buffer.writeln();

    // fromJson factory
    buffer.writeln(
      '  factory $className.fromJson(Map<String, dynamic> json) {',
    );
    buffer.writeln('    return $className(');
    fields.forEach((name, type) {
      final jsonKey = _snakeCase(name);
      buffer.writeln('      $name: json[\'$jsonKey\'],');
    });
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln();

    // toJson method
    buffer.writeln('  @override');
    buffer.writeln('  Map<String, dynamic> toJson() {');
    buffer.writeln('    return {');
    fields.forEach((name, type) {
      final jsonKey = _snakeCase(name);
      buffer.writeln('      \'$jsonKey\': $name,');
    });
    buffer.writeln('    };');
    buffer.writeln('  }');
    buffer.writeln('}');

    return buffer.toString();
  }

  static String _getDartType(dynamic value) {
    if (value == null) return 'dynamic?';
    if (value is String) return 'String';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'bool';
    if (value is List) {
      if (value.isEmpty) return 'List<dynamic>';
      final itemType = _getDartType(value.first);
      return 'List<$itemType>';
    }
    if (value is Map) return 'Map<String, dynamic>';
    return 'dynamic';
  }

  static String _camelCase(String str) {
    final parts = str.split('_');
    return parts.first.toLowerCase() +
        parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
  }

  static String _snakeCase(String str) {
    return str.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }
}
