// ignore_for_file: public_member_api_docs, sort_constructors_first

enum UserRole { user, admin }

class UserModel {
  String? id;
  String? name;
  String email;
  bool isEmailVerified;
  String? phone;
  bool isPhoneVerified;
  String? password;
  UserRole role;
  String? fcmToken;
  DateTime? createdAt;

  UserModel({
    this.id,
    this.name,
    required this.email,
    this.isEmailVerified = false,
    this.phone,
    this.isPhoneVerified = false,
    this.password,
    DateTime? createdAt,
    this.role = UserRole.user,
    this.fcmToken,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  String toString() {
    return 'User(id: $id,'
        ' name: $name,'
        ' email: $email (verified: $isEmailVerified),'
        ' phone: $phone (verified: $isPhoneVerified),'
        ' password: $password,'
        ' role: ${role.name},'
        ' token: $fcmToken,'
        ' createdAt: $createdAt';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isEmailVerified,
    String? phone,
    bool? isPhoneVerified,
    String? password,
    UserRole? role,
    String? fcmToken,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phone: phone ?? this.phone,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
