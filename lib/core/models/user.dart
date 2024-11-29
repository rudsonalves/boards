// ignore_for_file: public_member_api_docs, sort_constructors_first

enum UserRole { user, admin }

class UserModel {
  String? id;
  String? name;
  String email;
  String? phone;
  String? password;
  DateTime? createdAt;
  UserRole role;

  UserModel({
    this.id,
    this.name,
    required this.email,
    this.phone,
    this.password,
    DateTime? createdAt,
    this.role = UserRole.user,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  String toString() {
    return 'User(id: $id, name:'
        ' $name, email:'
        ' $email, phone: $phone,'
        ' password: $password,'
        ' role: ${role.name},'
        ' createdAt: $createdAt';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    UserRole? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
