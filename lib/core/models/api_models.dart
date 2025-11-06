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
