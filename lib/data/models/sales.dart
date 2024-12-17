// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'bag_item.dart';

/// SaleStatus
/// - pending: the sales has been created, but the process is ongoing
///   (awaiting delivery, payment, etc).
/// - payment: payment made and confirmed
/// - delivered: the product has been shipped and marked as delivered by the
///   system or saller.
/// - confirmedDelivery: the buyer has confirmed delivery, but the sales
///   closing process has not yet been completed
/// - inDispute: the buyer has opened a dispute
/// - closed: the sale has been finalized and requires no futher action (e.g.
///   after delivery confirmed or dispute closing).
enum SaleStatus {
  pending,
  payment,
  delivered,
  confirmedDelivery,
  inDispute,
  closed
}

class SaleModel {
  String? id;
  String userId;
  List<BagItemModel> items;
  double amount;
  DateTime expectedCreditDate;
  SaleStatus _status;
  DateTime createdAt;
  DateTime updatedAt;

  SaleModel({
    this.id,
    required this.userId,
    this.amount = 0.0,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expectedCreditDate,
    SaleStatus status = SaleStatus.pending,
    List<BagItemModel>? items,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        expectedCreditDate =
            expectedCreditDate ?? DateTime.now().add(Duration(days: 30)),
        items = items ?? <BagItemModel>[],
        _status = status;

  SaleStatus get status => _status;

  set status(SaleStatus newStatus) {
    // Ensures status follows the correct sequence
    if (_status.index + 1 != newStatus.index) {
      throw Exception("Cannot mark as delivered without payment.");
    }
    _status = newStatus;

    // Sets expectedCreditDate when changing to 'payment'
    if (newStatus == SaleStatus.payment) {
      expectedCreditDate = DateTime.now().add(Duration(days: 30));
    }

    _updateTimestamp();
  }

  void addItem(BagItemModel item) {
    items.add(item);
    amount += item.quantity * item.unitPrice;
    _updateTimestamp();
  }

  void removeItem(BagItemModel item) {
    final isRemoved = items.remove(item);
    if (isRemoved) {
      amount -= item.quantity * item.unitPrice;
      _updateTimestamp();
    }
  }

  void _updateTimestamp() {
    updatedAt = DateTime.now();
  }
}