import 'package:smart_sports/common/models/user.dart';

class FreelancerUserDataService {
  static List<User> getMockUsers() {
    return [
      const User(
        id: '1',
        userName: 'Stan Proko',
        companyName: 'Sekai-Ichi',
        department: Department.design,
        designation: 'Developer',
        role: UserRole.admin,
        mobile: '+91-0000000000',
        email: 'Ret@Gmail.Com',
        status: UserStatus.active,
      ),
      const User(
        id: '2',
        userName: 'Stan Proko',
        companyName: 'Sekai-Ichi',
        department: Department.management,
        designation: 'Designation',
        role: UserRole.employee,
        mobile: '+91-0000000000',
        email: 'Ret@Gmail.Com',
        status: UserStatus.active,
      ),
      const User(
        id: '3',
        userName: 'Alice Johnson',
        companyName: 'TechCorp',
        department: Department.development,
        designation: 'Senior Developer',
        role: UserRole.employee,
        mobile: '+91-9876543210',
        email: 'alice@techcorp.com',
        status: UserStatus.active,
      ),
      const User(
        id: '4',
        userName: 'Bob Smith',
        companyName: 'DesignStudio',
        department: Department.design,
        designation: 'UI/UX Designer',
        role: UserRole.employee,
        mobile: '+91-8765432109',
        email: 'bob@designstudio.com',
        status: UserStatus.pending,
      ),
      const User(
        id: '5',
        userName: 'Carol Davis',
        companyName: 'MarketingPro',
        department: Department.marketing,
        designation: 'Marketing Manager',
        role: UserRole.employee,
        mobile: '+91-7654321098',
        email: 'carol@marketingpro.com',
        status: UserStatus.active,
      ),
      const User(
        id: '6',
        userName: 'David Wilson',
        companyName: 'SalesForce',
        department: Department.sales,
        designation: 'Sales Executive',
        role: UserRole.employee,
        mobile: '+91-6543210987',
        email: 'david@salesforce.com',
        status: UserStatus.inactive,
      ),
      const User(
        id: '7',
        userName: 'Emma Brown',
        companyName: 'DevCorp',
        department: Department.development,
        designation: 'Full Stack Developer',
        role: UserRole.employee,
        mobile: '+91-5432109876',
        email: 'emma@devcorp.com',
        status: UserStatus.active,
      ),
      const User(
        id: '8',
        userName: 'Frank Miller',
        companyName: 'TechStart',
        department: Department.management,
        designation: 'Project Manager',
        role: UserRole.employee,
        mobile: '+91-4321098765',
        email: 'frank@techstart.com',
        status: UserStatus.suspended,
      ),
      const User(
        id: '9',
        userName: 'Grace Lee',
        companyName: 'CreativeAgency',
        department: Department.design,
        designation: 'Creative Director',
        role: UserRole.employee,
        mobile: '+91-3210987654',
        email: 'grace@creativeagency.com',
        status: UserStatus.active,
      ),
      const User(
        id: '10',
        userName: 'Henry Taylor',
        companyName: 'DataCorp',
        department: Department.development,
        designation: 'Data Scientist',
        role: UserRole.employee,
        mobile: '+91-2109876543',
        email: 'henry@datacorp.com',
        status: UserStatus.active,
      ),
    ];
  }

  static List<User> getAdminUsers() {
    return getMockUsers().where((user) => user.role == UserRole.admin).toList();
  }

  static List<User> getEmployeeUsers() {
    return getMockUsers()
        .where((user) => user.role == UserRole.employee)
        .toList();
  }

  static List<User> searchUsers(String query, List<User> users) {
    if (query.isEmpty) return users;

    return users.where((user) {
      return user.userName.toLowerCase().contains(query.toLowerCase()) ||
          user.companyName.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase()) ||
          user.designation.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

