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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyTextController extends TextEditingController {
  final NumberFormat _formatter;
  final int decimalDigits;
  bool _isApplyingMask = false;

  CurrencyTextController({
    String locale = 'pt_BR',
    this.decimalDigits = 2,
  }) : _formatter = NumberFormat.currency(
          locale: locale,
          symbol: '',
          decimalDigits: decimalDigits,
        ) {
    addListener(_onTextChanged);
  }

  @override
  set text(String newText) {
    final formattedText = _applyMask(newText);
    final newSelection = TextSelection.fromPosition(
      TextPosition(offset: formattedText.length),
    );
    super.value = super.value.copyWith(
          text: formattedText,
          selection: newSelection,
          composing: TextRange.empty,
        );
  }

  String _applyMask(String text) {
    final cleanedText = _cleanString(text);
    final value = double.tryParse(cleanedText) ?? 0.0;
    return _formatter.format(value / _getDivisionFactor());
  }

  String _cleanString(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  double get currencyValue {
    final cleanedText = _cleanString(text);
    final value = double.tryParse(cleanedText) ?? 0.0;
    return value / _getDivisionFactor();
  }

  set currencyValue(double value) {
    text = value.toStringAsFixed(decimalDigits);
  }

  void _onTextChanged() {
    if (_isApplyingMask) return;

    _isApplyingMask = true;
    final text = super.text;
    final maskedText = _applyMask(text);
    if (maskedText != text) {
      final newSelection = TextSelection.fromPosition(
        TextPosition(offset: maskedText.length),
      );
      super.value = super.value.copyWith(
            text: maskedText,
            selection: newSelection,
            composing: TextRange.empty,
          );
    }
    _isApplyingMask = false;
  }

  double _getDivisionFactor() {
    return pow(10, decimalDigits).toDouble();
  }
}
