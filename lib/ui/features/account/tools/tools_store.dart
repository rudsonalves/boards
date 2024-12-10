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
