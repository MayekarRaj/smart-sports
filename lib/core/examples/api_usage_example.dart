// API Usage Examples for Smart Sports App
// This file demonstrates how to use the API service

import '../services/api_service.dart';
import '../models/api_models.dart';

class ApiUsageExample {
  final ApiService _apiService = ApiService();

  // Example: Sign in a user
  Future<void> signInExample() async {
    try {
      final request = SignInRequest(
        email: 'user@example.com',
        password: 'password123',
      );

      final response = await _apiService.signIn(request);

      if (response.success) {
        print('Sign in successful!');
        print('User: ${response.data?.user.name}');
        print('Token: ${response.data?.token}');
      } else {
        print('Sign in failed: ${response.message}');
      }
    } catch (e) {
      print('Error during sign in: $e');
    }
  }

  // Example: Get user profile
  Future<void> getProfileExample() async {
    try {
      final response = await _apiService.getProfile(18);

      if (response.success) {
        print('Profile loaded successfully!');
        print('User: ${response.data?.name}');
        print('Email: ${response.data?.email}');
      } else {
        print('Failed to load profile: ${response.message}');
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  // Example: Club registration step 1
  Future<void> clubRegistrationStep1Example() async {
    try {
      final request = ClubSignupStep1Request(
        userId: 20,
        userRole: 'club',
        clubName: 'Global Club',
        noOfUsers: 10,
        isAddressIsSameAsUser: 1,
        addressLine1: '123 MG Road',
        addressLine2: 'Near Metro Station',
        city: 'Bangalore',
        state: 'Karnataka',
        zipcode: '560001',
        country: 'India',
        isContactDetailsIsSameUser: 1,
        officePhoneExt: '001',
        officePhone: '5551234567',
        mobilePhoneExt: '91',
        mobilePhone: '9876543210',
        companyWebsite: 'https://www.globalclub.com',
        sportsIsSameAsUser: 0,
        sportsNames: ['Football', 'Basketball', 'Tennis'],
        operationalDetails: [
          OperationalDetail(
            openDays: 'Weekdays',
            clubStartTime: '09:00',
            clubEndTime: '18:00',
          ),
          OperationalDetail(
            openDays: 'Weekend',
            clubStartTime: '09:00',
            clubEndTime: '18:00',
          ),
        ],
      );

      final response = await _apiService.clubSignupStep1(request);

      if (response.success) {
        print('Club registration step 1 successful!');
        print('Club ID: ${response.data?.clubId}');
      } else {
        print('Club registration step 1 failed: ${response.message}');
      }
    } catch (e) {
      print('Error during club registration step 1: $e');
    }
  }

  // Example: Club registration step 2 (branches)
  Future<void> clubRegistrationStep2Example() async {
    try {
      final request = ClubSignupStep2Request(
        userId: 20,
        clubId: 24,
        branches: [
          ClubBranch(
            clubName: 'Downtown Club Branch',
            numberOfUsers: 30,
            isAddressSameAsUser: 0,
            addressLine1: '123 Downtown Street',
            addressLine2: 'Suite 45',
            city: 'Mumbai',
            state: 'Maharashtra',
            zipCode: '400001',
            country: 'India',
            isContactSameAsUser: 0,
            officePhoneExt: '022',
            officePhone: '1234567890',
            mobilePhoneExt: '+91',
            mobilePhone: '9876543210',
            companyWebsite: 'https://downtownbranch.com',
            operationalDetails: [
              OperationalDetail(
                openDays: 'Weekdays',
                clubStartTime: '09:00',
                clubEndTime: '18:00',
              ),
              OperationalDetail(
                openDays: 'Saturday',
                clubStartTime: '10:00',
                clubEndTime: '14:00',
              ),
            ],
          ),
          ClubBranch(
            clubName: 'Uptown Club Branch',
            numberOfUsers: 20,
            isAddressSameAsUser: 1,
            isContactSameAsUser: 1,
            operationalDetails: [
              OperationalDetail(
                openDays: 'All Days',
                clubStartTime: '08:00',
                clubEndTime: '20:00',
              ),
            ],
          ),
        ],
      );

      final response = await _apiService.clubSignupStep2(request);

      if (response.success) {
        print('Club registration step 2 successful!');
        print('Message: ${response.data?.message}');
      } else {
        print('Club registration step 2 failed: ${response.message}');
      }
    } catch (e) {
      print('Error during club registration step 2: $e');
    }
  }

  // Example: Complete club registration flow
  Future<void> completeClubRegistrationExample() async {
    try {
      // Step 1: Register the main club
      final step1Request = ClubSignupStep1Request(
        userId: 20,
        userRole: 'club',
        clubName: 'Global Club',
        noOfUsers: 10,
        isAddressIsSameAsUser: 1,
        addressLine1: '123 MG Road',
        addressLine2: 'Near Metro Station',
        city: 'Bangalore',
        state: 'Karnataka',
        zipcode: '560001',
        country: 'India',
        isContactDetailsIsSameUser: 1,
        officePhoneExt: '001',
        officePhone: '5551234567',
        mobilePhoneExt: '91',
        mobilePhone: '9876543210',
        companyWebsite: 'https://www.globalclub.com',
        sportsIsSameAsUser: 0,
        sportsNames: ['Football', 'Basketball', 'Tennis'],
        operationalDetails: [
          OperationalDetail(
            openDays: 'Weekdays',
            clubStartTime: '09:00',
            clubEndTime: '18:00',
          ),
        ],
      );

      final step1Response = await _apiService.clubSignupStep1(step1Request);

      if (!step1Response.success) {
        throw Exception('Step 1 failed: ${step1Response.message}');
      }

      // Step 2: Register branches
      final step2Request = ClubSignupStep2Request(
        userId: 20,
        clubId: step1Response.data!.clubId,
        branches: [
          ClubBranch(
            clubName: 'Branch 1',
            numberOfUsers: 15,
            isAddressSameAsUser: 1,
            isContactSameAsUser: 1,
            operationalDetails: [
              OperationalDetail(
                openDays: 'All Days',
                clubStartTime: '08:00',
                clubEndTime: '20:00',
              ),
            ],
          ),
        ],
      );

      final step2Response = await _apiService.clubSignupStep2(step2Request);

      if (step2Response.success) {
        print('Complete club registration successful!');
      } else {
        print('Step 2 failed: ${step2Response.message}');
      }
    } catch (e) {
      print('Error during complete club registration: $e');
    }
  }
}
