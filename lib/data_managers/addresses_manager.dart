// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

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
  final _addressRepository = getIt<IAddressRepository>();

  bool get isLogged => getIt<CurrentUser>().isLogged;
  String? get userId => getIt<CurrentUser>().userId;

  List<AddressModel> get addresses => _addresses;
  Iterable<String> get addressNames => _addresses.map((e) => e.name);
  AddressModel? get selectedAddress {
    try {
      return _addresses.firstWhere((address) => address.selected);
    } catch (err) {
      return null;
    }
  }

  /// Initializes the address list for the given user ID.
  ///
  /// [userId] - The ID of the user.
  Future<void> login() async {
    if (isLogged) {
      _addressRepository.initialize(userId!);
      await getAddresesesFromUserId(userId!);
    }
  }

  Future<void> logout() async {
    if (isLogged) {
      _addresses.clear();
      _addressRepository.initialize(null);
    }
  }

  Future<void> selectIndex(int index) async {
    final address = selectedAddress;
    if (address == null) return;

    final selectedIndex = _indexOf(address);
    if (selectedIndex == index) return;

    // Desable selected index
    await _setSelectedInIndex(selectedIndex, false);
    // Enable new index
    await _setSelectedInIndex(index, true);
  }

  Future<void> _setSelectedInIndex(int index, bool selected) async {
    // Set selection in local data
    _addresses[index].selected = selected;
    // set selection in storage database
    await _addressRepository.updateSelection(
      addressId: _addresses[index].id!,
      selected: selected,
    );
  }

  int _indexOf(AddressModel address) {
    return _addresses.indexWhere((a) => a.id == address.id!);
  }

  /// Fetches and sets the addresses for the given user ID.
  ///
  /// [userId] - The ID of the user.
  Future<void> getAddresesesFromUserId(String userId) async {
    _addresses.clear();
    final result = await _addressRepository.getAll();
    if (result.isFailure) {
      throw Exception(result.error ?? 'unknow error');
    }
    final addrs = result.data;
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
      final result = await _addressRepository.delete(address.id!);
      if (result.isFailure) {
        throw Exception(result.error ?? 'unknow error');
      }
      _addresses.removeAt(index);
    }
  }

  Future<void> deleteIndex(int index) async {
    try {
      final addressId = _addresses[index].id!;
      // Remove addressId from database
      final result = await _addressRepository.delete(addressId);
      if (result.isFailure) {
        throw Exception(result.error ?? 'unknow error');
      }

      // Remove address in index
      _addresses.removeAt(index);

      // Check if exist a selectes address and _addresses is not empty
      if (selectedAddress == null && _addresses.isNotEmpty) {
        // Set the first address in _addresses list to the selected one
        _setSelectedInIndex(0, true);
      }
    } catch (err) {
      final message = 'AddressManager.deleteId: $err';
      log(message);
      rethrow;
    }
  }

  /// Saves the given address. Throws `DuplicateNameException` if an address
  /// with the same name already exists.
  ///
  /// [address] - The address to be saved.
  Future<void> save(AddressModel address) async {
    final selectFirst = _addresses.isEmpty;

    AddressModel saveAddress = address.copyWith(selected: selectFirst);
    final id = address.id;
    final name = address.name;

    // Index in _addresses where name is address.name, else -1
    final indexByName = _indexWhereName(name);
    // Index in _addresses where id is address.id, else -1
    final indexById = id != null ? _indexWhereId(id) : -1;

    if (id != null && indexByName == -1) {
      // is update
      _addresses[indexById] = saveAddress;
    } else if (id == null && indexByName != -1) {
      // is update with renamed
      saveAddress = saveAddress.copyWith(id: _addresses[indexByName].id);
      _addresses[indexByName] = saveAddress;
    } else if (id != null && indexByName != -1) {
      if (id != _addresses[indexByName].id) {
        throw DuplicateNameException();
      } else {
        // is update
        _addresses[indexById] = saveAddress;
      }
    }

    final isAddAddress = saveAddress.id == null;
    final result = isAddAddress
        ? await _addressRepository.add(saveAddress)
        : await _addressRepository.update(saveAddress);
    if (result.isFailure) {
      throw Exception(result.error ?? 'unknow error');
    }

    final savedAddress = result.data as AddressModel;
    if (isAddAddress) {
      _addresses.add(savedAddress);
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
