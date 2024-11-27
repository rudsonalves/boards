import '../repository/gov_apis/ibge_repository.dart';
import '../core/models/state.dart';

/// This class provides a singleton manager for handling states in Brazil.
class StateManager {
  StateManager._();
  static final _instance = StateManager._();
  static StateManager get instance => _instance;

  final _upList = <StateBrModel>[];
  List<StateBrModel> get ufList => _upList;

  /// Initializes the state list by fetching data from the IBGE repository.
  ///
  /// Fetches the list of states from the IBGE repository and populates the
  /// `_upList`.
  /// Throws an exception if the data fetch fails.
  Future<void> init() async {
    final stateNewList = await IbgeRepository.getStateList();
    _upList.addAll(stateNewList);
  }
}
