/// Serialization Configuration
/// Centralized configuration for json_serializable
/// 
/// This file contains common serialization settings and conventions
/// used throughout the project

import 'package:json_annotation/json_annotation.dart';

/// Common JsonSerializable configuration
/// Use this as a base for all models
const jsonSerializable = JsonSerializable(
  // Convert field names to snake_case in JSON
  fieldRename: FieldRename.snake,
  
  // Exclude null fields from JSON
  includeIfNull: false,
  
  // Enable explicit toJson methods
  explicitToJson: true,
  
  // Don't check for extra fields (more flexible)
  disallowUnrecognizedKeys: false,
  
  // Handle generic types
  genericArgumentFactories: false,
);

/// Configuration for models with nullable fields
/// Use when you want to include null values
const jsonSerializableWithNulls = JsonSerializable(
  fieldRename: FieldRename.snake,
  includeIfNull: true,
  explicitToJson: true,
  disallowUnrecognizedKeys: false,
);

/// Configuration for request models
/// Use for API request DTOs
const jsonSerializableRequest = JsonSerializable(
  fieldRename: FieldRename.snake,
  includeIfNull: false,
  explicitToJson: true,
  disallowUnrecognizedKeys: false,
);

/// Configuration for response models
/// Use for API response DTOs (more flexible)
const jsonSerializableResponse = JsonSerializable(
  fieldRename: FieldRename.snake,
  includeIfNull: false,
  explicitToJson: true,
  disallowUnrecognizedKeys: true, // Allow extra fields from API
);

