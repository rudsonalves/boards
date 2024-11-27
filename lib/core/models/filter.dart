import 'package:flutter/foundation.dart';

import 'ad.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

enum SortOrder { date, price }

class FilterModel {
  String state;
  String city;
  SortOrder sortBy;
  ProductCondition condition;
  List<String> mechanicsPsId;
  int minPrice;
  int maxPrice;

  FilterModel({
    this.state = '',
    this.city = '',
    this.sortBy = SortOrder.date,
    this.condition = ProductCondition.all,
    List<String>? mechanicsId,
    this.minPrice = 0,
    this.maxPrice = 0,
  }) : mechanicsPsId = mechanicsId ?? [];

  bool get isEmpty {
    return state.isEmpty &&
        city.isEmpty &&
        sortBy == SortOrder.date &&
        condition == ProductCondition.all &&
        mechanicsPsId.isEmpty &&
        minPrice == 0 &&
        maxPrice == 0;
  }

  @override
  bool operator ==(covariant FilterModel other) {
    if (identical(this, other)) return true;

    return other.state == state &&
        other.city == city &&
        other.sortBy == sortBy &&
        other.condition == condition &&
        listEquals(other.mechanicsPsId, mechanicsPsId) &&
        other.minPrice == minPrice &&
        other.maxPrice == maxPrice;
  }

  @override
  int get hashCode {
    return state.hashCode ^
        city.hashCode ^
        sortBy.hashCode ^
        condition.hashCode ^
        mechanicsPsId.hashCode ^
        minPrice.hashCode ^
        maxPrice.hashCode;
  }

  void setFilter(FilterModel f) {
    state = f.state;
    city = f.city;
    sortBy = f.sortBy;
    condition = f.condition;
    mechanicsPsId = f.mechanicsPsId;
    minPrice = f.minPrice;
    maxPrice = f.maxPrice;
  }
}
