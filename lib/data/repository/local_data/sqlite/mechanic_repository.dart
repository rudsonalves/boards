import '../common/local_functions.dart';
import '../../../store/stores/interfaces/i_mechanics_store.dart';
import '/core/abstracts/data_result.dart';
import '../../../models/mechanic.dart';
import '../../../store/stores/mechanics_store.dart';
import '../../interfaces/local/i_local_mechanic_repository.dart';

class SqliteMechanicRepository implements ILocalMechanicRepository {
  final IMechanicsStore _store = MechanicsStore();

  @override
  Future<void> initialize() async {
    _store.initialize();
  }

  @override
  Future<DataResult<List<MechanicModel>>> getAll() async {
    try {
      final result = await _store.getAll();
      if (result.isEmpty) DataResult.success([]);

      final mechanics =
          result.map((item) => MechanicModel.fromMap(item)).toList();
      return DataResult.success(mechanics);
    } catch (err) {
      return _handleError('getAll', err);
    }
  }

  @override
  Future<DataResult<MechanicModel>> add(MechanicModel mech) async {
    try {
      final id = await _store.add(mech.toMap());
      if (id < 0) throw Exception('return id $id');

      return DataResult.success(mech);
    } catch (err) {
      return _handleError('add', err);
    }
  }

  @override
  Future<DataResult<void>> update(MechanicModel mech) async {
    try {
      await _store.update(mech.toMap());
      return DataResult.success(null);
    } catch (err) {
      return _handleError('update', err);
    }
  }

  @override
  Future<DataResult<void>> delete(String id) async {
    try {
      final result = await _store.delete(id);
      if (result < 0) {
        throw Exception('mechanic id $id not found.');
      }
      return DataResult.success(null);
    } catch (err) {
      return _handleError('delete', err);
    }
  }

  @override
  Future<DataResult<void>> resetDatabase() async {
    try {
      await _store.resetDatabase();
      return DataResult.success(null);
    } catch (err) {
      return _handleError('resetDatabase', err);
    }
  }

  static DataResult<T> _handleError<T>(String module, Object error) {
    return LocalFunctions.handleError(
        'SqliteMechanicRepository', module, error);
  }
}
