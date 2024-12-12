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
