// API Models for Smart Sports App

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
      statusCode: json['status_code'],
    );
  }
}

// Authentication Models
class SignInRequest {
  final String email;
  final String password;

  SignInRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class SignInResponse {
  final String token;
  final UserProfile user;

  SignInResponse({required this.token, required this.user});

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      token: json['token'] ?? '',
      user: UserProfile.fromJson(json['user'] ?? {}),
    );
  }
}

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

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'],
      phone: json['phone'],
      avatar: json['avatar'],
    );
  }
}

// Club Registration Models
class ClubSignupStep1Request {
  final int userId;
  final String userRole;
  final String clubName;
  final int noOfUsers;
  final int isAddressIsSameAsUser;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String zipcode;
  final String country;
  final int isContactDetailsIsSameUser;
  final String officePhoneExt;
  final String officePhone;
  final String mobilePhoneExt;
  final String mobilePhone;
  final String companyWebsite;
  final int sportsIsSameAsUser;
  final List<String> sportsNames;
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

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_role': userRole,
      'club_name': clubName,
      'no_of_users': noOfUsers,
      'is_address_is_same_as_user': isAddressIsSameAsUser,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'country': country,
      'is_contact_details_is_same_user': isContactDetailsIsSameUser,
      'office_phone_ext': officePhoneExt,
      'office_phone': officePhone,
      'mobile_phone_ext': mobilePhoneExt,
      'mobile_phone': mobilePhone,
      'company_website': companyWebsite,
      'sports_is_same_as_user': sportsIsSameAsUser,
      'sports_names': sportsNames,
      'operational_details': operationalDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class ClubSignupStep2Request {
  final int userId;
  final int clubId;
  final List<ClubBranch> branches;

  ClubSignupStep2Request({
    required this.userId,
    required this.clubId,
    required this.branches,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'club_id': clubId,
      'branches': branches.map((e) => e.toJson()).toList(),
    };
  }
}

class ClubBranch {
  final String clubName;
  final int numberOfUsers;
  final int isAddressSameAsUser;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final int isContactSameAsUser;
  final String? officePhoneExt;
  final String? officePhone;
  final String? mobilePhoneExt;
  final String? mobilePhone;
  final String? companyWebsite;
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

  Map<String, dynamic> toJson() {
    return {
      'club_name': clubName,
      'number_of_users': numberOfUsers,
      'is_address_same_as_user': isAddressSameAsUser,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'is_contact_same_as_user': isContactSameAsUser,
      'office_phone_ext': officePhoneExt,
      'office_phone': officePhone,
      'mobile_phone_ext': mobilePhoneExt,
      'mobile_phone': mobilePhone,
      'company_website': companyWebsite,
      'operational_details': operationalDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class OperationalDetail {
  final String openDays;
  final String clubStartTime;
  final String clubEndTime;

  OperationalDetail({
    required this.openDays,
    required this.clubStartTime,
    required this.clubEndTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'open_days': openDays,
      'club_start_time': clubStartTime,
      'club_end_time': clubEndTime,
    };
  }
}

class ClubSignupResponse {
  final int clubId;
  final String message;
  final bool success;

  ClubSignupResponse({
    required this.clubId,
    required this.message,
    required this.success,
  });

  factory ClubSignupResponse.fromJson(Map<String, dynamic> json) {
    return ClubSignupResponse(
      clubId: json['club_id'] ?? 0,
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}
