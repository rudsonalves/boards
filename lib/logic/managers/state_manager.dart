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

import '../../data/repository/gov_apis/ibge_repository.dart';
import '../../data/models/state.dart';

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
