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
