import 'package:smart_sports/role_specific/merchandiser/screens/referrals/referral.dart';

class ReferralDataService {
  static List<Referral> getMockReferrals() {
    return [
      Referral(
        referralName: 'Stan Proko',
        referralEmail: 'Jhon@Gmail.Com',
        referredBy: 'Anthony',
        referredDate: '01/02/2021',
        status: 'Subscribed',
        subscribedDate: '01/02/2021',
        referralLink: 'Www.Refferal_link',
      ),
      Referral(
        referralName: 'Stan Proko',
        referralEmail: 'Jhon@Gmail.Com',
        referredBy: 'Anthony',
        referredDate: '01/02/2021',
        status: 'Un-Subscribed',
        subscribedDate: '01/02/2021',
        referralLink: 'Www.Refferal_link',
      ),
      Referral(
        referralName: 'Sarah Johnson',
        referralEmail: 'sarah.johnson@email.com',
        referredBy: 'Mike Wilson',
        referredDate: '15/03/2021',
        status: 'Subscribed',
        subscribedDate: '16/03/2021',
        referralLink: 'Www.Refferal_link_2',
      ),
      Referral(
        referralName: 'David Brown',
        referralEmail: 'david.brown@email.com',
        referredBy: 'Lisa Smith',
        referredDate: '22/03/2021',
        status: 'Pending',
        subscribedDate: '',
        referralLink: 'Www.Refferal_link_3',
      ),
      Referral(
        referralName: 'Emma Davis',
        referralEmail: 'emma.davis@email.com',
        referredBy: 'John Doe',
        referredDate: '05/04/2021',
        status: 'Subscribed',
        subscribedDate: '06/04/2021',
        referralLink: 'Www.Refferal_link_4',
      ),
      Referral(
        referralName: 'Michael Wilson',
        referralEmail: 'michael.wilson@email.com',
        referredBy: 'Sarah Johnson',
        referredDate: '12/04/2021',
        status: 'Un-Subscribed',
        subscribedDate: '12/04/2021',
        referralLink: 'Www.Refferal_link_5',
      ),
      Referral(
        referralName: 'Lisa Anderson',
        referralEmail: 'lisa.anderson@email.com',
        referredBy: 'David Brown',
        referredDate: '18/04/2021',
        status: 'Subscribed',
        subscribedDate: '19/04/2021',
        referralLink: 'Www.Refferal_link_6',
      ),
      Referral(
        referralName: 'Robert Taylor',
        referralEmail: 'robert.taylor@email.com',
        referredBy: 'Emma Davis',
        referredDate: '25/04/2021',
        status: 'Pending',
        subscribedDate: '',
        referralLink: 'Www.Refferal_link_7',
      ),
      Referral(
        referralName: 'Jennifer Martinez',
        referralEmail: 'jennifer.martinez@email.com',
        referredBy: 'Michael Wilson',
        referredDate: '02/05/2021',
        status: 'Subscribed',
        subscribedDate: '03/05/2021',
        referralLink: 'Www.Refferal_link_8',
      ),
      Referral(
        referralName: 'Christopher Lee',
        referralEmail: 'christopher.lee@email.com',
        referredBy: 'Lisa Anderson',
        referredDate: '09/05/2021',
        status: 'Un-Subscribed',
        subscribedDate: '09/05/2021',
        referralLink: 'Www.Refferal_link_9',
      ),
    ];
  }

  static List<Referral> searchReferrals(
    String query,
    List<Referral> referrals,
  ) {
    if (query.isEmpty) return referrals;

    return referrals.where((referral) {
      return referral.referralName.toLowerCase().contains(
            query.toLowerCase(),
          ) ||
          referral.referralEmail.toLowerCase().contains(query.toLowerCase()) ||
          referral.referredBy.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
