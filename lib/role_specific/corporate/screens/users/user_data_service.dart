import 'package:smart_sports/common/models/user.dart' as models;

class UserDataService {
  static List<models.User> getUsers() {
    return [
      models.User(
        id: '1',
        userName: 'John Smith',
        companyName: 'Corporate Sports Inc.',
        email: 'john.smith@corporate.com',
        role: models.UserRole.admin,
        avatarUrl: 'assets/images/avatars/john_smith.jpg',
        status: models.UserStatus.active,
        department: models.Department.management,
        designation: 'Corporate Manager',
        mobile: '+1 (555) 123-4567',
      ),
      models.User(
        id: '2',
        userName: 'Sarah Johnson',
        companyName: 'Corporate Sports Inc.',
        email: 'sarah.johnson@corporate.com',
        role: models.UserRole.employee,
        avatarUrl: 'assets/images/avatars/sarah_johnson.jpg',
        status: models.UserStatus.active,
        department: models.Department.marketing,
        designation: 'Corporate Coordinator',
        mobile: '+1 (555) 234-5678',
      ),
      models.User(
        id: '3',
        userName: 'Michael Chen',
        companyName: 'Corporate Sports Inc.',
        email: 'michael.chen@corporate.com',
        role: models.UserRole.employee,
        avatarUrl: 'assets/images/avatars/michael_chen.jpg',
        status: models.UserStatus.inactive,
        department: models.Department.development,
        designation: 'Corporate Analyst',
        mobile: '+1 (555) 345-6789',
      ),
      models.User(
        id: '4',
        userName: 'Emily Davis',
        companyName: 'Corporate Sports Inc.',
        email: 'emily.davis@corporate.com',
        role: models.UserRole.admin,
        avatarUrl: 'assets/images/avatars/emily_davis.jpg',
        status: models.UserStatus.active,
        department: models.Department.management,
        designation: 'Corporate Director',
        mobile: '+1 (555) 456-7890',
      ),
      models.User(
        id: '5',
        userName: 'David Wilson',
        companyName: 'Corporate Sports Inc.',
        email: 'david.wilson@corporate.com',
        role: models.UserRole.employee,
        avatarUrl: 'assets/images/avatars/david_wilson.jpg',
        status: models.UserStatus.active,
        department: models.Department.sales,
        designation: 'Corporate Specialist',
        mobile: '+1 (555) 567-8901',
      ),
    ];
  }

  static List<models.User> getFilteredUsers({
    String? searchQuery,
    String? department,
    String? status,
    String? experience,
  }) {
    List<models.User> users = getUsers();

    if (searchQuery != null && searchQuery.isNotEmpty) {
      users = users.where((user) {
        return user.userName.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            user.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
            user.role.label.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    if (department != null && department != 'All') {
      users = users
          .where((user) => user.department.label == department)
          .toList();
    }

    if (status != null && status != 'All') {
      if (status == 'Active') {
        users = users
            .where((user) => user.status == models.UserStatus.active)
            .toList();
      } else if (status == 'Inactive') {
        users = users
            .where((user) => user.status == models.UserStatus.inactive)
            .toList();
      }
    }

    return users;
  }

  static List<String> getDepartments() {
    return ['All', 'Design', 'Management', 'Development', 'Marketing', 'Sales'];
  }

  static List<String> getStatuses() {
    return ['All', 'Active', 'Inactive'];
  }

  static List<models.User> getMockUsers() {
    return getUsers();
  }

  static List<models.User> getAdminUsers() {
    return getUsers()
        .where((user) => user.role == models.UserRole.admin)
        .toList();
  }

  static List<models.User> getEmployeeUsers() {
    return getUsers()
        .where((user) => user.role == models.UserRole.employee)
        .toList();
  }

  static List<models.User> searchUsers(String query, List<models.User> users) {
    return users.where((user) {
      return user.userName.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase()) ||
          user.role.label.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
