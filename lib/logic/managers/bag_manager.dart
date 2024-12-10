// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../data/models/ad.dart';
import 'ads_manager.dart';
import '../../data/models/bag_item.dart';
import '../../core/get_it.dart';
import '../../data/repository/interfaces/local/i_local_bag_item_repository.dart';

class BagManager {
  final bagRepository = getIt<ILocalBagItemRepository>();
  final adManager = getIt<AdsManager>();

  final _items = <BagItemModel>[];

  final itemsCount = ValueNotifier<int>(0);
  final refreshList = ValueNotifier<bool>(false);

  bool isLoged = false;

  // bags contain the map of purchases made, separated by sellers Id and their
  // selected ad Id
  final Map<String, Set<BagItemModel>> _bagBySeller = {};

  Map<String, Set<BagItemModel>> get bagBySeller => _bagBySeller;
  Set<String> get sellers => _bagBySeller.keys.toSet();

  List<String> get itemsIds => _items.map((item) => item.adId).toList();

  void dispose() {
    itemsCount.dispose();
  }

  Future<void> initialize(bool isLoged) async {
    await bagRepository.initialize();

    this.isLoged = isLoged;

    if (_items.isEmpty) {
      await _loadItems();
      _updateCountValue();
      _checkSellers();
    } else {
      await _clearInLogout();
      for (final item in _items) {
        await bagRepository.add(item);
      }
    }
  }

  /// This method loads the itemsBag from local database and their respective
  /// ads from adManager. The ads are updated with respect to their status
  /// (should be AdStatus.active) and their quantities, if necessary.
  Future<void> _loadItems() async {
    final result = await bagRepository.getAll();
    if (result.isFailure || result.data!.isEmpty) {
      await _clearInLogout();
    } else {
      for (final item in result.data!) {
        final result = await adManager.getAdById(item.adId);
        if (result.isFailure) {
          continue;
        }
        final ad = result.data!;
        if (ad.quantity == 0 || ad.status != AdStatus.active) {
          continue;
        }
        item.setAd(ad);
        if (item.quantity > ad.quantity) {
          item.quantity = ad.quantity;
        }
        _items.add(item);
      }
    }
  }

  Future<void> _clearInLogout() async {
    bagRepository.cleanDatabase();
  }

  /// Return a list os items from a advertiser id `advertiserId` to the
  /// MercadoPago Brick
  Map<String, int> getParameters(String advertiserId) {
    final adItems = _items.where((item) => item.adId == advertiserId);

    final Map<String, int> parameters = {
      for (final item in adItems) item.adId: item.quantity,
    };

    return parameters;
  }

  /// This method adds a new BagItem to the shopping bag. If the item with `ìd`
  /// `adId` is not present in the `_items` list, `index` retiurn -1, a new item
  /// is written to the local database, then the item is added to the `_items`
  /// list, and the seller list is updated.
  /// If `index` return a valid index, the item's `quantity` attribute is
  /// incremented and the item is updated in local database. Finally, the
  /// overrall counter is updated.
  Future<void> addItem(BagItemModel newItem, [int quantity = 1]) async {
    final adId = newItem.adId;
    final index = _indexThatHasId(adId);
    if (index == -1) {
      // Add a new item in _items list
      final result = await bagRepository.add(newItem);
      if (result.isFailure) {
        log('BagManager.addItem: ${result.error}');
        return;
      }
      _items.add(result.data!);
      _checkSellers();
    } else {
      // Increment the quantity item in _items list
      final item = _items[index];
      final increased = item.increaseQt();
      if (!increased) {
        return;
      }
      final result = await bagRepository.updateQuantity(item);
      if (result.isFailure) {
        log('BagManager.addItem: ${result.error}');
        return;
      }
    }
    _updateCountValue();
  }

  /// This method increases the number of items with `item.adId` equal `adId`,
  /// up to the limit of `ad.quantity`.
  Future<void> increaseQt(String adId) async {
    final index = _indexThatHasId(adId);
    if (index != -1) {
      // Increase quantity in item
      final bagItem = _items[index];
      final increased = bagItem.increaseQt();
      if (!increased) return;
      _updateCountValue();
      await bagRepository.updateQuantity(bagItem);
    }
  }

  /// This method decreases the number of items with `item.adId` equal `adId`.
  /// If the quantity is zero, the item is removed from the `_items` list.
  Future<void> decreaseQt(String adId) async {
    final index = _indexThatHasId(adId);
    if (index != -1) {
      final bagItem = _items[index];
      final decreased = bagItem.decreaseQt();
      if (!decreased) return;
      // Remove item
      if (bagItem.quantity == 0) {
        _items.removeAt(index);
        refreshList.value = !refreshList.value;
        _checkSellers();
        await bagRepository.delete(bagItem.id!);
      } else {
        await bagRepository.updateQuantity(bagItem);
      }
      _updateCountValue();
    }
  }

  /// This method update the generic item counter. This counter changes
  /// whenerver the number of items in bag changes.
  void _updateCountValue() {
    itemsCount.value =
        _items.fold<int>(0, (previus, item) => previus + item.quantity);
  }

  /// This method returns the index of the item with the `id` ad in the `_items`
  /// list. If no item is found, a -1 is returned.
  int _indexThatHasId(String id) {
    return _items.indexWhere((item) => item.adId == id);
  }

  /// Return the total of items in bags.
  double total(String sellerId) {
    double sum = 0.0;
    for (final item in _bagBySeller[sellerId]!) {
      sum += item.unitPrice * item.quantity;
    }
    return sum;
  }

  /// This method separates the items in `_items` list and returns the
  /// `_bagBySeller` map with these items separated by seller. These
  /// `_bagBySeller`, bags by seller, are necessary to genarate the
  /// payment by seller.
  void _checkSellers() {
    _bagBySeller.clear();
    for (final item in _items) {
      final seller = item.ownerId;

      _bagBySeller.putIfAbsent(seller, () => <BagItemModel>{}).add(item);
    }
  }

  /// Separate the items from the general `_items` list into a map of bags
  /// separated by seller.
  String? sellerName(String sellerId) {
    try {
      final item = _items.firstWhere((i) => i.ownerId == sellerId);
      return item.ad!.ownerName;
    } catch (err) {
      log('sellerName return error: $err');
      return null;
    }
  }
}
