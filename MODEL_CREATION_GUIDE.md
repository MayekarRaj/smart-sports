# 📦 Model Creation Guide

## 🎯 Overview

This guide explains how models are created and serialized in the Smart Sports app. Models follow a consistent pattern for JSON serialization.

## 📋 Model Structure

Every model should:
1. Extend or implement `Serializable` (optional but recommended)
2. Have a `fromJson` factory constructor
3. Have a `toJson` method
4. Handle nullable fields properly
5. Handle nested objects and lists

## 📝 Model Template

```dart
import 'package:smart_sports/core/serialization/serializable.dart';
import 'package:smart_sports/core/serialization/json_helpers.dart' as json;

class MyModel implements Serializable {
  final String id;
  final String name;
  final int? count;
  final DateTime createdAt;
  final List<String> tags;
  final NestedModel? nested;

  MyModel({
    required this.id,
    required this.name,
    this.count,
    required this.createdAt,
    required this.tags,
    this.nested,
  });

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      count: json['count'] as int?,
      createdAt: json.parseDate(json['created_at']) ?? DateTime.now(),
      tags: json.parseList<String>(
        json['tags'],
        (item) => item as String,
      ),
      nested: json['nested'] != null
          ? NestedModel.fromJson(json['nested'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'created_at': json.formatDate(createdAt),
      'tags': tags,
      'nested': nested?.toJson(),
    };
  }
}
```

## 🔧 Common Patterns

### Pattern 1: Simple Model
```dart
class SimpleModel {
  final String id;
  final String name;

  SimpleModel({required this.id, required this.name});

  factory SimpleModel.fromJson(Map<String, dynamic> json) {
    return SimpleModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
```

### Pattern 2: Model with Enums
```dart
enum Status { active, inactive, pending }

class ModelWithEnum {
  final String id;
  final Status status;

  ModelWithEnum({required this.id, required this.status});

  factory ModelWithEnum.fromJson(Map<String, dynamic> json) {
    return ModelWithEnum(
      id: json['id'] as String,
      status: json.parseEnum(
        json['status'],
        Status.values,
        (value) => Status.values.firstWhere(
          (e) => e.toString().split('.').last == value,
        ),
      ) ?? Status.pending,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': json.enumToString(status),
    };
  }
}
```

### Pattern 3: Model with Nested Objects
```dart
class ParentModel {
  final String id;
  final ChildModel child;

  ParentModel({required this.id, required this.child});

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'] as String,
      child: ChildModel.fromJson(json['child'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'child': child.toJson(),
    };
  }
}
```

### Pattern 4: Model with Lists
```dart
class ModelWithList {
  final String id;
  final List<ItemModel> items;

  ModelWithList({required this.id, required this.items});

  factory ModelWithList.fromJson(Map<String, dynamic> json) {
    return ModelWithList(
      id: json['id'] as String,
      items: json.parseList<ItemModel>(
        json['items'],
        (item) => ItemModel.fromJson(item),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
```

### Pattern 5: Model with Dates
```dart
class ModelWithDate {
  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ModelWithDate({
    required this.id,
    required this.createdAt,
    this.updatedAt,
  });

  factory ModelWithDate.fromJson(Map<String, dynamic> json) {
    return ModelWithDate(
      id: json['id'] as String,
      createdAt: json.parseDate(json['created_at']) ?? DateTime.now(),
      updatedAt: json.parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': json.formatDate(createdAt),
      'updated_at': json.formatDate(updatedAt),
    };
  }
}
```

## 🎨 Best Practices

1. **Always handle null values** - Use nullable types and null checks
2. **Use type assertions safely** - Use `as?` for safe casting
3. **Provide default values** - Use `??` operator for defaults
4. **Handle parsing errors** - Wrap in try-catch if needed
5. **Match API field names** - Use exact field names from API
6. **Document complex models** - Add comments for clarity

## 🚀 Quick Model Generation

When you provide API responses, I'll automatically:
1. Analyze the JSON structure
2. Generate the model class
3. Add proper fromJson/toJson methods
4. Handle nullable fields
5. Add proper type conversions

Just provide the JSON response and I'll create the model!

## 📚 Example Workflow

**You provide:**
```json
{
  "id": "123",
  "name": "Test",
  "status": "active",
  "created_at": "2025-01-01T00:00:00Z"
}
```

**I generate:**
```dart
class TestModel {
  final String id;
  final String name;
  final String status;
  final DateTime createdAt;

  // ... fromJson/toJson methods
}
```

That's it! Simple and efficient. 🎉

