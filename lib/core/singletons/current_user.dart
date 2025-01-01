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

// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../logic/managers/bag_manager.dart';
import '../../data/repository/interfaces/remote/i_user_repository.dart';
import '../get_it.dart';
import '../../logic/managers/addresses_manager.dart';
import '../../logic/managers/favorites_manager.dart';
import '../../data/models/address.dart';
import '../../data/models/user.dart';

class CurrentUser {
  CurrentUser();

  UserModel? _user;
  UserModel? get user => _user;

  final addressManager = getIt<AddressesManager>();
  final favoritesManager = getIt<FavoritesManager>();
  final userRepository = getIt<IUserRepository>();
  final bagManager = getIt<BagManager>();

  List<AddressModel> get addresses => addressManager.addresses;
  AddressModel? get selectedAddress => addressManager.selectedAddress;

  final _isLoged = ValueNotifier<bool>(false);

  String get userId => _user!.id!;
  bool get isAdmin => _user!.role == UserRole.admin;
  ValueListenable<bool> get isLogedListernable => _isLoged;
  bool get isLogged => _isLoged.value;

  void dispose() {
    _isLoged.dispose();
  }

  Future<void> initialize([UserModel? user]) async {
    if (isLogged) return;
    if (user == null) {
      final result = await userRepository.getCurrentUser();
      if (result.isSuccess) {
        user = result.data;
        log(user.toString());
      }
    }
    if (user == null) return;
    await login(user);
  }

  Future<void> login(UserModel user) async {
    _user = user;
    _isLoged.value = true;
    await addressManager.login();
    await favoritesManager.login();
    await bagManager.initialize(_isLoged.value);
  }

  AddressModel? addressByName(String name) =>
      addressManager.getByUserName(name);

  Future<void> saveAddress(AddressModel address) async =>
      addressManager.save(address);

  Future<void> logout() async {
    await userRepository.signOut();
    addressManager.logout();
    favoritesManager.logout();
    _user = null;
    _isLoged.value = false;
  }
}
