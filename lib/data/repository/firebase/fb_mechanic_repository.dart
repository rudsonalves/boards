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

import 'common/data_functions.dart';
import '/core/abstracts/data_result.dart';
import '../../models/mechanic.dart';
import '../interfaces/remote/i_mechanic_repository.dart';
import 'common/errors_codes.dart';

class FbMechanicRepository implements IMechanicRepository {
  static const keyMechanics = 'mechanics';

  CollectionReference<Map<String, dynamic>> get _mechsCollection =>
      FirebaseFirestore.instance.collection(keyMechanics);

  @override
  Future<DataResult<MechanicModel>> add(MechanicModel mech) async {
    try {
      // add a new mechanic
      final doc = await _mechsCollection.add(mech.toMap()..remove('id'));

      // Update Mechanic id from firebase address object
      final newMech = mech.copyWith(id: doc.id);

      return DataResult.success(newMech);
    } catch (err) {
      return _handleError('add', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<void>> delete(String mechId) async {
    try {
      await _mechsCollection.doc(mechId).delete();

      return DataResult.success(null);
    } catch (err) {
      return _handleError('delete', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<MechanicModel>> get(String mechId) async {
    try {
      final doc = await _mechsCollection.doc(mechId).get();
      if (doc.data() == null) {
        return _handleError(
            'get', 'mechanic id $mechId not found', ErrorCodes.mechNotFound);
      }

      final mech = MechanicModel.fromMap(doc.data()!).copyWith(id: doc.id);

      return DataResult.success(mech);
    } catch (err) {
      return _handleError('get', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<List<MechanicModel>>> getAll() async {
    try {
      final mechDocs = await _mechsCollection.get();

      final mechs = mechDocs.docs
          .map((doc) => MechanicModel.fromMap(doc.data()).copyWith(id: doc.id))
          .toList();

      return DataResult.success(mechs);
    } catch (err) {
      return _handleError('get', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<void>> update(MechanicModel mech) async {
    try {
      final doc = _mechsCollection.doc(mech.id);

      await doc.update(mech.toMap()..remove('id'));

      return DataResult.success(null);
    } catch (err) {
      return _handleError('update', err, ErrorCodes.unknownError);
    }
  }

  DataResult<T> _handleError<T>(String module, Object err, [int code = 0]) {
    return DataFunctions.handleError<T>(
        'FbMechanicRepository', module, err, code);
  }
}
