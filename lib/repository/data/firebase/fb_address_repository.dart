import 'package:cloud_firestore/cloud_firestore.dart';

import '/repository/data/parse_server/common/constants.dart';
import '/core/models/address.dart';
import '../../../core/abstracts/data_result.dart';
import '../functions/data_functions.dart';
import '/repository/data/interfaces/i_address_repository.dart';

class FbAddressRepository implements IAddressRepository {
  final _firebase = FirebaseFirestore.instance;

  static const keyAddresses = 'addresses';

  @override
  Future<DataResult<AddressModel?>> add(AddressModel address) async {
    try {
      // Add a new address
      final doc = await _firebase.collection(keyAddresses).add(address.toMap());

      // Update Address id from firebase address object
      address.id = doc.id;

      return DataResult.success(address);
    } catch (err) {
      return _handleError('add', err);
    }
  }

  @override
  Future<DataResult<void>> delete(String addressId) async {
    try {
      final doc = _firebase.collection(keyAddresses).doc(addressId);

      await doc.delete();
      return DataResult.success(null);
    } catch (err) {
      return _handleError('delete', err);
    }
  }

  @override
  Future<DataResult<List<AddressModel>?>> getUserAddresses(
    String ownerId,
  ) async {
    try {
      final addressDocs = await _firebase
          .collection(keyAddresses)
          .where(
            keyAddressOwner,
            isEqualTo: ownerId,
          )
          .get();

      final addresses = addressDocs.docs
          .map((doc) => AddressModel.fromMap(doc.data()).copyWith(id: doc.id))
          .toList();

      return DataResult.success(addresses);
    } catch (err) {
      return _handleError('delete', err);
    }
  }

  DataResult<T> _handleError<T>(String module, Object err, [int code = 0]) {
    return DataFunctions.handleError<T>(
        'FbAddressRepository', module, err, code);
  }
}
