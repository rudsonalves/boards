// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../core/models/address.dart';
import '../core/singletons/current_user.dart';
import '../get_it.dart';
import '../repository/data/interfaces/i_address_repository.dart';

/// Custom exception to handle duplicate address names.
class DuplicateNameException implements Exception {
  @override
  String toString() =>
      'This address can\'t be updated because it has a duplicate name.';
}

/// Manager class to handle address operations such as initialization, fetching,
/// saving, and deleting addresses.
class AddressesManager {
  final List<AddressModel> _addresses = [];
  final addressRepository = getIt<IAddressRepository>();

  List<AddressModel> get addresses => _addresses;
  Iterable<String> get addressNames => _addresses.map((e) => e.name);
  bool get isLogged => getIt<CurrentUser>().isLogged;
  String? get userId => getIt<CurrentUser>().userId;

  /// Initializes the address list for the given user ID.
  ///
  /// [userId] - The ID of the user.
  Future<void> login() async {
    if (isLogged) {
      await getFromUserId(userId!);
    }
  }

  Future<void> logout() async {
    if (isLogged) {
      _addresses.clear();
    }
  }

  /// Fetches and sets the addresses for the given user ID.
  ///
  /// [userId] - The ID of the user.
  Future<void> getFromUserId(String userId) async {
    _addresses.clear();
    final addrs = await addressRepository.getUserAddresses(userId);
    if (addrs != null && addrs.isNotEmpty) {
      _addresses.addAll(addrs);
    }
  }

  /// Deletes the address with the given name.
  ///
  /// [name] - The name of the address to be deleted.
  Future<void> deleteByName(String name) async {
    final index = _indexWhereName(name);
    if (index != -1) {
      final address = _addresses[index];
      await addressRepository.delete(address.id!);
      _addresses.removeAt(index);
    }
  }

  Future<void> deleteById(String addressId) async {
    final index = _indexWhereId(addressId);
    if (index != -1) {
      await addressRepository.delete(addressId);
      _addresses.removeAt(index);
    }
  }

  /// Saves the given address. Throws `DuplicateNameException` if an address
  /// with the same name already exists.
  ///
  /// [address] - The address to be saved.
  Future<void> save(AddressModel address) async {
    final index = _indexWhereName(address.name);
    if (address.id != null && index == -1) {
      // is update
      _addresses[_indexWhereId(address.id!)] = address;
    } else if (address.id == null && index != -1) {
      // is update with renamed
      address.id = _addresses[index].id;
      _addresses[_indexWhereId(address.id!)] = address;
    } else if (address.id != null && index != -1) {
      if (address.id != _addresses[index].id) {
        throw DuplicateNameException();
      } else {
        // is update
        _addresses[_indexWhereId(address.id!)] = address;
      }
    }

    final savedAddress = await addressRepository.save(address);
    if (address.id == null) {
      _addresses.add(savedAddress!);
    }
  }

  /// Returns the address with the given name.
  ///
  /// [name] - The name of the address.
  /// Returns the address if found, otherwise returns null.
  AddressModel? getByUserName(String name) {
    final index = _indexWhereName(name);
    return index != -1 ? _addresses[index] : null;
  }

  /// Returns the index of the address with the given name in the `_addresses`
  /// list.
  ///
  /// [name] - The name of the address.
  /// Returns the index if found, otherwise returns -1.
  int _indexWhereName(String name) {
    return _addresses.indexWhere(
      (addr) => addr.name == name,
    );
  }

  /// Returns the index of the address with the given ID in the `_addresses`
  /// list.
  ///
  /// [id] - The ID of the address.
  /// Returns the index if found, otherwise returns -1.
  int _indexWhereId(String id) {
    return _addresses.indexWhere(
      (addr) => addr.id == id,
    );
  }

  String? getAddressIdFromName(String name) {
    try {
      return _addresses.firstWhere((a) => a.name == name).id!;
    } catch (err) {
      return null;
    }
  }
}
