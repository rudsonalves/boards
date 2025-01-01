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

import '/core/abstracts/data_result.dart';
import '../../../models/mechanic.dart';

class MechanicRepositoryException implements Exception {
  final String message;
  MechanicRepositoryException(this.message);

  @override
  String toString() => 'BoardgameRepositoryException: $message';
}

abstract class IMechanicRepository {
  /// Adds a new mechanic to the Parse Server.
  ///
  /// This method creates a new mechanic entry by taking the provided
  /// [MechanicModel], creating a corresponding [ParseObject], and saving it to
  /// the Parse Server.
  ///
  /// - The method first retrieves the current logged-in user to define the ACL
  ///   permissions.
  /// - Then it creates a new ParseObject using `_prepareMechForSaveOrUpdate`
  ///   and sets appropriate permissions via the ACL.
  /// - If the save operation is successful, it converts the [ParseObject] back
  ///   to a [MechanicModel] and returns it wrapped in a successful [DataResult].
  ///
  /// Parameters:
  /// - [mech]: The [MechanicModel] that contains all necessary data for the new
  ///   mechanic.
  ///
  /// Throws:
  /// - [Exception]: If there is any issue while saving the mechanic, such as
  ///   server errors or validation errors.
  ///
  /// Returns:
  /// - [DataResult<MechanicModel>]: If successful, contains the newly added
  ///   [MechanicModel].
  ///   Otherwise, returns a failure wrapped in a [DataResult] with the relevant
  ///   error message.
  Future<DataResult<MechanicModel>> add(MechanicModel mech);

  /// Updates an existing mechanic entry in the Parse Server.
  ///
  /// This method is responsible for updating the information of an existing
  /// mechanic in the Parse Server. It takes the provided [MechanicModel] and
  /// creates a corresponding [ParseObject] to perform the update.
  ///
  /// - The method first retrieves the current logged-in user to set the ACL
  ///   permissions that will be used for the updated mechanic.
  /// - The provided [MechanicModel] is converted to a [ParseObject] using the
  ///   `_prepareMechForSaveOrUpdate` method, setting the necessary fields and
  ///   permissions.
  /// - If the update is successful, it converts the updated [ParseObject] back
  ///   to a [MechanicModel] and returns it wrapped in a [DataResult].
  ///
  /// Parameters:
  /// - [mech]: The [MechanicModel] containing the updated data for the
  ///   mechanic.
  ///
  /// Throws:
  /// - [MechanicRepositoryException]: If the update operation fails, such as
  ///   due to a server error or validation failure.
  ///
  /// Returns:
  /// - [DataResult<MechanicModel>]: If successful, contains the updated
  ///   [MechanicModel].
  ///   Otherwise, returns a failure wrapped in a [DataResult] with the relevant
  ///   error message.
  Future<DataResult<void>> update(MechanicModel mech);

  /// Retrieves all mechanic entries from the Parse Server.
  ///
  /// This method is responsible for fetching all mechanic records stored in the
  /// Parse Server.
  /// It executes a query to the mechanics table and returns a list of
  /// [MechanicModel] objects representing all the mechanics available.
  ///
  /// - A [QueryBuilder] is used to create a query that fetches all records from
  ///   the mechanics table.
  /// - The result is then mapped to a list of [MechanicModel] instances.
  ///
  /// Throws:
  /// - [MechanicRepositoryException]: If there is any issue during the query,
  ///   such as a server error or if no records are found.
  ///
  /// Returns:
  /// - [DataResult<List<MechanicModel>>]: If successful, returns a list of all
  ///   available [MechanicModel]s. Otherwise, returns a failure wrapped in a
  ///   [DataResult] with the relevant error message.
  Future<DataResult<List<MechanicModel>>> getAll();

  /// Retrieves a specific mechanic entry from the Parse Server by its ID.
  ///
  /// This method is responsible for fetching a specific mechanic record based
  /// on the provided [mechId]. It queries the Parse Server to find the mechanic
  /// with the given ID.
  ///
  /// - A [ParseObject] is created for the mechanics table, and the `getObject`
  ///   method is used to retrieve the mechanic data by its unique [mechId].
  /// - If the query is successful, the result is converted to a
  ///   [MechanicModel].
  ///
  /// Parameters:
  /// - [psId]: The ID of the mechanic to be retrieved.
  ///
  /// Throws:
  /// - [MechanicRepositoryException]: If the query fails or if no mechanic with
  ///   the provided [mechId] is found.
  ///
  /// Returns:
  /// - [DataResult<MechanicModel>]: If successful, returns the [MechanicModel]
  ///   representing the mechanic.
  ///   Otherwise, returns a failure wrapped in a [DataResult] with the relevant
  ///   error message.
  Future<DataResult<MechanicModel>> get(String mechId);

  Future<DataResult<void>> delete(String mechId);
}
