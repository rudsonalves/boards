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

import 'package:cloud_firestore/cloud_firestore.dart';

import 'common/errors_codes.dart';
import '../../models/address.dart';
import '../../../core/abstracts/data_result.dart';
import 'common/data_functions.dart';
import '../interfaces/remote/i_address_repository.dart';

class FbAddressRepository implements IAddressRepository {
  String? _userId;

  static const keyUsers = 'users';
  static const keyAddresses = 'addresses';
  static const keyAddressId = 'id';
  static const keyAddressSelected = 'selected';

  CollectionReference<Map<String, dynamic>> get _addresesCollection =>
      FirebaseFirestore.instance
          .collection(keyUsers)
          .doc(_userId)
          .collection(keyAddresses);

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
      final doc = await _addresesCollection.add(
        address.toMap()..remove(keyAddressId),
      );

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
      final docRef = _addresesCollection.doc(address.id);

      // Update address
      await docRef.update(address.toMap()..remove(keyAddressId));

      return DataResult.success(null);
    } catch (err) {
      return _handleError('update', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<void>> updateSelection({
    required String addressId,
    required bool selected,
  }) async {
    try {
      if (_userId == null) {
        throw Exception('UserId is null');
      }
      // Get document reference
      final docRef = _addresesCollection.doc(addressId);

      // Update address
      await docRef.update(
        {
          keyAddressSelected: selected,
        },
      );

      return DataResult.success(null);
    } catch (err) {
      return _handleError('update', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<void>> delete(String addressId) async {
    try {
      if (_userId == null) {
        throw Exception('UserId is null');
      }

      await _addresesCollection.doc(addressId).delete();

      return DataResult.success(null);
    } catch (err) {
      return _handleError('delete', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<List<AddressModel>?>> get() async {
    try {
      if (_userId == null) {
        throw Exception('UserId is null');
      }
      final addressDocs = await _addresesCollection.get();

      final addresses = addressDocs.docs
          .map((doc) => AddressModel.fromMap(doc.data()).copyWith(id: doc.id))
          .toList();

      return DataResult.success(addresses);
    } catch (err) {
      return _handleError('delete', err, ErrorCodes.unknownError);
    }
  }

  DataResult<T> _handleError<T>(String module, Object err, [int code = 0]) {
    return DataFunctions.handleError<T>(
        'FbAddressRepository', module, err, code);
  }
}
