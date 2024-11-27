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

extension StringExtension on String {
  String onlyNumbers() {
    return replaceAll(RegExp(r'[^\d]'), '');
  }
}
