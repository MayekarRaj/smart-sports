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
  
  @JsonKey(name: 'address_id')
  final int? addressId;
  
  @JsonKey(name: 'contact_details_id')
  final int? contactDetailsId;
  
  @JsonKey(name: 'sports_names')
  final String sportsNames; // JSON string from API
  
  @JsonKey(name: 'user_role')
  final String? userRole;
  
  @JsonKey(name: 'current_step_no')
  final int? currentStepNo;
  
  @JsonKey(name: 'subscription_type')
  final String? subscriptionType;
  
  @JsonKey(name: 'is_active')
  final int isActive;
  
  @JsonKey(name: 'is_deleted')
  final int isDeleted;
  
  @JsonKey(name: 'created_at')
  final String createdAt;
  
  @JsonKey(name: 'updated_at')
  final String updatedAt;

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
  
  @JsonKey(name: 'user_id')
  final int userId;
  
  final SignUpUser user;

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
  
  @JsonKey(name: 'is_active')
  final int isActive;
  
  @JsonKey(name: 'is_deleted')
  final int isDeleted;
  
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  
  @JsonKey(name: 'created_at')
  final String createdAt;
  
  final int id;
  
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
  final String address1;
  
  @JsonKey(name: 'address2')
  final String? address2;
  
  @JsonKey(name: 'address3')
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
  
  @JsonKey(name: 'experience_levels')
  final List<CoachExperienceLevel> experienceLevels;

  CoachSignupRequest({
    required this.userRole,
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
    required this.experienceLevels,
  });

  factory CoachSignupRequest.fromJson(Map<String, dynamic> json) =>
      _$CoachSignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CoachSignupRequestToJson(this);
}

@JsonSerializable()
class CoachClub {
  @JsonKey(name: 'club_name')
  final String clubName;
  
  @JsonKey(name: 'sport_type')
  final String sportType;
  
  @JsonKey(name: 'service_days')
  final List<CoachServiceDay> serviceDays;

  CoachClub({
    required this.clubName,
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

@JsonSerializable()
class CoachExperienceLevel {
  @JsonKey(name: 'exp_level_name')
  final String expLevelName;
  
  @JsonKey(name: 'certificate_name')
  final String certificateName;
  
  @JsonKey(name: 'certificate_base64')
  final String certificateBase64;

  CoachExperienceLevel({
    required this.expLevelName,
    required this.certificateName,
    required this.certificateBase64,
  });

  factory CoachExperienceLevel.fromJson(Map<String, dynamic> json) =>
      _$CoachExperienceLevelFromJson(json);

  Map<String, dynamic> toJson() => _$CoachExperienceLevelToJson(this);
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

  VerifyOtpRequest({
    required this.email,
    required this.otp,
  });

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}

@JsonSerializable()
class VerifyOtpResponse {
  final String message;
  final bool verified;

  VerifyOtpResponse({
    required this.message,
    required this.verified,
  });

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
  
  final String? city;
  final String? state;
  
  @JsonKey(name: 'zip_code')
  final String? zipCode;
  
  final String? country;
  
  @JsonKey(name: 'is_contact_same_as_user')
  final int isContactSameAsUser;
  
  @JsonKey(name: 'office_phone')
  final String? officePhone;
  
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
    this.city,
    this.state,
    this.zipCode,
    this.country,
    required this.isContactSameAsUser,
    this.officePhone,
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

  Map<String, dynamic> toJson() => _$MerchandizerBranchSignupRequestToJson(this);
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

  factory MerchandizerBranchSignupResponse.fromJson(Map<String, dynamic> json) =>
      _$MerchandizerBranchSignupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MerchandizerBranchSignupResponseToJson(this);
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
  final String description1;
  @JsonKey(name: 'description_2')
  final String description2;
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
    required this.description1,
    required this.description2,
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

// Club List Models
@JsonSerializable()
class Club {
  final int id;
  @JsonKey(name: 'club_name')
  final String clubName;
  final List<dynamic> branches;

  Club({
    required this.id,
    required this.clubName,
    required this.branches,
  });

  factory Club.fromJson(Map<String, dynamic> json) =>
      _$ClubFromJson(json);

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

// Club Signup Models
@JsonSerializable()
class ClubSignupRequest {
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
  final String designation;
  final String department;
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
  final List<ClubOperationalDetail> operationalDetails;

  ClubSignupRequest({
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
    required this.designation,
    required this.department,
    required this.officePhoneExt,
    required this.officePhone,
    required this.mobilePhoneExt,
    required this.mobilePhone,
    required this.companyWebsite,
    required this.sportsIsSameAsUser,
    required this.sportsNames,
    required this.operationalDetails,
  });

  factory ClubSignupRequest.fromJson(Map<String, dynamic> json) =>
      _$ClubSignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ClubSignupRequestToJson(this);
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
class ClubSignupResponse {
  final bool success;
  final String message;
  @JsonKey(name: 'club_id')
  final int clubId;

  ClubSignupResponse({
    required this.success,
    required this.message,
    required this.clubId,
  });

  factory ClubSignupResponse.fromJson(Map<String, dynamic> json) =>
      _$ClubSignupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClubSignupResponseToJson(this);
}

// Club Branch Signup Models
@JsonSerializable()
class ClubBranchSignupRequest {
  final List<ClubBranchData> branches;

  ClubBranchSignupRequest({
    required this.branches,
  });

  factory ClubBranchSignupRequest.fromJson(Map<String, dynamic> json) =>
      _$ClubBranchSignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ClubBranchSignupRequestToJson(this);
}

@JsonSerializable()
class ClubBranchData {
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
  @JsonKey(name: 'operational_details')
  final List<ClubOperationalDetail> operationalDetails;

  ClubBranchData({
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
    this.designation,
    this.department,
    this.officePhoneExt,
    this.officePhone,
    this.mobilePhoneExt,
    this.mobilePhone,
    this.companyWebsite,
    required this.operationalDetails,
  });

  factory ClubBranchData.fromJson(Map<String, dynamic> json) =>
      _$ClubBranchDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClubBranchDataToJson(this);
}

@JsonSerializable()
class ClubBranchSignupResponse {
  final bool success;
  final String message;
  final List<ClubBranchResponseData> data;

  ClubBranchSignupResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClubBranchSignupResponse.fromJson(Map<String, dynamic> json) =>
      _$ClubBranchSignupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClubBranchSignupResponseToJson(this);
}

@JsonSerializable()
class ClubBranchResponseData {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'club_name')
  final String clubName;
  @JsonKey(name: 'club_parent_id')
  final int clubParentId;
  @JsonKey(name: 'no_of_users')
  final int noOfUsers;
  @JsonKey(name: 'is_address_is_same_as_user')
  final int isAddressIsSameAsUser;
  @JsonKey(name: 'address_id')
  final int? addressId;
  @JsonKey(name: 'is_contact_details_is_same_user')
  final int isContactDetailsIsSameUser;
  @JsonKey(name: 'contact_details_id')
  final int? contactDetailsId;
  @JsonKey(name: 'sports_is_same_as_user')
  final int sportsIsSameAsUser;
  @JsonKey(name: 'sports_names')
  final String? sportsNames;
  @JsonKey(name: 'is_deleted')
  final int isDeleted;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  ClubBranchResponseData({
    required this.id,
    required this.userId,
    required this.clubName,
    required this.clubParentId,
    required this.noOfUsers,
    required this.isAddressIsSameAsUser,
    this.addressId,
    required this.isContactDetailsIsSameUser,
    this.contactDetailsId,
    required this.sportsIsSameAsUser,
    this.sportsNames,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClubBranchResponseData.fromJson(Map<String, dynamic> json) =>
      _$ClubBranchResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClubBranchResponseDataToJson(this);
}

// Club Branch List Models
@JsonSerializable()
class ClubBranchListItem {
  final int id;
  @JsonKey(name: 'club_name')
  final String clubName;

  ClubBranchListItem({
    required this.id,
    required this.clubName,
  });

  factory ClubBranchListItem.fromJson(Map<String, dynamic> json) =>
      _$ClubBranchListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ClubBranchListItemToJson(this);
}

@JsonSerializable()
class ClubBranchListResponse {
  final bool success;
  final String message;
  final List<ClubBranchListItem> data;

  ClubBranchListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClubBranchListResponse.fromJson(Map<String, dynamic> json) =>
      _$ClubBranchListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClubBranchListResponseToJson(this);
}

// Membership Type Models
@JsonSerializable()
class ChooseMembershipTypeRequest {
  @JsonKey(name: 'membership_type')
  final String membershipType; // "Free" or "Paid"

  ChooseMembershipTypeRequest({
    required this.membershipType,
  });

  factory ChooseMembershipTypeRequest.fromJson(Map<String, dynamic> json) =>
      _$ChooseMembershipTypeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChooseMembershipTypeRequestToJson(this);
}

@JsonSerializable()
class ChooseMembershipTypeResponse {
  final bool success;
  final String message;

  ChooseMembershipTypeResponse({
    required this.success,
    required this.message,
  });

  factory ChooseMembershipTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$ChooseMembershipTypeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChooseMembershipTypeResponseToJson(this);
}
