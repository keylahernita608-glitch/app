class UserAccount {
  final String username;
  final String password;
  final String role;
  String status;

  UserAccount({
    required this.username,
    required this.password,
    required this.role,
    this.status = 'Active',
  });
}

class ItemModel {
  final String id;
  final String title;
  final String category;
  String status;
  final String createdBy;

  ItemModel({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.createdBy,
  });
}

// ===============================
// DATA AKUN
// ===============================

List<UserAccount> registeredUsers = [
  UserAccount(
    username: 'user1',
    password: 'password',
    role: 'User',
    status: 'Active',
  ),
  UserAccount(
    username: 'admin1',
    password: 'password',
    role: 'Admin',
    status: 'Active',
  ),
];

// ===============================
// DATA ITEM
// ===============================

List<ItemModel> globalItemList = [
  ItemModel(
    id: '1',
    title: 'Perbaikan PC Lab 1',
    category: 'Inventaris',
    status: 'Pending',
    createdBy: 'user1',
  ),
  ItemModel(
    id: '2',
    title: 'Update Module Flutter',
    category: 'Task',
    status: 'Proses',
    createdBy: 'user1',
  ),
];