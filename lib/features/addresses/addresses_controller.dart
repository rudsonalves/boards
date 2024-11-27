import 'dart:developer';

import '../../core/models/address.dart';
import '../../get_it.dart';
import '../../data_managers/addresses_manager.dart';
import '../../repository/data/interfaces/i_ad_repository.dart';
import 'addresses_store.dart';

class AddressesController {
  final addressManager = getIt<AddressesManager>();
  late final AddressesStore store;
  final adRepository = getIt<IAdRepository>();

  List<AddressModel> get addresses => addressManager.addresses;
  List<String> get addressNames => addressManager.addressNames.toList();

  String? get selectesAddresId {
    if (store.selectedAddressName.value.isNotEmpty) {
      return addressManager.getAddressIdFromName(
        store.selectedAddressName.value,
      );
    }
    return null;
  }

  Future<void> init(AddressesStore store) async {
    this.store = store;
  }

  void selectAddress(String name) {
    if (addressNames.contains(name)) {
      if (name == store.selectedAddressName.value) {
        store.setSelectedAddressName('');
      } else {
        store.setSelectedAddressName(name);
      }
    }
  }

  Future<void> removeAddress() async {
    final name = store.selectedAddressName.value;
    if (name.isNotEmpty &&
        addressNames.isNotEmpty &&
        addressNames.contains(name)) {
      await addressManager.deleteByName(name);
      store.setSelectedAddressName('');
    }
  }

  Future<void> moveAdsAddressAndRemove({
    required List<String> adsList,
    required String? moveToId,
    required String removeAddressId,
  }) async {
    try {
      store.setStateLoading();
      if (adsList.isNotEmpty && moveToId != null) {
        final result = await adRepository.moveAdsAddressTo(adsList, moveToId);
        if (result.isFailure) {
          throw Exception(result.error);
        }
      }
      await addressManager.deleteById(removeAddressId);
      store.setStateSuccess();
    } catch (err) {
      log(err.toString());
      store.setError('Erro ao mover endereço. Tente mais tarde');
    }
  }

  void closeErroMessage() {
    store.setStateSuccess();
  }
}
