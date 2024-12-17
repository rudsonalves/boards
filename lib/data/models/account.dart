class AccountModel {
  String? id;
  double balance;
  double blockedBalance;
  String pixKey;
  String accountId;
  DateTime createdAt;
  DateTime updatedAt;

  AccountModel({
    this.id,
    required this.balance,
    required this.blockedBalance,
    required this.pixKey,
    required this.accountId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  AccountModel copyWith({
    String? id,
    double? balance,
    double? blockedBalance,
    String? pixKey,
    String? accountId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountModel(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      blockedBalance: blockedBalance ?? this.blockedBalance,
      pixKey: pixKey ?? this.pixKey,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
