enum TransType { deposit, withdraw, refund, purchase, adjustment }

enum TransPayMethod { pix, bill, creditCard, debitCard }

enum TransStatus { pending, completed, failed, canceled }

class TransactionModel {
  String? id;
  TransType type;
  TransStatus status;
  TransPayMethod payMethod;
  double amount;
  String userId;
  String description;
  DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.type,
    required this.status,
    required this.payMethod,
    required this.amount,
    required this.userId,
    required this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  TransactionModel copyWith({
    String? id,
    TransType? type,
    TransStatus? status,
    TransPayMethod? payMethod,
    double? amount,
    String? userId,
    String? description,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      payMethod: payMethod ?? this.payMethod,
      amount: amount ?? this.amount,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
