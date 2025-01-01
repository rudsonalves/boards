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

import 'package:intl/intl.dart';

extension NumberExtension on num {
  String formatMoney() {
    return NumberFormat('R\$ ###,##0.00', 'pt-BR').format(this);
  }
}

extension DateTimeExtension on DateTime {
  String formatDate() {
    return DateFormat('dd/MM/yyy HH:mm', 'pt-BR').format(this);
  }
}

extension EnumFromNameExtension<T extends Enum> on Iterable<T> {
  T fromName(String name) {
    return firstWhere((item) => item.name == name, orElse: () {
      throw StateError('No enum value with name "$name" found in $this');
    });
  }
}

extension OnlyNumberString on String {
  String onlyNumbers() {
    return replaceAll(RegExp(r'[^\d]'), '');
  }
}
