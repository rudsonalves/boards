// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserAccount {
  String? id;
  double balance;
  double blockedBalance;
  String pixKey;
  String mercadoPagoAccountId;
  DateTime createdAt;
  DateTime updatedAt;

  UserAccount({
    this.id,
    required this.balance,
    required this.blockedBalance,
    required this.pixKey,
    required this.mercadoPagoAccountId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  UserAccount copyWith({
    String? id,
    double? balance,
    double? blockedBalance,
    String? pixKey,
    String? mercadoPagoAccountId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAccount(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      blockedBalance: blockedBalance ?? this.blockedBalance,
      pixKey: pixKey ?? this.pixKey,
      mercadoPagoAccountId: mercadoPagoAccountId ?? this.mercadoPagoAccountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
