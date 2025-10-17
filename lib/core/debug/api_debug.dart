// API Debug Helper
// This file helps debug API issues

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/api_models.dart';

class ApiDebug {
  static Future<void> testSignupAPI() async {
    print('🔍 Testing Signup API...');
    
    final testRequest = SignUpRequest(
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      password: 'password123',
      phone: '1234567890',
    );
    
    final url = ApiEndpoints.getSignUpUrl();
    final headers = ApiConfig.headers;
    final body = json.encode(testRequest.toJson());
    
    print('📤 URL: $url');
    print('📤 Headers: $headers');
    print('📤 Body: $body');
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      
      print('📥 Status Code: ${response.statusCode}');
      print('📥 Response Headers: ${response.headers}');
      print('📥 Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        print('✅ API is working!');
      } else {
        print('❌ API returned error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Network error: $e');
    }
  }
  
  static Future<void> testSignInAPI() async {
    print('🔍 Testing Sign In API...');
    
    final testRequest = SignInRequest(
      email: 'test@example.com',
      password: 'password123',
    );
    
    final url = ApiEndpoints.getSignInUrl();
    final headers = ApiConfig.headers;
    final body = json.encode(testRequest.toJson());
    
    print('📤 URL: $url');
    print('📤 Headers: $headers');
    print('📤 Body: $body');
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      
      print('📥 Status Code: ${response.statusCode}');
      print('📥 Response Headers: ${response.headers}');
      print('📥 Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        print('✅ Sign In API is working!');
      } else {
        print('❌ Sign In API returned error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Network error: $e');
    }
  }
}
