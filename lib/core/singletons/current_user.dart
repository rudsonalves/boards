// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../data_managers/bag_manager.dart';
import '../../repository/data/interfaces/i_user_repository.dart';
import '/get_it.dart';
import '../../data_managers/addresses_manager.dart';
import '../../data_managers/favorites_manager.dart';
import '../models/address.dart';
import '../models/user.dart';

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
