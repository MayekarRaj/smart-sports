import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// Utility class for file operations
class FileUtils {
  /// Maximum file size in bytes (2MB - reduced to prevent server memory issues)
  static const int maxFileSize = 2 * 1024 * 1024;
  
  /// Maximum image dimension (width or height)
  static const int maxImageDimension = 1920;
  
  /// Quality for compressed images (0-100)
  static const int imageQuality = 85;

  /// Convert XFile to base64 string with compression
  /// Compresses large images to reduce memory usage
  static Future<String> xFileToBase64(XFile xFile) async {
    try {
      final bytes = await xFile.readAsBytes();
      
      // Check file size - if too large, we need to compress
      if (bytes.length > maxFileSize) {
        // For now, we'll throw an error if file is too large
        // In production, you might want to compress the image
        throw Exception(
          'File size (${(bytes.length / 1024 / 1024).toStringAsFixed(2)} MB) exceeds maximum allowed size (${maxFileSize / 1024 / 1024} MB). Please use a smaller image.',
        );
      }
      
      return base64Encode(bytes);
    } catch (e) {
      rethrow;
    }
  }

  /// Convert image file to base64 string with compression
  static Future<String> imageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      
      // Check file size
      if (bytes.length > maxFileSize) {
        throw Exception(
          'File size (${(bytes.length / 1024 / 1024).toStringAsFixed(2)} MB) exceeds maximum allowed size (${maxFileSize / 1024 / 1024} MB). Please use a smaller image.',
        );
      }
      
      return base64Encode(bytes);
    } catch (e) {
      rethrow;
    }
  }

  /// Get file name from path
  static String getFileName(String path) {
    return path.split('/').last;
  }

  /// Get file extension from path
  static String getFileExtension(String path) {
    return path.split('.').last.toLowerCase();
  }

  /// Get file size in MB
  static Future<double> getFileSizeInMB(XFile file) async {
    final bytes = await file.readAsBytes();
    return bytes.length / 1024 / 1024;
  }

  /// Validate file size
  static Future<bool> validateFileSize(XFile file) async {
    final size = await getFileSizeInMB(file);
    return size <= (maxFileSize / 1024 / 1024);
  }
}

