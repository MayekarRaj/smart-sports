import 'package:shared_preferences/shared_preferences.dart';

/// Storage service for managing local data persistence
/// Provides a clean abstraction over SharedPreferences
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  /// Initialize storage service
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  Future<SharedPreferences> get _preferences async {
    await initialize();
    return _prefs!;
  }

  // ==================== String Operations ====================

  /// Save string value
  Future<bool> saveString(String key, String value) async {
    final prefs = await _preferences;
    return await prefs.setString(key, value);
  }

  /// Get string value
  Future<String?> getString(String key) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }

  /// Remove string value
  Future<bool> removeString(String key) async {
    final prefs = await _preferences;
    return await prefs.remove(key);
  }

  // ==================== Integer Operations ====================

  /// Save integer value
  Future<bool> saveInt(String key, int value) async {
    final prefs = await _preferences;
    return await prefs.setInt(key, value);
  }

  /// Get integer value
  Future<int?> getInt(String key) async {
    final prefs = await _preferences;
    return prefs.getInt(key);
  }

  // ==================== Boolean Operations ====================

  /// Save boolean value
  Future<bool> saveBool(String key, bool value) async {
    final prefs = await _preferences;
    return await prefs.setBool(key, value);
  }

  /// Get boolean value
  Future<bool?> getBool(String key) async {
    final prefs = await _preferences;
    return prefs.getBool(key);
  }

  // ==================== List Operations ====================

  /// Save string list
  Future<bool> saveStringList(String key, List<String> value) async {
    final prefs = await _preferences;
    return await prefs.setStringList(key, value);
  }

  /// Get string list
  Future<List<String>?> getStringList(String key) async {
    final prefs = await _preferences;
    return prefs.getStringList(key);
  }

  // ==================== Clear Operations ====================

  /// Clear all stored data
  Future<bool> clearAll() async {
    final prefs = await _preferences;
    return await prefs.clear();
  }

  /// Remove specific key
  Future<bool> remove(String key) async {
    final prefs = await _preferences;
    return await prefs.remove(key);
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    final prefs = await _preferences;
    return prefs.containsKey(key);
  }

  /// Get all keys
  Future<Set<String>> getAllKeys() async {
    final prefs = await _preferences;
    return prefs.getKeys();
  }
}
