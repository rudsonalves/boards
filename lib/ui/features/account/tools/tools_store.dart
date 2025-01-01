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

import 'package:flutter/material.dart';

import '../../../../data/models/mechanic.dart';
import '../../../components/state/state_store.dart';

class ToolsMechList {
  final MechanicModel mech;
  final bool _checked;

  ToolsMechList(this.mech, this._checked);

  bool get isChecked => _checked;
}

class CheckStore extends StateStore {
  final checkList = ValueNotifier<List<ToolsMechList>>([]);

  final count = ValueNotifier<int>(0);

  int counterMax = 0;

  @override
  void dispose() {
    checkList.dispose();
    count.dispose();

    super.dispose();
  }

  void setCheckList(List<ToolsMechList> value) {
    checkList.value = value;
  }

  void incrementCount() {
    count.value++;
  }

  void resetCount(int value) {
    count.value = 0;
    counterMax = value;
  }
}
