import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PaymentModel {
  final String title;
  final double unitPrice;
  final int quantity;

  PaymentModel({
    required this.title,
    required this.unitPrice,
    required this.quantity,
  });

  @override
  String toString() => 'PaymentModel(amount: $unitPrice,'
      ' description: $title,'
      ' quantity: $quantity)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'unit_price': unitPrice,
      'quantity': quantity,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      unitPrice: map['unit_price'] as double,
      title: map['title'] as String,
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentModel.fromJson(String source) =>
      PaymentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
