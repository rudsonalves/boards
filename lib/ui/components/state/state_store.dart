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

enum PageState { initial, loading, success, error }

class StateStore {
  final state = ValueNotifier<PageState>(PageState.initial);

  String? errorMessage;

  bool get isInitial => state.value == PageState.initial;
  bool get isLoading => state.value == PageState.loading;
  bool get isSuccess => state.value == PageState.success;
  bool get isError => state.value == PageState.error;

  void setStateInitial() {
    state.value = PageState.initial;
    errorMessage = null;
  }

  void setStateLoading() {
    state.value = PageState.loading;
    errorMessage = null;
  }

  void setStateSuccess() {
    state.value = PageState.success;
    errorMessage = null;
  }

  void setStateError() => state.value = PageState.error;

  setError(String message) {
    errorMessage = message;
    setStateError();
  }

  void dispose() {
    state.dispose();
  }
}
