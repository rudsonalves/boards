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

import '../../../../core/abstracts/data_result.dart';
import '../../../models/address.dart';

class AddressRepositoryException implements Exception {
  final String message;
  AddressRepositoryException(this.message);

  @override
  String toString() => 'AdRepositoryException: $message';
}

abstract class IAddressRepository {
  void initialize(String? userId);
  Future<DataResult<AddressModel?>> add(AddressModel address);
  Future<DataResult<void>> update(AddressModel address);
  Future<DataResult<void>> updateSelection({
    required String addressId,
    required bool selected,
  });
  Future<DataResult<void>> delete(String addressId);
  Future<DataResult<List<AddressModel>?>> get();
}
