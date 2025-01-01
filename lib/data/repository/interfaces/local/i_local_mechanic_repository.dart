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

/// A repository class for handling operations related to game mechanics using
/// SQLite.
///
/// This class implements the [ILocalMechanicRepository] interface and provides
/// methods for adding, updating, and retrieving game mechanics from an SQLite
/// database.
/// It interacts with a store (`MechanicsStore`) which performs the actual
/// database operations.
abstract class ILocalMechanicRepository {
  Future<void> initialize();

  /// Retrieves all game mechanics from the SQLite database.
  ///
  /// This method attempts to get the list of all game mechanics using
  /// `MechanicsStore.get()`. If no data is found, it returns an empty list.
  /// Throws an [Exception] if there is any error during the retrieval.
  ///
  /// Returns:
  /// - A [Future] containing a list of [MechanicModel] objects if successful.
  /// - Throws an exception if an error occurs during retrieval.
  Future<DataResult<List<MechanicModel>>> getAll();

  /// Adds a new game mechanic to the SQLite database.
  ///
  /// This method takes a [MechanicModel] object, converts it to a map,
  /// and inserts it into the database using `MechanicsStore.add()`.
  /// If the insertion returns an ID less than zero, it throws an exception.
  /// If an error occurs, it logs the error and returns `null`.
  ///
  /// Parameters:
  /// - [mech]: The [MechanicModel] to be added to the database.
  ///
  /// Returns:
  /// - A [Future] containing the added [MechanicModel] with the assigned ID.
  /// - Returns `null` if an error occurs during the addition.
  Future<DataResult<MechanicModel>> add(MechanicModel mech);

  /// Updates an existing game mechanic in the SQLite database.
  ///
  /// This method takes a [MechanicModel] object, converts it to a map,
  /// and updates the corresponding record in the database using
  /// `MechanicsStore.update()`. If an error occurs during the update, it logs
  /// the error and throws an exception.
  ///
  /// Parameters:
  /// - [mech]: The [MechanicModel] to be updated in the database.
  ///
  /// Returns:
  /// - A [Future] containing the number of affected rows.
  /// - Throws an exception if an error occurs during the update.
  Future<DataResult<void>> update(MechanicModel mech);

  /// Delete a new game mechanic to the SQLite database.
  ///
  /// This method takes a mechanic [id] and remove it from database
  /// If the deletation returns an ID less than zero, it throws an exception.
  /// If an error occurs, it logs the error and returns `null`.
  ///
  /// Parameters:
  /// - [mech]: The [MechanicModel] to be added to the database.
  ///
  /// Returns:
  /// - A [Future] containing the added [MechanicModel] with the assigned ID.
  /// - Returns `null` if an error occurs during the addition.
  Future<DataResult<void>> delete(String id);

  Future<DataResult<void>> resetDatabase();
}
