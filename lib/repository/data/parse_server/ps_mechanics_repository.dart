import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../interfaces/i_mechanic_repository.dart';
import 'common/ps_functions.dart';
import '/core/abstracts/data_result.dart';
import '/core/models/mechanic.dart';
import 'common/constants.dart';
import 'common/parse_to_model.dart';

class PSMechanicsRepository implements IMechanicRepository {
  @override
  Future<DataResult<MechanicModel>> add(MechanicModel mech) async {
    try {
      final parseUser = await PsFunctions.parseCurrentUser();
      final parseAcl = PsFunctions.createDefaultAcl(parseUser);

      // Prepares a ParseObject representing the new mechanic for saving
      final parseMech = _prepareMechForSaveOrUpdate(
        mech: mech,
        parseAcl: parseAcl,
      );

      // Save the ParseObject to the Parse server
      final response = await parseMech.save();
      if (!response.success) {
        throw Exception(response.error?.message ?? 'unknow error.');
      }

      // Converts the ParseObject back to a MechanicModel to return
      return DataResult.success(ParseToModel.mechanic(parseMech));
    } catch (err) {
      return _handleError('add', err);
    }
  }

  @override
  Future<DataResult<MechanicModel>> update(MechanicModel mech) async {
    try {
      final parseUser = await PsFunctions.parseCurrentUser();
      final parseAcl = PsFunctions.createDefaultAcl(parseUser);

      // Prepares a ParseObject representing the new mechanic for saving
      final parse = _prepareMechForSaveOrUpdate(
        mech: mech,
        parseAcl: parseAcl,
      );

      // Update the ParseObject to the Parse server
      final response = await parse.update();
      if (!response.success) {
        throw MechanicRepositoryException(
            response.error?.message ?? 'Failed to save ad.');
      }

      // Converts the ParseObject back to a MechanicModel to return
      return DataResult.success(ParseToModel.mechanic(parse));
    } catch (err) {
      return _handleError('update', err);
    }
  }

  @override
  Future<DataResult<List<MechanicModel>>> getAll() async {
    final query = QueryBuilder<ParseObject>(ParseObject(keyMechanicTable));

    try {
      // Executes the query to retrieve all mechanics
      final response = await query.query();

      // Checks if the query was successful and throws an error if not
      if (!response.success) {
        throw MechanicRepositoryException(
            response.error?.message ?? 'Failed to save ad.');
      }

      // Maps the results to a list of MechanicModel objects
      final List<MechanicModel> mechs = response.results
              ?.map((parse) => ParseToModel.mechanic(parse))
              .toList() ??
          [];

      return DataResult.success(mechs);
    } catch (err) {
      return _handleError('getAll', err);
    }
  }

  @override
  Future<DataResult<MechanicModel>> get(String psId) async {
    try {
      // Creates a ParseObject representing the mechanics table and retrieves
      // the object by ID
      final parse = ParseObject(keyMechanicTable);
      final response = await parse.getObject(psId);

      // Checks if the query was successful and throws an error if not
      if (!response.success) {
        throw MechanicRepositoryException(
            response.error?.message ?? 'register not found.');
      }

      // Checks if the response contains results, throws error if no record is
      // found
      if (response.results == null) {
        throw MechanicRepositoryException('not found mech.id: $psId');
      }

      // Converts the retrieved ParseObject to a MechanicModel instance
      final MechanicModel mechanic = ParseToModel.mechanic(
        response.results!.first as ParseObject,
      );

      return DataResult.success(mechanic);
    } catch (err) {
      return _handleError('getById', err);
    }
  }

  @override
  Future<DataResult<void>> delete(String id) async {
    try {
      // Create a ParseObject representing the advertisement to be deleted
      final parse = ParseObject(keyMechanicTable)..objectId = id;

      // Attempt to delete the object from the Parse Server
      final response = await parse.delete();

      // Check if the response is successful
      if (!response.success) {
        throw Exception(
            response.error?.toString() ?? 'delete mechanic table error');
      }
      return DataResult.success(null);
    } catch (err) {
      return _handleError('delete', err);
    }
  }

  @override
  Future<DataResult<List<String>>> getIds() async {
    final query = QueryBuilder<ParseObject>(ParseObject(keyMechanicTable));

    try {
      // Restrict the query to return only the objectId key for each record
      query.keysToReturn([keyMechanicId]);

      // Execute the query to fetch the object IDs
      final response = await query.query();

      // Checks if the query was successful, throws an error if not
      if (!response.success) {
        throw MechanicRepositoryException(
            response.error?.message ?? 'register not found.');
      }

      // Maps the query results to a list of object IDs (String)
      final List<String> mechs = response.results
              ?.map((parse) => (parse as ParseObject).objectId!)
              .toList() ??
          [];

      return DataResult.success(mechs);
    } catch (err) {
      return _handleError('getIds', err);
    }
  }

  /// Prepares a ParseObject representing a mechanic for save or update
  /// operations.
  ///
  /// This method takes a [MechanicModel] and converts it into a [ParseObject]
  /// that can be saved or updated in the Parse server.
  ///
  /// - If the [mech] contains a `psId`, the method assumes it is an update and
  ///   assigns that `objectId` to the ParseObject, indicating that it already
  ///   exists in the server.
  /// - If no `psId` is provided, the method creates a new ParseObject, assuming
  ///   it is for a new mechanic.
  ///
  /// Parameters:
  /// - [mech]: The mechanic model containing all the data that needs to be
  ///   persisted.
  /// - [parseAcl]: (Optional) A ParseACL object that will be assigned to the
  ///   ParseObject.
  ///   If provided, this will define the permissions for the object.
  ///
  /// Returns:
  /// A [ParseObject] configured with the mechanic information from [mech] that is
  /// ready to be saved or updated on the server.
  ParseObject _prepareMechForSaveOrUpdate({
    required MechanicModel mech,
    ParseACL? parseAcl,
  }) {
    final parseMech = ParseObject(keyMechanicTable);

    if (mech.id != null) {
      parseMech.objectId = mech.id!;
    }

    if (parseAcl != null) {
      parseMech.setACL(parseAcl);
    }

    parseMech
      ..setNonNull<String>(keyMechanicName, mech.name)
      ..setNonNull<String>(keyMechanicDescription, mech.description ?? '');

    return parseMech;
  }

  DataResult<T> _handleError<T>(String method, Object error) {
    return PsFunctions.handleError<T>('MechanicsRepository', method, error);
  }
}
