// Copyright (C) 2025 Rudson Alves
// 
// This file is part of boards.
// 
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

import '../../../data/models/address.dart';
import '../../../core/get_it.dart';
import '../../../logic/managers/addresses_manager.dart';
import 'addresses_store.dart';

class AddressesController {
  final addressManager = getIt<AddressesManager>();
  late final AddressesStore store;

  List<AddressModel> get addresses => addressManager.addresses;
  List<String> get addressNames => addressManager.addressNames.toList();
  AddressModel? get selectedAddress => addressManager.selectedAddress;

  String? get selectesAddresId => selectedAddress?.id;

  Future<void> init(AddressesStore store) async {
    this.store = store;
    _initAddressList();
  }

  Future<void> _initAddressList() async {
    store.setStateLoading();
    Future.delayed(const Duration(milliseconds: 50));
    store.setStateSuccess();
  }

  Future<void> selectAddress(bool selected, int index) async {
    store.setStateLoading();
    await addressManager.selectIndex(index);
    store.setStateSuccess();
  }

  Future<bool> removeAddress(int index) async {
    try {
      store.setStateLoading();
      await addressManager.deleteIndex(index);
      store.setStateSuccess();
      return true;
    } catch (err) {
      store.setError(err.toString());
      return false;
    }
  }

  void closeErroMessage() {
    store.setStateSuccess();
  }
}
