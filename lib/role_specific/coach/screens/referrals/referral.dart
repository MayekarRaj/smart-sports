class Referral {
  final String referralName;
  final String referralEmail;
  final String referredBy;
  final String referredDate;
  final String status;
  final String subscribedDate;
  final String referralLink;

  Referral({
    required this.referralName,
    required this.referralEmail,
    required this.referredBy,
    required this.referredDate,
    required this.status,
    required this.subscribedDate,
    required this.referralLink,
  });

  @override
  String toString() {
    return 'Referral(referralName: $referralName, referralEmail: $referralEmail, referredBy: $referredBy, referredDate: $referredDate, status: $status, subscribedDate: $subscribedDate, referralLink: $referralLink)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Referral &&
        other.referralName == referralName &&
        other.referralEmail == referralEmail &&
        other.referredBy == referredBy &&
        other.referredDate == referredDate &&
        other.status == status &&
        other.subscribedDate == subscribedDate &&
        other.referralLink == referralLink;
  }

  @override
  int get hashCode {
    return referralName.hashCode ^
        referralEmail.hashCode ^
        referredBy.hashCode ^
        referredDate.hashCode ^
        status.hashCode ^
        subscribedDate.hashCode ^
        referralLink.hashCode;
  }
}
