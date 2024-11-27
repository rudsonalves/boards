// ignore_for_file: public_member_api_docs, sort_constructors_first

enum TransType { deposit, withdraw, refund, purchase, adjustment }

enum TransPayMethod { pix, mercadoPago, creditCard, debitCard }

enum TransStatus { pending, completed, failed, canceled }

class Transaction {
  String? id;
  TransType type;
  TransStatus status;
  TransPayMethod payMethod;
  double amount;
  String userId;
  String description;
  DateTime createdAt;

  Transaction({
    required this.id,
    required this.type,
    required this.status,
    required this.payMethod,
    required this.amount,
    required this.userId,
    required this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Transaction copyWith({
    String? id,
    TransType? type,
    TransStatus? status,
    TransPayMethod? payMethod,
    double? amount,
    String? userId,
    String? description,
    DateTime? createdAt,
  }) {
    return Transaction(
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