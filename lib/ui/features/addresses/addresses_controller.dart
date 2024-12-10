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
