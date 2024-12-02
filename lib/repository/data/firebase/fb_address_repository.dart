import 'package:cloud_firestore/cloud_firestore.dart';

import '/repository/data/firebase/common/errors_codes.dart';
import '/core/models/address.dart';
import '../../../core/abstracts/data_result.dart';
import '../functions/data_functions.dart';
import '/repository/data/interfaces/i_address_repository.dart';

class FbAddressRepository implements IAddressRepository {
  final _firebase = FirebaseFirestore.instance;
  String? _userId;

  static const keyUsers = 'users';
  static const keyAddresses = 'addresses';

  CollectionReference<Map<String, dynamic>> get addresesCollection =>
      _firebase.collection(keyUsers).doc(_userId).collection(keyAddresses);

  set userId(String userId) {
    _userId = userId;
  }

  @override
  void initialize(String? userId) {
    _userId = userId;
  }

  @override
  Future<DataResult<AddressModel?>> add(AddressModel address) async {
    try {
      if (_userId == null) {
        throw Exception('UserId is null');
      }
      // Add a new address
      final doc = await addresesCollection.add(address.toMap());

      // Update Address id from firebase address object
      final newAddress = address.copyWith(id: doc.id);

      return DataResult.success(newAddress);
    } catch (err) {
      return _handleError(
        'add',
        err,
        ErrorCodes.unknownError,
      );
    }
  }

  @override
  Future<DataResult<void>> update(AddressModel address) async {
    if (address.id == null) {
      return _handleError(
        'update',
        'Address ID cannot be null for update operation',
        ErrorCodes.addressIdNull,
      );
    }
    try {
      if (_userId == null) {
        throw Exception('UserId is null');
      }
      // Get document reference
      final docRef = addresesCollection.doc(address.id);

      // Update address
      await docRef.update(address.toMap());

      return DataResult.success(null);
    } catch (err) {
      return _handleError(
        'update',
        err,
        ErrorCodes.unknownError,
      );
    }
  }

  @override
  Future<DataResult<void>> delete(String addressId) async {
    try {
      if (_userId == null) {
        throw Exception('UserId is null');
      }
      final doc = addresesCollection.doc(addressId);

      await doc.delete();
      return DataResult.success(null);
    } catch (err) {
      return _handleError(
        'delete',
        err,
        ErrorCodes.unknownError,
      );
    }
  }

  @override
  Future<DataResult<List<AddressModel>?>> getUserAddresses() async {
    try {
      if (_userId == null) {
        throw Exception('UserId is null');
      }
      final addressDocs = await addresesCollection.get();

      final addresses = addressDocs.docs
          .map((doc) => AddressModel.fromMap(doc.data()).copyWith(id: doc.id))
          .toList();

      return DataResult.success(addresses);
    } catch (err) {
      return _handleError(
        'delete',
        err,
        ErrorCodes.unknownError,
      );
    }
  }

  DataResult<T> _handleError<T>(String module, Object err, [int code = 0]) {
    return DataFunctions.handleError<T>(
        'FbAddressRepository', module, err, code);
  }
}
