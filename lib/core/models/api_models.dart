// API Models for Smart Sports App
// Using json_serializable for code generation

import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'api_models.g.dart'; // Generated file

// Authentication Models
@JsonSerializable()
class SignInRequest {
  final String email;
  final String password;

  @JsonKey(name: 'keepMeLoggedIn')
  final String keepMeLoggedIn; // API expects string "true" or "false"

  SignInRequest({
    required this.email,
    required this.password,
    this.keepMeLoggedIn = 'false',
  });

  factory SignInRequest.fromJson(Map<String, dynamic> json) =>
      _$SignInRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignInRequestToJson(this);
}

@JsonSerializable()
class SignUpRequest {
  @JsonKey(name: 'firstname')
  final String firstName;

  @JsonKey(name: 'lastname')
  final String lastName;

  final String email;
  final String password;

  @JsonKey(name: 'sports_names')
  final List<String> sportsNames;

  @JsonKey(name: 'zip_code')
  final String? zipCode;

  final String? city;
  final String? state;
  final String? country;

  @JsonKey(name: 'address_line_1')
  final String? addressLine1;

  @JsonKey(name: 'address_line_2')
  final String? addressLine2;

  @JsonKey(name: 'office_phone_ext')
  final String? officePhoneExt;

  @JsonKey(name: 'office_phone')
  final String? officePhone;

  @JsonKey(name: 'mobile_phone_ext')
  final String? mobilePhoneExt;

  @JsonKey(name: 'mobile_phone')
  final String? mobilePhone;

  @JsonKey(name: 'company_website')
  final String? companyWebsite;

  SignUpRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.sportsNames,
    this.zipCode,
    this.city,
    this.state,
    this.country,
    this.addressLine1,
    this.addressLine2,
    this.officePhoneExt,
    this.officePhone,
    this.mobilePhoneExt,
    this.mobilePhone,
    this.companyWebsite,
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}

@JsonSerializable()
class SignInResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'token_type')
  final String tokenType;

  final SignInUser user;

  SignInResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResponseToJson(this);

  /// Get token for authentication (access_token)
  String get token => accessToken;
}

@JsonSerializable()
class SignInUser {
  @JsonKey(fromJson: _intFromJson)
  final int id;

  final String firstname;

  final String lastname;

  @JsonKey(name: 'company_name')
  final String? companyName;

  @JsonKey(name: 'company_logo')
  final String? companyLogo;

  final String? designation;

  final String? department;

  final String email;

  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;

  @JsonKey(name: 'address_id', fromJson: _nullableIntFromJson)
  final int? addressId;

  @JsonKey(name: 'contact_details_id', fromJson: _nullableIntFromJson)
  final int? contactDetailsId;

  @JsonKey(name: 'sports_names')
  final String sportsNames; // JSON string from API

  @JsonKey(name: 'user_role')
  final String? userRole;

  @JsonKey(name: 'current_step_no', fromJson: _nullableIntFromJson)
  final int? currentStepNo;

  @JsonKey(name: 'subscription_type')
  final String? subscriptionType;

  @JsonKey(name: 'is_active', fromJson: _intFromJson)
  final int isActive;

  @JsonKey(name: 'is_deleted', fromJson: _intFromJson)
  final int isDeleted;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  // Helper functions to convert String to int
  static int _intFromJson(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }

  static int? _nullableIntFromJson(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is num) return value.toInt();
    return null;
  }

  SignInUser({
    required this.id,
    required this.firstname,
    required this.lastname,
    this.companyName,
    this.companyLogo,
    this.designation,
    this.department,
    required this.email,
    this.emailVerifiedAt,
    this.addressId,
    this.contactDetailsId,
    required this.sportsNames,
    this.userRole,
    this.currentStepNo,
    this.subscriptionType,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SignInUser.fromJson(Map<String, dynamic> json) =>
      _$SignInUserFromJson(json);

  Map<String, dynamic> toJson() => _$SignInUserToJson(this);

  /// Get sports names as list (parsed from JSON string)
  List<String> get sportsNamesList {
    try {
      // API returns sports_names as JSON string like "[\"football\", \"basketball\"]"
      // Parse it to List<String>
      final decoded = jsonDecode(sportsNames) as List;
      return decoded.map((e) => e.toString()).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get full name
  String get fullName => '$firstname $lastname';

  /// Convert to UserProfile for consistency
  UserProfile toUserProfile() {
    return UserProfile(
      id: id,
      name: fullName,
      email: email,
      role: userRole,
      phone: null, // Not available in sign-in response
      avatar: companyLogo,
    );
  }
}

@JsonSerializable()
class SignUpResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'token_type')
  final String tokenType;

  @JsonKey(name: 'user_id', fromJson: _intFromJson)
  final int userId;

  final SignUpUser user;

  // Helper function to convert String to int
  static int _intFromJson(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }

  SignUpResponse({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
    required this.user,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);

  /// Get token for authentication (access_token)
  String get token => accessToken;
}

@JsonSerializable()
class SignUpUser {
  @JsonKey(name: 'firstname')
  final String firstName;

  @JsonKey(name: 'lastname')
  final String lastName;

  final String email;

  @JsonKey(name: 'sports_names')
  final String sportsNames; // JSON string from API

  @JsonKey(name: 'is_active', fromJson: _intFromJson)
  final int isActive;

  @JsonKey(name: 'is_deleted', fromJson: _intFromJson)
  final int isDeleted;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(fromJson: _intFromJson)
  final int id;

  // Helper function to convert String to int
  static int _intFromJson(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }

  /// Get sports names as list (parsed from JSON string)
  List<String> get sportsNamesList {
    try {
      // API returns sports_names as JSON string like "[\"football\",\"basketball\"]"
      // Parse it to List<String>
      final decoded = jsonDecode(sportsNames) as List;
      return decoded.map((e) => e.toString()).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get full name
  String get fullName => '$firstName $lastName';

  SignUpUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.sportsNames,
    required this.isActive,
    required this.isDeleted,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory SignUpUser.fromJson(Map<String, dynamic> json) =>
      _$SignUpUserFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpUserToJson(this);
}

@JsonSerializable()
class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? role;
  final String? phone;
  final String? avatar;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.phone,
    this.avatar,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

// Club Registration Models
@JsonSerializable()
class ClubSignupStep1Request {
  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'user_role')
  final String userRole;

  @JsonKey(name: 'club_name')
  final String clubName;

  @JsonKey(name: 'no_of_users')
  final int noOfUsers;

  @JsonKey(name: 'is_address_is_same_as_user')
  final int isAddressIsSameAsUser;

  @JsonKey(name: 'address_line1')
  final String addressLine1;

  @JsonKey(name: 'address_line2')
  final String addressLine2;

  final String city;
  final String state;
  final String zipcode;
  final String country;

  @JsonKey(name: 'is_contact_details_is_same_user')
  final int isContactDetailsIsSameUser;

  @JsonKey(name: 'office_phone_ext')
  final String officePhoneExt;

  @JsonKey(name: 'office_phone')
  final String officePhone;

  @JsonKey(name: 'mobile_phone_ext')
  final String mobilePhoneExt;

  @JsonKey(name: 'mobile_phone')
  final String mobilePhone;

  @JsonKey(name: 'company_website')
  final String companyWebsite;

  @JsonKey(name: 'sports_is_same_as_user')
  final int sportsIsSameAsUser;

  @JsonKey(name: 'sports_names')
  final List<String> sportsNames;

  @JsonKey(name: 'operational_details')
  final List<OperationalDetail> operationalDetails;

  ClubSignupStep1Request({
    required this.userId,
    required this.userRole,
    required this.clubName,
    required this.noOfUsers,
    required this.isAddressIsSameAsUser,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.country,
    required this.isContactDetailsIsSameUser,
    required this.officePhoneExt,
    required this.officePhone,
    required this.mobilePhoneExt,
    required this.mobilePhone,
    required this.companyWebsite,
    required this.sportsIsSameAsUser,
    required this.sportsNames,
    required this.operationalDetails,
  });

  factory ClubSignupStep1Request.fromJson(Map<String, dynamic> json) =>
      _$ClubSignupStep1RequestFromJson(json);

  Map<String, dynamic> toJson() => _$ClubSignupStep1RequestToJson(this);
}

@JsonSerializable()
class ClubSignupStep2Request {
  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'club_id')
  final int clubId;

  final List<ClubBranch> branches;

  ClubSignupStep2Request({
    required this.userId,
    required this.clubId,
    required this.branches,
  });

  factory ClubSignupStep2Request.fromJson(Map<String, dynamic> json) =>
      _$ClubSignupStep2RequestFromJson(json);

  Map<String, dynamic> toJson() => _$ClubSignupStep2RequestToJson(this);
}

@JsonSerializable()
class ClubBranch {
  @JsonKey(name: 'club_name')
  final String clubName;

  @JsonKey(name: 'number_of_users')
  final int numberOfUsers;

  @JsonKey(name: 'is_address_same_as_user')
  final int isAddressSameAsUser;

  @JsonKey(name: 'address_line_1')
  final String? addressLine1;

  @JsonKey(name: 'address_line_2')
  final String? addressLine2;

  final String? city;
  final String? state;

  @JsonKey(name: 'zip_code')
  final String? zipCode;

  final String? country;

  @JsonKey(name: 'is_contact_same_as_user')
  final int isContactSameAsUser;

  @JsonKey(name: 'office_phone_ext')
  final String? officePhoneExt;

  @JsonKey(name: 'office_phone')
  final String? officePhone;

  @JsonKey(name: 'mobile_phone_ext')
  final String? mobilePhoneExt;

  @JsonKey(name: 'mobile_phone')
  final String? mobilePhone;

  @JsonKey(name: 'company_website')
  final String? companyWebsite;

  @JsonKey(name: 'operational_details')
  final List<OperationalDetail> operationalDetails;

  @JsonKey(name: 'sports_names')
  final List<String> sportsNames;

  ClubBranch({
    required this.clubName,
    required this.numberOfUsers,
    required this.isAddressSameAsUser,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    required this.isContactSameAsUser,
    this.officePhoneExt,
    this.officePhone,
    this.mobilePhoneExt,
    this.mobilePhone,
    this.companyWebsite,
    required this.operationalDetails,
    required this.sportsNames,
  });

  factory ClubBranch.fromJson(Map<String, dynamic> json) =>
      _$ClubBranchFromJson(json);

  Map<String, dynamic> toJson() => _$ClubBranchToJson(this);
}

@JsonSerializable()
class OperationalDetail {
  @JsonKey(name: 'open_days')
  final String openDays;

  @JsonKey(name: 'club_start_time')
  final String clubStartTime;

  @JsonKey(name: 'club_end_time')
  final String clubEndTime;

  OperationalDetail({
    required this.openDays,
    required this.clubStartTime,
    required this.clubEndTime,
  });

  factory OperationalDetail.fromJson(Map<String, dynamic> json) =>
      _$OperationalDetailFromJson(json);

  Map<String, dynamic> toJson() => _$OperationalDetailToJson(this);
}

@JsonSerializable()
class ClubSignupResponse {
  @JsonKey(name: 'club_id')
  final int clubId;

  final String message;
  final bool success;

  ClubSignupResponse({
    required this.clubId,
    required this.message,
    required this.success,
  });

  factory ClubSignupResponse.fromJson(Map<String, dynamic> json) =>
      _$ClubSignupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClubSignupResponseToJson(this);
}

// Corporate Registration Models
@JsonSerializable()
class CorporateSignupRequest {
  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'user_role')
  final String userRole;

  @JsonKey(name: 'invoice_type')
  final int invoiceType;

  @JsonKey(name: 'is_allowed_family_members')
  final int isAllowedFamilyMembers;

  @JsonKey(name: 'is_company_address_same_as_signup_address')
  final int isCompanyAddressSameAsSignupAddress;

  @JsonKey(name: 'is_contact_details_same_as_signup_contact_details')
  final int isContactDetailsSameAsSignupContactDetails;

  @JsonKey(name: 'company_address')
  final CorporateAddress? companyAddress;

  @JsonKey(name: 'contact_details')
  final CorporateContactDetails? contactDetails;

  CorporateSignupRequest({
    required this.userId,
    required this.userRole,
    required this.invoiceType,
    required this.isAllowedFamilyMembers,
    required this.isCompanyAddressSameAsSignupAddress,
    required this.isContactDetailsSameAsSignupContactDetails,
    this.companyAddress,
    this.contactDetails,
  });

  factory CorporateSignupRequest.fromJson(Map<String, dynamic> json) =>
      _$CorporateSignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CorporateSignupRequestToJson(this);
}

@JsonSerializable()
class CorporateAddress {
  @JsonKey(name: 'address_line_1')
  final String address1;

  @JsonKey(name: 'address_line_2')
  final String? address2;

  @JsonKey(name: 'address_line_3')
  final String? address3;

  final String city;
  final String state;

  @JsonKey(name: 'zip_code')
  final String zipCode;

  final String country;

  CorporateAddress({
    required this.address1,
    this.address2,
    this.address3,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  factory CorporateAddress.fromJson(Map<String, dynamic> json) =>
      _$CorporateAddressFromJson(json);

  Map<String, dynamic> toJson() => _$CorporateAddressToJson(this);
}

@JsonSerializable()
class CorporateContactDetails {
  final String? designation;
  final String? department;

  @JsonKey(name: 'office_phone_ext')
  final String? officePhoneExt;

  @JsonKey(name: 'office_phone')
  final String? officePhone;

  @JsonKey(name: 'mobile_phone_ext')
  final String? mobilePhoneExt;

  @JsonKey(name: 'mobile_phone')
  final String? mobilePhone;

  @JsonKey(name: 'company_website')
  final String? companyWebsite;

  CorporateContactDetails({
    this.designation,
    this.department,
    this.officePhoneExt,
    this.officePhone,
    this.mobilePhoneExt,
    this.mobilePhone,
    this.companyWebsite,
  });

  factory CorporateContactDetails.fromJson(Map<String, dynamic> json) =>
      _$CorporateContactDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CorporateContactDetailsToJson(this);
}

@JsonSerializable()
class CorporateSignupResponse {
  final int id;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'invoice_type')
  final int invoiceType;

  @JsonKey(name: 'is_allowed_family_members')
  final int isAllowedFamilyMembers;

  @JsonKey(name: 'is_address_is_same_as_user')
  final int isAddressIsSameAsUser;

  @JsonKey(name: 'address_id')
  final int? addressId;

  @JsonKey(name: 'is_contact_details_is_same_user')
  final int isContactDetailsIsSameUser;

  @JsonKey(name: 'contact_details_id')
  final int? contactDetailsId;

  @JsonKey(name: 'is_deleted')
  final int isDeleted;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  CorporateSignupResponse({
    required this.id,
    required this.userId,
    required this.invoiceType,
    required this.isAllowedFamilyMembers,
    required this.isAddressIsSameAsUser,
    this.addressId,
    required this.isContactDetailsIsSameUser,
    this.contactDetailsId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CorporateSignupResponse.fromJson(Map<String, dynamic> json) =>
      _$CorporateSignupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CorporateSignupResponseToJson(this);
}

// Coach Registration Models
@JsonSerializable()
class CoachSignupRequest {
  @JsonKey(name: 'no_of_users')
  final int noOfUsers;

  @JsonKey(name: 'is_address_is_same_as_user')
  final int isAddressIsSameAsUser;

  @JsonKey(name: 'address_line1')
  final String? addressLine1;

  @JsonKey(name: 'address_line2')
  final String? addressLine2;

  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  @JsonKey(name: 'is_contact_details_is_same_user')
  final int isContactDetailsIsSameUser;

  final String? designation;
  final String? department;

  @JsonKey(name: 'office_phone_ext')
  final String? officePhoneExt;

  @JsonKey(name: 'office_phone')
  final String? officePhone;

  @JsonKey(name: 'mobile_phone_ext')
  final String? mobilePhoneExt;

  @JsonKey(name: 'mobile_phone')
  final String? mobilePhone;

  @JsonKey(name: 'company_website')
  final String? companyWebsite;

  final List<CoachClub> clubs;

  CoachSignupRequest({
    required this.noOfUsers,
    required this.isAddressIsSameAsUser,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zipcode,
    this.country,
    required this.isContactDetailsIsSameUser,
    this.designation,
    this.department,
    this.officePhoneExt,
    this.officePhone,
    this.mobilePhoneExt,
    this.mobilePhone,
    this.companyWebsite,
    required this.clubs,
  });

  factory CoachSignupRequest.fromJson(Map<String, dynamic> json) =>
      _$CoachSignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CoachSignupRequestToJson(this);
}

@JsonSerializable()
class CoachClub {
  @JsonKey(name: 'club_id')
  final String clubId;

  @JsonKey(name: 'sport_type')
  final String sportType;

  @JsonKey(name: 'service_days')
  final List<CoachServiceDay> serviceDays;

  CoachClub({
    required this.clubId,
    required this.sportType,
    required this.serviceDays,
  });

  factory CoachClub.fromJson(Map<String, dynamic> json) =>
      _$CoachClubFromJson(json);

  Map<String, dynamic> toJson() => _$CoachClubToJson(this);
}

@JsonSerializable()
class CoachServiceDay {
  final String day;

  @JsonKey(name: 'time_slots_start')
  final String timeSlotsStart;

  @JsonKey(name: 'time_slots_end')
  final String timeSlotsEnd;

  CoachServiceDay({
    required this.day,
    required this.timeSlotsStart,
    required this.timeSlotsEnd,
  });

  factory CoachServiceDay.fromJson(Map<String, dynamic> json) =>
      _$CoachServiceDayFromJson(json);

  Map<String, dynamic> toJson() => _$CoachServiceDayToJson(this);
}

// Freelancer Registration Models
@JsonSerializable()
class FreelancerSignupRequest {
  @JsonKey(name: 'user_role')
  final String userRole;

  @JsonKey(name: 'no_of_users')
  final int noOfUsers;

  @JsonKey(name: 'is_address_is_same_as_user')
  final int isAddressIsSameAsUser;

  @JsonKey(name: 'address_line1')
  final String? addressLine1;

  @JsonKey(name: 'address_line2')
  final String? addressLine2;

  @JsonKey(name: 'address_line3')
  final String? addressLine3;

  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  @JsonKey(name: 'is_contact_details_is_same_user')
  final int isContactDetailsIsSameUser;

  final String? designation;
  final String? department;

  @JsonKey(name: 'office_phone_ext')
  final String? officePhoneExt;

  @JsonKey(name: 'office_phone')
  final String? officePhone;

  @JsonKey(name: 'mobile_phone_ext')
  final String? mobilePhoneExt;

  @JsonKey(name: 'mobile_phone')
  final String? mobilePhone;

  @JsonKey(name: 'company_website')
  final String? companyWebsite;

  FreelancerSignupRequest({
    required this.userRole,
    required this.noOfUsers,
    required this.isAddressIsSameAsUser,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.city,
    this.state,
    this.zipcode,
    this.country,
    required this.isContactDetailsIsSameUser,
    this.designation,
    this.department,
    this.officePhoneExt,
    this.officePhone,
    this.mobilePhoneExt,
    this.mobilePhone,
    this.companyWebsite,
  });

  factory FreelancerSignupRequest.fromJson(Map<String, dynamic> json) =>
      _$FreelancerSignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FreelancerSignupRequestToJson(this);
}

@JsonSerializable()
class FreelancerSignupResponse {
  final bool success;
  final String message;

  @JsonKey(name: 'freelancer_id')
  final int freelancerId;

  FreelancerSignupResponse({
    required this.success,
    required this.message,
    required this.freelancerId,
  });

  factory FreelancerSignupResponse.fromJson(Map<String, dynamic> json) =>
      _$FreelancerSignupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FreelancerSignupResponseToJson(this);
}

// OTP Models
@JsonSerializable()
class SendOtpRequest {
  final String email;

  SendOtpRequest({required this.email});

  factory SendOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$SendOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpRequestToJson(this);
}

@JsonSerializable()
class SendOtpResponse {
  final bool success;
  final String message;
  @JsonKey(name: 'lineNumber')
  final int? lineNumber;

  SendOtpResponse({
    required this.success,
    required this.message,
    this.lineNumber,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpResponseToJson(this);
}

@JsonSerializable()
class VerifyOtpRequest {
  final String email;
  final String otp;

  VerifyOtpRequest({required this.email, required this.otp});

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}

@JsonSerializable()
class VerifyOtpResponse {
  final String message;
  final bool verified;

  VerifyOtpResponse({required this.message, required this.verified});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);
}

@JsonSerializable()
class CheckEmailVerificationRequest {
  final String email;

  CheckEmailVerificationRequest({required this.email});

  factory CheckEmailVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckEmailVerificationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckEmailVerificationRequestToJson(this);
}

@JsonSerializable()
class CheckEmailVerificationResponse {
  final bool verified;
  final String message;

  CheckEmailVerificationResponse({
    required this.verified,
    required this.message,
  });

  factory CheckEmailVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckEmailVerificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckEmailVerificationResponseToJson(this);
}

// Forgot Password Models
@JsonSerializable()
class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

@JsonSerializable()
class ForgotPasswordResponse {
  final String message;
  final bool success;
  final String? token;

  ForgotPasswordResponse({
    required this.message,
    required this.success,
    this.token,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordResponseToJson(this);
}

// Merchandizer Registration Models
@JsonSerializable()
class MerchandizerSignupRequest {
  @JsonKey(name: 'user_role')
  final String userRole;

  @JsonKey(name: 'branch_name')
  final String branchName;

  @JsonKey(name: 'no_of_users')
  final int noOfUsers;

  @JsonKey(name: 'is_address_is_same_as_user')
  final int isAddressIsSameAsUser;

  @JsonKey(name: 'address_line1')
  final String? addressLine1;

  @JsonKey(name: 'address_line2')
  final String? addressLine2;

  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  @JsonKey(name: 'is_contact_details_is_same_user')
  final int isContactDetailsIsSameUser;

  final String? designation;
  final String? department;

  @JsonKey(name: 'office_phone_ext')
  final String? officePhoneExt;

  @JsonKey(name: 'office_phone')
  final String? officePhone;

  @JsonKey(name: 'mobile_phone_ext')
  final String? mobilePhoneExt;

  @JsonKey(name: 'mobile_phone')
  final String? mobilePhone;

  @JsonKey(name: 'company_website')
  final String? companyWebsite;

  MerchandizerSignupRequest({
    required this.userRole,
    required this.branchName,
    required this.noOfUsers,
    required this.isAddressIsSameAsUser,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zipcode,
    this.country,
    required this.isContactDetailsIsSameUser,
    this.designation,
    this.department,
    this.officePhoneExt,
    this.officePhone,
    this.mobilePhoneExt,
    this.mobilePhone,
    this.companyWebsite,
  });

  factory MerchandizerSignupRequest.fromJson(Map<String, dynamic> json) =>
      _$MerchandizerSignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MerchandizerSignupRequestToJson(this);
}

@JsonSerializable()
class MerchandizerSignupResponse {
  final bool success;
  final String message;

  @JsonKey(name: 'merchandizer_id')
  final int merchandizerId;

  MerchandizerSignupResponse({
    required this.success,
    required this.message,
    required this.merchandizerId,
  });

  factory MerchandizerSignupResponse.fromJson(Map<String, dynamic> json) =>
      _$MerchandizerSignupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MerchandizerSignupResponseToJson(this);
}

@JsonSerializable()
class MerchandizerBranch {
  @JsonKey(name: 'branch_name')
  final String branchName;

  @JsonKey(name: 'no_of_users')
  final int noOfUsers;

  @JsonKey(name: 'is_address_same_as_user')
  final int isAddressSameAsUser;

  @JsonKey(name: 'address_line_1')
  final String? addressLine1;

  @JsonKey(name: 'address_line_2')
  final String? addressLine2;

  final String? city;
  final String? state;

  @JsonKey(name: 'zip_code')
  final String? zipCode;

  final String? country;

  @JsonKey(name: 'is_contact_same_as_user')
  final int isContactSameAsUser;

  @JsonKey(name: 'office_phone_ext')
  final String? officePhoneExt;

  @JsonKey(name: 'office_phone')
  final String? officePhone;

  @JsonKey(name: 'mobile_phone_ext')
  final String? mobilePhoneExt;

  @JsonKey(name: 'mobile_phone')
  final String? mobilePhone;

  @JsonKey(name: 'company_website')
  final String? companyWebsite;

  @JsonKey(name: 'sports_names')
  final List<String> sportsNames;

  MerchandizerBranch({
    required this.branchName,
    required this.noOfUsers,
    required this.isAddressSameAsUser,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    required this.isContactSameAsUser,
    this.officePhoneExt,
    this.officePhone,
    this.mobilePhoneExt,
    this.mobilePhone,
    this.companyWebsite,
    required this.sportsNames,
  });

  factory MerchandizerBranch.fromJson(Map<String, dynamic> json) =>
      _$MerchandizerBranchFromJson(json);

  Map<String, dynamic> toJson() => _$MerchandizerBranchToJson(this);
}

@JsonSerializable()
class MerchandizerBranchSignupRequest {
  final List<MerchandizerBranch> branches;

  MerchandizerBranchSignupRequest({required this.branches});

  factory MerchandizerBranchSignupRequest.fromJson(Map<String, dynamic> json) =>
      _$MerchandizerBranchSignupRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MerchandizerBranchSignupRequestToJson(this);
}

@JsonSerializable()
class MerchandizerBranchData {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'parent_id')
  final int parentId;
  @JsonKey(name: 'branch_name')
  final String branchName;
  @JsonKey(name: 'no_of_branches')
  final int? noOfBranches;
  @JsonKey(name: 'no_of_users')
  final int noOfUsers;
  @JsonKey(name: 'is_address_is_same_as_user')
  final int isAddressIsSameAsUser;
  @JsonKey(name: 'address_id')
  final int? addressId;
  @JsonKey(name: 'is_contact_details_is_same_user')
  final int isContactDetailsIsSameUser;
  @JsonKey(name: 'sports_names')
  final String sportsNames;
  @JsonKey(name: 'contact_details_id')
  final int? contactDetailsId;
  @JsonKey(name: 'is_deleted')
  final int isDeleted;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  MerchandizerBranchData({
    required this.id,
    required this.userId,
    required this.parentId,
    required this.branchName,
    this.noOfBranches,
    required this.noOfUsers,
    required this.isAddressIsSameAsUser,
    this.addressId,
    required this.isContactDetailsIsSameUser,
    required this.sportsNames,
    this.contactDetailsId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MerchandizerBranchData.fromJson(Map<String, dynamic> json) =>
      _$MerchandizerBranchDataFromJson(json);

  Map<String, dynamic> toJson() => _$MerchandizerBranchDataToJson(this);
}

@JsonSerializable()
class MerchandizerBranchSignupResponse {
  final bool success;
  final String message;
  final List<MerchandizerBranchData> data;

  MerchandizerBranchSignupResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MerchandizerBranchSignupResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$MerchandizerBranchSignupResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MerchandizerBranchSignupResponseToJson(this);
}

// Paid Services Models
@JsonSerializable()
class PaidService {
  final int id;
  @JsonKey(name: 'user_role')
  final String userRole;
  @JsonKey(name: 'icon_name')
  final String iconName;
  final String name;
  @JsonKey(name: 'description_1')
  final String? description1;
  @JsonKey(name: 'description_2')
  final String? description2;
  final String amount;
  @JsonKey(name: 'is_active')
  final int isActive;
  @JsonKey(name: 'is_deleted')
  final int isDeleted;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  PaidService({
    required this.id,
    required this.userRole,
    required this.iconName,
    required this.name,
    this.description1,
    this.description2,
    required this.amount,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaidService.fromJson(Map<String, dynamic> json) =>
      _$PaidServiceFromJson(json);

  Map<String, dynamic> toJson() => _$PaidServiceToJson(this);

  /// Get amount as double
  double get amountValue => double.tryParse(amount) ?? 0.0;

  /// Check if service is active
  bool get isServiceActive => isActive == 1;
}

@JsonSerializable()
class PaidServicesResponse {
  final bool success;
  final String message;
  final List<PaidService> data;

  PaidServicesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PaidServicesResponse.fromJson(Map<String, dynamic> json) =>
      _$PaidServicesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaidServicesResponseToJson(this);
}

// Save Optional Paid Services Request Model
@JsonSerializable()
class SaveOptionalPaidServicesRequest {
  @JsonKey(name: 'user_role')
  final String userRole;

  @JsonKey(name: 'optional_services_ids')
  final List<int> optionalServicesIds;

  @JsonKey(name: 'club_users_count', includeIfNull: false)
  final int? clubUsersCount;

  @JsonKey(name: 'merchandizer_user_count', includeIfNull: false)
  final int? merchandizerUserCount;

  @JsonKey(name: 'merchandizer_club_ids', includeIfNull: false)
  final List<int>? merchandizerClubIds;

  @JsonKey(name: 'coach_users_count', includeIfNull: false)
  final int? coachUsersCount;

  @JsonKey(name: 'freelancer_users_count', includeIfNull: false)
  final int? freelancerUsersCount;

  @JsonKey(name: 'freelancer_club_ids', includeIfNull: false)
  final List<int>? freelancerClubIds;

  SaveOptionalPaidServicesRequest({
    required this.userRole,
    required this.optionalServicesIds,
    this.clubUsersCount,
    this.merchandizerUserCount,
    this.merchandizerClubIds,
    this.coachUsersCount,
    this.freelancerUsersCount,
    this.freelancerClubIds,
  });

  factory SaveOptionalPaidServicesRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveOptionalPaidServicesRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SaveOptionalPaidServicesRequestToJson(this);
}

@JsonSerializable()
class SaveOptionalPaidServicesResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  SaveOptionalPaidServicesResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SaveOptionalPaidServicesResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$SaveOptionalPaidServicesResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SaveOptionalPaidServicesResponseToJson(this);
}

// Club List Models
@JsonSerializable()
class Club {
  final int id;
  @JsonKey(name: 'club_name')
  final String clubName;
  final List<dynamic> branches;

  Club({required this.id, required this.clubName, required this.branches});

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);

  Map<String, dynamic> toJson() => _$ClubToJson(this);
}

@JsonSerializable()
class ClubListResponse {
  final bool success;
  final String message;
  final List<Club> data;

  ClubListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClubListResponse.fromJson(Map<String, dynamic> json) =>
      _$ClubListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClubListResponseToJson(this);
}

// Merchandizer Branch List Models
@JsonSerializable()
class MerchandizerBranchListItem {
  final int id;
  @JsonKey(name: 'merchandizer_branch_name')
  final String merchandizerBranchName;

  MerchandizerBranchListItem({
    required this.id,
    required this.merchandizerBranchName,
  });

  factory MerchandizerBranchListItem.fromJson(Map<String, dynamic> json) =>
      _$MerchandizerBranchListItemFromJson(json);

  Map<String, dynamic> toJson() => _$MerchandizerBranchListItemToJson(this);
}

@JsonSerializable()
class MerchandizerBranchListResponse {
  final bool success;
  final String message;
  final List<MerchandizerBranchListItem> data;

  MerchandizerBranchListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MerchandizerBranchListResponse.fromJson(Map<String, dynamic> json) =>
      _$MerchandizerBranchListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MerchandizerBranchListResponseToJson(this);
}

// ==================== Sports Models ====================
@JsonSerializable()
class Sport {
  final int id;

  @JsonKey(name: 'sports_name')
  final String sportsName;

  @JsonKey(name: 'image_path')
  final String? imagePath;

  @JsonKey(name: 'is_approve')
  final int isApprove;

  @JsonKey(name: 'is_active')
  final int isActive;

  @JsonKey(name: 'is_deleted')
  final int isDeleted;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  Sport({
    required this.id,
    required this.sportsName,
    this.imagePath,
    required this.isApprove,
    required this.isActive,
    required this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  factory Sport.fromJson(Map<String, dynamic> json) => _$SportFromJson(json);

  Map<String, dynamic> toJson() => _$SportToJson(this);
}

@JsonSerializable()
class SportsListData {
  @JsonKey(name: 'current_page')
  final int currentPage;

  final List<Sport> data;

  @JsonKey(name: 'first_page_url')
  final String? firstPageUrl;

  final int from;

  @JsonKey(name: 'last_page')
  final int lastPage;

  @JsonKey(name: 'last_page_url')
  final String? lastPageUrl;

  final List<dynamic> links;

  @JsonKey(name: 'next_page_url')
  final String? nextPageUrl;

  final String path;

  @JsonKey(name: 'per_page')
  final int perPage;

  @JsonKey(name: 'prev_page_url')
  final String? prevPageUrl;

  final int to;

  final int total;

  SportsListData({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    required this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory SportsListData.fromJson(Map<String, dynamic> json) =>
      _$SportsListDataFromJson(json);

  Map<String, dynamic> toJson() => _$SportsListDataToJson(this);
}

@JsonSerializable()
class SportsListResponse {
  final bool success;
  final String message;
  final List<Sport> data;

  SportsListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SportsListResponse.fromJson(Map<String, dynamic> json) =>
      _$SportsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SportsListResponseToJson(this);
}

// ==================== City Models ====================
@JsonSerializable()
class City {
  final int id;
  final String name;

  @JsonKey(name: 'state_id')
  final int stateId;

  @JsonKey(name: 'city_short_name')
  final String? cityShortName;

  final int status;

  @JsonKey(name: 'created_on')
  final String? createdOn;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  City({
    required this.id,
    required this.name,
    required this.stateId,
    this.cityShortName,
    required this.status,
    this.createdOn,
    this.createdAt,
    this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);
}

@JsonSerializable()
class CitySearchResponse {
  final bool success;

  @JsonKey(name: 'search_name')
  final String searchName;

  final String message;
  final List<City> data;

  CitySearchResponse({
    required this.success,
    required this.searchName,
    required this.message,
    required this.data,
  });

  factory CitySearchResponse.fromJson(Map<String, dynamic> json) =>
      _$CitySearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CitySearchResponseToJson(this);
}

@JsonSerializable()
class CityDetailsData {
  @JsonKey(name: 'city_name')
  final String cityName;

  @JsonKey(name: 'city_short_name')
  final String? cityShortName;

  @JsonKey(name: 'state_id')
  final int stateId;

  final int status;

  @JsonKey(name: 'created_on')
  final String? createdOn;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'state_name')
  final String stateName;

  @JsonKey(name: 'state_short_name')
  final String? stateShortName;

  @JsonKey(name: 'country_id')
  final int countryId;

  @JsonKey(name: 'country_name')
  final String countryName;

  @JsonKey(name: 'country_short_name')
  final String? countryShortName;

  @JsonKey(name: 'country_currency')
  final String countryCurrency;

  @JsonKey(name: 'currency_symbol')
  final String currencySymbol;

  CityDetailsData({
    required this.cityName,
    this.cityShortName,
    required this.stateId,
    required this.status,
    this.createdOn,
    this.createdAt,
    this.updatedAt,
    required this.stateName,
    this.stateShortName,
    required this.countryId,
    required this.countryName,
    this.countryShortName,
    required this.countryCurrency,
    required this.currencySymbol,
  });

  factory CityDetailsData.fromJson(Map<String, dynamic> json) =>
      _$CityDetailsDataFromJson(json);

  Map<String, dynamic> toJson() => _$CityDetailsDataToJson(this);
}

@JsonSerializable()
class CityDetailsResponse {
  final bool success;
  final CityDetailsData data;

  CityDetailsResponse({required this.success, required this.data});

  factory CityDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$CityDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CityDetailsResponseToJson(this);
}

// ==================== Phone Code Models ====================
@JsonSerializable()
class PhoneCode {
  final int id;

  @JsonKey(name: 'country_name')
  final String countryName;

  @JsonKey(name: 'country_short_name')
  final String? countryShortName;

  final int phonecode;

  PhoneCode({
    required this.id,
    required this.countryName,
    this.countryShortName,
    required this.phonecode,
  });

  factory PhoneCode.fromJson(Map<String, dynamic> json) =>
      _$PhoneCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneCodeToJson(this);
}

@JsonSerializable()
class PhoneCodeResponse {
  final bool success;
  final String message;
  final List<PhoneCode> data;

  PhoneCodeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PhoneCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$PhoneCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneCodeResponseToJson(this);
}

// ==================== Coach Experience Level Models ====================
@JsonSerializable()
class MstCoachExperienceLevel {
  final int id;
  final String name;

  @JsonKey(name: 'is_active')
  final int isActive;

  @JsonKey(name: 'is_deleted')
  final int isDeleted;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  MstCoachExperienceLevel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory MstCoachExperienceLevel.fromJson(Map<String, dynamic> json) =>
      _$MstCoachExperienceLevelFromJson(json);

  Map<String, dynamic> toJson() => _$MstCoachExperienceLevelToJson(this);
}

@JsonSerializable()
class CoachExperienceLevelListData {
  @JsonKey(name: 'current_page')
  final int currentPage;

  final List<MstCoachExperienceLevel> data;

  @JsonKey(name: 'first_page_url')
  final String? firstPageUrl;

  final int from;

  @JsonKey(name: 'last_page')
  final int lastPage;

  @JsonKey(name: 'last_page_url')
  final String? lastPageUrl;

  final List<dynamic> links;

  @JsonKey(name: 'next_page_url')
  final String? nextPageUrl;

  final String path;

  @JsonKey(name: 'per_page')
  final int perPage;

  @JsonKey(name: 'prev_page_url')
  final String? prevPageUrl;

  final int to;

  final int total;

  CoachExperienceLevelListData({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    required this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory CoachExperienceLevelListData.fromJson(Map<String, dynamic> json) =>
      _$CoachExperienceLevelListDataFromJson(json);

  Map<String, dynamic> toJson() => _$CoachExperienceLevelListDataToJson(this);
}

@JsonSerializable()
class CoachExperienceLevelListResponse {
  final bool success;
  final String message;
  final CoachExperienceLevelListData data;

  CoachExperienceLevelListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CoachExperienceLevelListResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CoachExperienceLevelListResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CoachExperienceLevelListResponseToJson(this);
}

// ==================== Club Days Models ====================
@JsonSerializable()
class MstClubDay {
  final int id;
  final String name;

  @JsonKey(name: 'is_active')
  final int isActive;

  @JsonKey(name: 'is_deleted')
  final int isDeleted;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  MstClubDay({
    required this.id,
    required this.name,
    required this.isActive,
    required this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory MstClubDay.fromJson(Map<String, dynamic> json) =>
      _$MstClubDayFromJson(json);

  Map<String, dynamic> toJson() => _$MstClubDayToJson(this);
}

@JsonSerializable()
class ClubDaysListData {
  @JsonKey(name: 'current_page')
  final int currentPage;

  final List<MstClubDay> data;

  @JsonKey(name: 'first_page_url')
  final String? firstPageUrl;

  final int from;

  @JsonKey(name: 'last_page')
  final int lastPage;

  @JsonKey(name: 'last_page_url')
  final String? lastPageUrl;

  final List<dynamic> links;

  @JsonKey(name: 'next_page_url')
  final String? nextPageUrl;

  final String path;

  @JsonKey(name: 'per_page')
  final int perPage;

  @JsonKey(name: 'prev_page_url')
  final String? prevPageUrl;

  final int to;

  final int total;

  ClubDaysListData({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    required this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory ClubDaysListData.fromJson(Map<String, dynamic> json) =>
      _$ClubDaysListDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClubDaysListDataToJson(this);
}

@JsonSerializable()
class ClubDaysListResponse {
  final bool success;
  final String message;
  final ClubDaysListData data;

  ClubDaysListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClubDaysListResponse.fromJson(Map<String, dynamic> json) =>
      _$ClubDaysListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClubDaysListResponseToJson(this);
}

// ==================== Stripe Payment Models ====================
@JsonSerializable()
class StripeSetupIntentResponse {
  final bool success;

  @JsonKey(name: 'clientSecret')
  final String clientSecret;

  @JsonKey(name: 'customerId')
  final String customerId;

  StripeSetupIntentResponse({
    required this.success,
    required this.clientSecret,
    required this.customerId,
  });

  factory StripeSetupIntentResponse.fromJson(Map<String, dynamic> json) =>
      _$StripeSetupIntentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StripeSetupIntentResponseToJson(this);
}

@JsonSerializable()
class StripeCreateSubscriptionRequest {
  @JsonKey(name: 'stripe_payment_method_id')
  final String stripePaymentMethodId;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  // Optional: Subscription items if backend needs them
  // The backend should ideally get items from saved services, but we can include if needed
  @JsonKey(name: 'items', includeIfNull: false)
  final List<Map<String, dynamic>>? items;

  StripeCreateSubscriptionRequest({
    required this.stripePaymentMethodId,
    required this.paymentMethod,
    this.items,
  });

  factory StripeCreateSubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$StripeCreateSubscriptionRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$StripeCreateSubscriptionRequestToJson(this);
}

@JsonSerializable()
class StripeCreateSubscriptionResponse {
  final bool success;
  final String message;

  @JsonKey(name: 'clientSecret', includeIfNull: false)
  final String? clientSecret; // For SCA if required

  @JsonKey(name: 'subscription_id', includeIfNull: false)
  final String? subscriptionId;

  @JsonKey(name: 'subscription_status', includeIfNull: false)
  final String? subscriptionStatus;

  StripeCreateSubscriptionResponse({
    required this.success,
    required this.message,
    this.clientSecret,
    this.subscriptionId,
    this.subscriptionStatus,
  });

  factory StripeCreateSubscriptionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$StripeCreateSubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$StripeCreateSubscriptionResponseToJson(this);
}

// Save Payment Information Request
// Note: This is used for multipart/form-data, so we don't use @JsonSerializable
// Instead, we'll build the form data manually in the repository
class SavePaymentInformationRequest {
  final String paymentMethod; // "Bank Transfer" | "Stripe" | "Paypal"
  final String? referenceNumber; // Required only for Bank Transfer
  final String? stripePaymentMethodId; // Required only for Stripe
  final String? paymentReceiptImagePath; // File path for Bank Transfer receipt
  final String? subscriptionId; // Required only when Add Club or Branch

  SavePaymentInformationRequest({
    required this.paymentMethod,
    this.referenceNumber,
    this.stripePaymentMethodId,
    this.paymentReceiptImagePath,
    this.subscriptionId,
  });

  /// Validate required fields based on payment method
  /// Throws [Exception] if validation fails
  void validate() {
    if (paymentMethod == 'Bank Transfer') {
      if (referenceNumber == null || referenceNumber!.isEmpty) {
        throw Exception('Reference number is required for Bank Transfer');
      }
      if (paymentReceiptImagePath == null || paymentReceiptImagePath!.isEmpty) {
        throw Exception('Payment receipt image is required for Bank Transfer');
      }
    } else if (paymentMethod == 'Stripe') {
      if (stripePaymentMethodId == null || stripePaymentMethodId!.isEmpty) {
        throw Exception('Stripe payment method ID is required for Stripe');
      }
    }
    // Note: PayPal validation will be added later
  }

  /// Convert to form fields map (excluding file)
  Map<String, String> toFormFields() {
    final fields = <String, String>{'payment_method': paymentMethod};

    if (referenceNumber != null && referenceNumber!.isNotEmpty) {
      fields['reference_number'] = referenceNumber!;
    }

    if (stripePaymentMethodId != null && stripePaymentMethodId!.isNotEmpty) {
      fields['stripe_payment_method_id'] = stripePaymentMethodId!;
    }

    if (subscriptionId != null && subscriptionId!.isNotEmpty) {
      fields['subscription_id'] = subscriptionId!;
    }

    return fields;
  }
}

// ==================== Site Settings Models ====================
@JsonSerializable()
class SiteSettingResponse {
  final bool success;
  final String message;
  final SiteSettingData data;

  SiteSettingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SiteSettingResponse.fromJson(Map<String, dynamic> json) =>
      _$SiteSettingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SiteSettingResponseToJson(this);
}

@JsonSerializable()
class SiteSettingData {
  final int id;

  @JsonKey(name: 'base_url')
  final String? baseUrl;

  @JsonKey(name: 'applicable_currency')
  final String? applicableCurrency;

  // Stripe Settings
  @JsonKey(name: 'stripe_api_key')
  final String? stripeApiKey; // Publishable Key

  @JsonKey(name: 'stripe_secret_key')
  final String? stripeSecretKey;

  @JsonKey(name: 'stripe_is_enabled')
  final int? stripeIsEnabled;

  // PayPal Settings
  @JsonKey(name: 'paypal_id')
  final String? paypalClientId; // Maps to paypal_id from API

  @JsonKey(name: 'paypal_secret_key')
  final String? paypalSecretKey;

  @JsonKey(name: 'paypal_is_enabled')
  final int? paypalIsEnabled;

  @JsonKey(name: 'paypal_url')
  final String? paypalUrl;

  // Bank Transfer Settings
  @JsonKey(name: 'bank_transfer_account_name')
  final String? bankAccountName;

  @JsonKey(name: 'bank_transfer_bank_name')
  final String? bankName;

  @JsonKey(name: 'bank_transfer_branch_name')
  final String? bankBranchName;

  @JsonKey(name: 'bank_transfer_account_type')
  final String? bankAccountType;

  @JsonKey(name: 'bank_transfer_swift_code')
  final String? bankSwiftCode;

  @JsonKey(name: 'bank_transfer_ifsc_code')
  final String? bankIfscCode;

  @JsonKey(name: 'bank_transfer_account_number')
  final String? bankAccountNumber;

  @JsonKey(name: 'bank_transfer_is_enabled')
  final int? bankTransferIsEnabled;

  SiteSettingData({
    required this.id,
    this.baseUrl,
    this.applicableCurrency,
    this.stripeApiKey,
    this.stripeSecretKey,
    this.stripeIsEnabled,
    this.paypalClientId,
    this.paypalSecretKey,
    this.paypalIsEnabled,
    this.paypalUrl,
    this.bankAccountName,
    this.bankName,
    this.bankBranchName,
    this.bankAccountType,
    this.bankSwiftCode,
    this.bankIfscCode,
    this.bankAccountNumber,
    this.bankTransferIsEnabled,
  });

  factory SiteSettingData.fromJson(Map<String, dynamic> json) =>
      _$SiteSettingDataFromJson(json);

  Map<String, dynamic> toJson() => _$SiteSettingDataToJson(this);
}

@JsonSerializable()
class ClubOperationalDetail {
  @JsonKey(name: 'open_days')
  final String openDays;

  @JsonKey(name: 'club_start_time')
  final String clubStartTime;

  @JsonKey(name: 'club_end_time')
  final String clubEndTime;

  ClubOperationalDetail({
    required this.openDays,
    required this.clubStartTime,
    required this.clubEndTime,
  });

  factory ClubOperationalDetail.fromJson(Map<String, dynamic> json) =>
      _$ClubOperationalDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ClubOperationalDetailToJson(this);
}

@JsonSerializable()
class ClubSignupRequest {
  @JsonKey(name: 'club_name')
  final String clubName;

  @JsonKey(name: 'no_of_users')
  final int noOfUsers;

  @JsonKey(name: 'is_address_is_same_as_user')
  final int isAddressSameAsUser;

  @JsonKey(name: 'address_line1')
  final String? addressLine1;

  @JsonKey(name: 'address_line2')
  final String? addressLine2;

  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  @JsonKey(name: 'is_contact_details_is_same_user')
  final int isContactDetailsSameAsUser;

  final String? designation;
  final String? department;

  @JsonKey(name: 'office_phone_ext')
  final String? officePhoneExt;

  @JsonKey(name: 'office_phone')
  final String? officePhone;

  @JsonKey(name: 'mobile_phone_ext')
  final String? mobilePhoneExt;

  @JsonKey(name: 'mobile_phone')
  final String? mobilePhone;

  @JsonKey(name: 'company_website')
  final String? companyWebsite;

  @JsonKey(name: 'sports_is_same_as_user')
  final int sportsIsSameAsUser;

  @JsonKey(name: 'sports_names')
  final List<String> sportsNames;

  @JsonKey(name: 'operational_details')
  final List<ClubOperationalDetail> operationalDetails;

  @JsonKey(
    name: 'no_of_branches',
  ) // Kept based on previous assumption, though user payload didn't explicitly show it, it might still be needed or ignored.
  final String? noOfBranches;

  ClubSignupRequest({
    required this.clubName,
    required this.noOfUsers,
    required this.isAddressSameAsUser,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zipcode,
    this.country,
    required this.isContactDetailsSameAsUser,
    this.designation,
    this.department,
    this.officePhoneExt,
    this.officePhone,
    this.mobilePhoneExt,
    this.mobilePhone,
    this.companyWebsite,
    required this.sportsIsSameAsUser,
    required this.sportsNames,
    required this.operationalDetails,
    this.noOfBranches,
  });

  Map<String, dynamic> toJson() => _$ClubSignupRequestToJson(this);
}

@JsonSerializable()
class ClubBranchSignupRequest {
  @JsonKey(name: 'club_id')
  final int clubId;

  @JsonKey(name: 'branch_name')
  final String branchName;

  @JsonKey(name: 'no_of_users')
  final int noOfUsers;

  @JsonKey(name: 'is_address_is_same_as_user')
  final int isAddressSameAsUser;

  @JsonKey(name: 'address_line1')
  final String? addressLine1;

  @JsonKey(name: 'address_line2')
  final String? addressLine2;

  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  @JsonKey(name: 'is_contact_details_is_same_user')
  final int isContactDetailsSameAsUser;

  final String? designation;
  final String? department;

  @JsonKey(name: 'office_phone_ext')
  final String? officePhoneExt;

  @JsonKey(name: 'office_phone')
  final String? officePhone;

  @JsonKey(name: 'mobile_phone_ext')
  final String? mobilePhoneExt;

  @JsonKey(name: 'mobile_phone')
  final String? mobilePhone;

  @JsonKey(name: 'company_website')
  final String? companyWebsite;

  @JsonKey(name: 'sports_is_same_as_user')
  final int sportsIsSameAsUser;

  @JsonKey(name: 'sports_names')
  final List<String> sportsNames;

  @JsonKey(name: 'operational_details')
  final List<ClubOperationalDetail> operationalDetails;

  ClubBranchSignupRequest({
    required this.clubId,
    required this.branchName,
    required this.noOfUsers,
    required this.isAddressSameAsUser,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zipcode,
    this.country,
    required this.isContactDetailsSameAsUser,
    this.designation,
    this.department,
    this.officePhoneExt,
    this.officePhone,
    this.mobilePhoneExt,
    this.mobilePhone,
    this.companyWebsite,
    required this.sportsIsSameAsUser,
    required this.sportsNames,
    required this.operationalDetails,
  });

  Map<String, dynamic> toJson() => _$ClubBranchSignupRequestToJson(this);
}

// ==================== Membership Age Groups ====================

class MstMembershipAgeGroup {
  final int id;
  final String name;
  final int isActive;
  final int isDeleted;
  final String createdAt;
  final String updatedAt;

  MstMembershipAgeGroup({
    required this.id,
    required this.name,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MstMembershipAgeGroup.fromJson(Map<String, dynamic> json) {
    return MstMembershipAgeGroup(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      isActive: json['is_active'] is int
          ? json['is_active']
          : int.tryParse(json['is_active']?.toString() ?? '0') ?? 0,
      isDeleted: json['is_deleted'] is int
          ? json['is_deleted']
          : int.tryParse(json['is_deleted']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class MstMembershipAgeGroupListResponse {
  final int currentPage;
  final List<MstMembershipAgeGroup> data;
  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  MstMembershipAgeGroupListResponse({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory MstMembershipAgeGroupListResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    // Handle nested 'data' field structure which is common in Laravel pagination
    final paginationData = json['data'] is Map<String, dynamic>
        ? json['data']
        : json;

    return MstMembershipAgeGroupListResponse(
      currentPage: paginationData['current_page'] ?? 1,
      data:
          (paginationData['data'] as List<dynamic>?)
              ?.map(
                (e) =>
                    MstMembershipAgeGroup.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      firstPageUrl: paginationData['first_page_url'],
      from: paginationData['from'],
      lastPage: paginationData['last_page'] ?? 1,
      lastPageUrl: paginationData['last_page_url'],
      nextPageUrl: paginationData['next_page_url'],
      path: paginationData['path'],
      perPage: paginationData['per_page'] ?? 10,
      prevPageUrl: paginationData['prev_page_url'],
      to: paginationData['to'],
      total: paginationData['total'] ?? 0,
    );
  }
}
// ==================== Member Registration Models ====================

@JsonSerializable()
class PracticePlanRequest {
  @JsonKey(name: 'practice_day')
  final String practiceDay;

  @JsonKey(name: 'practice_start_time')
  final String practiceStartTime;

  @JsonKey(name: 'practice_end_time')
  final String practiceEndTime;

  PracticePlanRequest({
    required this.practiceDay,
    required this.practiceStartTime,
    required this.practiceEndTime,
  });

  factory PracticePlanRequest.fromJson(Map<String, dynamic> json) =>
      _$PracticePlanRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PracticePlanRequestToJson(this);
}

@JsonSerializable()
class MemberRoleSignupRequest {
  @JsonKey(name: 'preferred_club')
  final List<int> preferredClub;

  @JsonKey(name: 'is_employer_support_health_benefits')
  final int isEmployerSupportHealthBenefits;

  @JsonKey(name: 'hr_firstname')
  final String? hrFirstname;

  @JsonKey(name: 'hr_lastname')
  final String? hrLastname;

  @JsonKey(name: 'hr_emailid')
  final String? hrEmailid;

  @JsonKey(name: 'employer_name')
  final String? employerName;

  @JsonKey(name: 'hr_designation')
  final String? hrDesignation;

  @JsonKey(name: 'hr_department')
  final String? hrDepartment;

  final String? designation;
  final String? department;

  @JsonKey(name: 'office_phone_ext')
  final String? officePhoneExt;

  @JsonKey(name: 'office_phone')
  final String? officePhone;

  @JsonKey(name: 'mobile_phone_ext')
  final String? mobilePhoneExt;

  @JsonKey(name: 'mobile_phone')
  final String? mobilePhone;

  @JsonKey(name: 'company_website')
  final String? companyWebsite;

  @JsonKey(name: 'practice_plans')
  final List<PracticePlanRequest> practicePlans;

  MemberRoleSignupRequest({
    required this.preferredClub,
    required this.isEmployerSupportHealthBenefits,
    this.hrFirstname,
    this.hrLastname,
    this.hrEmailid,
    this.employerName,
    this.hrDesignation,
    this.hrDepartment,
    this.designation,
    this.department,
    this.officePhoneExt,
    this.officePhone,
    this.mobilePhoneExt,
    this.mobilePhone,
    this.companyWebsite,
    required this.practicePlans,
  });

  factory MemberRoleSignupRequest.fromJson(Map<String, dynamic> json) =>
      _$MemberRoleSignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MemberRoleSignupRequestToJson(this);
}

@JsonSerializable()
class FamilyMemberRequest {
  final String firstname;
  final String lastname;
  final String email;
  final String dob;
  final String gender;

  @JsonKey(name: 'designation')
  final String? designation;

  @JsonKey(name: 'department')
  final String? department;

  @JsonKey(name: 'mobile_phone_ext')
  final String? mobilePhoneExt;

  @JsonKey(name: 'mobile_phone')
  final String? mobilePhone;

  @JsonKey(name: 'office_phone_ext')
  final String? officePhoneExt;

  @JsonKey(name: 'office_phone')
  final String? officePhone;

  @JsonKey(name: 'membership_type')
  final String membershipType;

  @JsonKey(name: 'sports_interested_in')
  final List<String> sportsInterestedIn;

  @JsonKey(name: 'is_address_is_same_as_user')
  final int isAddressSameAsUser;

  @JsonKey(name: 'zip_code')
  final String? zipCode;
  final String? city;
  final String? state;
  final String? country;

  @JsonKey(name: 'address_line_1')
  final String? addressLine1;

  @JsonKey(name: 'address_line_2')
  final String? addressLine2;

  @JsonKey(name: 'address_line_3')
  final String? addressLine3;

  @JsonKey(name: 'is_practice_plan_same_main_member')
  final int isPracticePlanSameAsMainMember;

  @JsonKey(name: 'practice_plans')
  final List<PracticePlanRequest>? practicePlans;

  @JsonKey(name: 'is_preferred_clubs_same_main_member')
  final int isPreferredClubsSameAsMainMember;

  @JsonKey(name: 'preferred_club')
  final List<int>? preferredClub;

  FamilyMemberRequest({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.dob,
    required this.gender,
    this.designation,
    this.department,
    this.mobilePhoneExt,
    this.mobilePhone,
    this.officePhoneExt,
    this.officePhone,
    required this.membershipType,
    required this.sportsInterestedIn,
    required this.isAddressSameAsUser,
    this.zipCode,
    this.city,
    this.state,
    this.country,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    required this.isPracticePlanSameAsMainMember,
    this.practicePlans,
    required this.isPreferredClubsSameAsMainMember,
    this.preferredClub,
  });

  factory FamilyMemberRequest.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyMemberRequestToJson(this);
}

@JsonSerializable()
class FamilyMemberSignupRequest {
  @JsonKey(name: 'family_members')
  final List<FamilyMemberRequest> familyMembers;

  FamilyMemberSignupRequest({required this.familyMembers});

  factory FamilyMemberSignupRequest.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberSignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyMemberSignupRequestToJson(this);
}

@JsonSerializable()
class ChooseMembershipTypeRequest {
  @JsonKey(name: 'membership_type')
  final String membershipType;

  ChooseMembershipTypeRequest({required this.membershipType});

  factory ChooseMembershipTypeRequest.fromJson(Map<String, dynamic> json) =>
      _$ChooseMembershipTypeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChooseMembershipTypeRequestToJson(this);
}
