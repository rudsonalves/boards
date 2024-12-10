import 'package:flutter/material.dart';

import '../get_it.dart';
import '../../data/repository/interfaces/remote/i_app_preferences_repository.dart';

const historyMaxLength = 20;

class SearchHistory {
  final List<String> _history = [];
  final search = SearchController();
  final prefs = getIt<IAppPreferencesRepository>();

  bool _started = false;

  List<String> get history => _history;

  void init() {
    if (_started) return;
    _started = true;

    getHistory();
  }

  void getHistory() {
    _history.clear();
    _history.addAll(prefs.history);
  }

  Future<void> saveHistory(String? value) async {
    // Add new search string
    if (value != null && value.isNotEmpty && value.length >= 3) {
      final searchValue = value.toLowerCase();
      if (!_history.contains(searchValue)) {
        _history.add(searchValue);
      }
    }

    // limited history length
    if (_history.length > historyMaxLength) {
      final length = history.length;
      _history.removeRange(0, length - historyMaxLength);
    }

    // save history
    await prefs.setHistory(_history);
  }

  Iterable<String> searchInHistory(String value) {
    if (value.isEmpty) return _history;
    final searchValue = value.toLowerCase();
    return _history.where((item) => item.contains(searchValue));
  }
}
