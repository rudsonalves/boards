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

class NumericEditController<T extends num> extends TextEditingController {
  late final RegExp reInitZeroNumber;
  String oldValue = '';

  T get numericValue {
    if (T == int) return int.tryParse(text) as T? ?? 0 as T;
    if (T == double) return double.tryParse(text) as T? ?? 0 as T;
    throw UnsupportedError('Unsupported type: $T');
  }

  set numericValue(T value) {
    text = value.toString();
    oldValue = value.toString();
    _setControllerText();
  }

  bool _isValidateValue = false;

  NumericEditController({T? initialValue}) {
    oldValue = initialValue != null ? initialValue.toString() : '0';
    text = oldValue;
    if (T == int) {
      reInitZeroNumber = RegExp(r'^0[\d]*$');
    } else {
      reInitZeroNumber = RegExp(r'^0[\d][\.\d]*$');
    }
    addListener(_validateNumber);
  }

  void _validateNumber() {
    if (_isValidateValue) return;
    _isValidateValue = true;

    String newValue = text;

    // Remove point if T is int
    if (T == int && newValue.contains('.')) {
      oldValue = newValue.replaceAll('.', '');
      _setControllerText();
      _isValidateValue = false;
      return;
    }

    // Remove spaces
    if (newValue != newValue.trim()) {
      _setControllerText();
      _isValidateValue = false;
      return;
    }

    // Replase empty string by '0'
    if (newValue.isEmpty) {
      oldValue = '0';
      _setControllerText();
      _isValidateValue = false;
      return;
    }

    // Remove zeros from the start of the number ('02' -> '2')
    if (reInitZeroNumber.hasMatch(newValue)) {
      oldValue = newValue.substring(1);
      _setControllerText();
      _isValidateValue = false;
      return;
    }

    // Check if it is a valid number
    final result =
        T == int ? int.tryParse(newValue) : double.tryParse(newValue);
    if (result == null) {
      _setControllerText();
      _isValidateValue = false;
      return;
    }

    oldValue = newValue;
    _isValidateValue = false;
  }

  void _setControllerText() {
    oldValue = oldValue.trim().isEmpty ? '0' : oldValue.trim();
    text = oldValue;
    selection = TextSelection.fromPosition(
      TextPosition(offset: oldValue.length),
    );
  }
}
