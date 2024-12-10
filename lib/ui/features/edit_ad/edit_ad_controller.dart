import 'dart:developer';

import 'package:boards/data/models/user.dart';
import 'package:flutter/material.dart';

import '../../../data/repository/interfaces/remote/i_ads_repository.dart';
import '../../../core/abstracts/data_result.dart';
import '../../components/form_controllers/currency_text_controller.dart';
import 'edit_ad_store.dart';
import '/core/singletons/current_user.dart';
import '../../../data/models/ad.dart';
import '../../../data/models/mechanic.dart';
import '../../../core/get_it.dart';
import '../../../logic/managers/boardgames_manager.dart';
import '../../../logic/managers/mechanics_manager.dart';

class EditAdController {
  late final EditAdStore store;
  final bgManager = getIt<BoardgamesManager>();
  final mechanicsManager = getIt<MechanicsManager>();
  final currentUser = getIt<CurrentUser>();
  final adRepository = getIt<IAdsRepository>();

  String _selectedAddressId = '';

  final nameController = TextEditingController();
  final priceController = CurrencyTextController();
  final quantityController = TextEditingController();
  final mechsController = TextEditingController();
  final addressController = TextEditingController();

  AdModel ad = AdModel(
    images: [],
    title: '',
    description: '',
    mechanicsIds: [],
    price: 0,
  );

  String get selectedAddressId => _selectedAddressId;
  List<MechanicModel> get mechanics => mechanicsManager.mechanics;
  UserModel get user => currentUser.user!;

  void init(EditAdStore store) {
    this.store = store;

    _loadBoardgame();
    setSelectedAddress();
  }

  void dispoase() {
    nameController.dispose();
    mechsController.dispose();
    priceController.dispose();
    quantityController.dispose();
    addressController.dispose();
  }

  Future<DataResult<AdModel>> saveAd() async {
    try {
      store.setStateLoading();
      final result = await adRepository.add(store.ad);
      if (result.isFailure) {
        throw Exception(result.error);
      }
      if (result.data == null) {
        throw Exception('IAdRepository.save return null');
      }
      store.setStateSuccess();

      return DataResult.success(result.data!);
    } catch (err) {
      final message = 'EditAdController.save: $err';
      log(message);
      store.setError('Ocorreu algum problema. Favor tente mais tarde');
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  Future<void> setBgInfo(String bgId) async {
    try {
      store.setStateLoading();
      final result = await bgManager.getBoardgameId(bgId);
      if (result.isFailure) {
        throw Exception(result.error);
      }
      final bg = result.data;
      if (bg != null) {
        setMechanicsPsIds(bg.mechIds);
        setName(bg.name);
        store.setBGInfo(bg);
        setMechanicsPsIds(bg.mechIds);
      }
      log(store.ad.toString());
      store.setStateSuccess();
    } catch (err) {
      log(err.toString());
      const message = 'Estamos tendo algum problema com a conexão.'
          ' Tente novamente mais tarde.';
      store.setError(message);
    }
  }

  void setMechanicsPsIds(List<String> mechPsIds) {
    store.setMechanics(mechPsIds);
    mechsController.text = store.ad.mechanicsString;
  }

  void setSelectedAddress() {
    final address = currentUser.selectedAddress;
    if (address != null) {
      addressController.text = address.addressString();
      store.setAddress(address);
      _selectedAddressId = address.id!;
    }
  }

  void setName(String name) {
    nameController.text = name;
    store.setName(name);
  }

  void setPrice(double price) {
    priceController.currencyValue = price;
    store.setPrice(price);
  }

  void setPriceString(String value) {
    store.setPrice(priceController.currencyValue);
  }

  void _loadBoardgame() {
    store.setStateLoading();
    final ad = store.ad;
    nameController.text = ad.title;
    priceController.currencyValue = ad.price;
    quantityController.text = ad.quantity.toString();
    mechsController.text = store.ad.mechanicsString;
    addressController.text = store.ad.singleAddressString ?? "";

    store.setStateSuccess();
  }
}
