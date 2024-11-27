import 'package:flutter/material.dart';

import '../../../../core/models/ad.dart';

enum DismissSide { left, right }

class MyAdsDsimissible {
  final AdStatus adStatus;

  MyAdsDsimissible({
    required this.adStatus,
  });

  Color? color(DismissSide side) {
    switch (side) {
      case DismissSide.left:
        return _getColorLeft();
      case DismissSide.right:
        return _getColorRight();
    }
  }

  String? label(DismissSide side) {
    switch (side) {
      case DismissSide.left:
        return _getLabelLeft();
      case DismissSide.right:
        return _getLabelRight();
    }
  }

  IconData? iconData(DismissSide side) {
    switch (side) {
      case DismissSide.left:
        return _getIconLeft();
      case DismissSide.right:
        return _getIconRight();
    }
  }

  AdStatus? status(DismissSide side) {
    switch (side) {
      case DismissSide.left:
        return _getStatusLeft();
      case DismissSide.right:
        return _getStatusRight();
    }
  }

  Color? _getColorLeft() {
    switch (adStatus) {
      case AdStatus.pending:
        return Colors.blue.withOpacity(0.45);
      case AdStatus.active:
        return Colors.green.withOpacity(0.45);
      case AdStatus.sold:
        return null;
      case AdStatus.deleted:
        return null;
    }
  }

  Color? _getColorRight() {
    switch (adStatus) {
      case AdStatus.pending:
        return null;
      case AdStatus.active:
        return Colors.yellow.withOpacity(0.45);
      case AdStatus.sold:
        return Colors.blue.withOpacity(0.45);
      case AdStatus.deleted:
        return null;
    }
  }

  String _getLabelLeft() {
    switch (adStatus) {
      case AdStatus.pending:
        return 'Mover para Ativos';
      case AdStatus.active:
        return 'Mover para Vendidos';
      case AdStatus.sold:
        return '';
      case AdStatus.deleted:
        return '';
    }
  }

  String _getLabelRight() {
    switch (adStatus) {
      case AdStatus.pending:
        return '';
      case AdStatus.active:
        return 'Mover para Pendentes';
      case AdStatus.sold:
        return 'Mover para Ativos';
      case AdStatus.deleted:
        return '';
    }
  }

  IconData? _getIconLeft() {
    switch (adStatus) {
      case AdStatus.pending:
        return Icons.notifications_active;
      case AdStatus.active:
        return Icons.currency_exchange_rounded;
      case AdStatus.sold:
        return null;
      case AdStatus.deleted:
        return null;
    }
  }

  IconData? _getIconRight() {
    switch (adStatus) {
      case AdStatus.pending:
        return null;
      case AdStatus.active:
        return Icons.notifications_off_outlined;
      case AdStatus.sold:
        return Icons.notifications_active;
      case AdStatus.deleted:
        return null;
    }
  }

  AdStatus? _getStatusLeft() {
    switch (adStatus) {
      case AdStatus.pending:
        return AdStatus.active;
      case AdStatus.active:
        return AdStatus.sold;
      case AdStatus.sold:
        return null;
      case AdStatus.deleted:
        return null;
    }
  }

  AdStatus? _getStatusRight() {
    switch (adStatus) {
      case AdStatus.pending:
        return null;
      case AdStatus.active:
        return AdStatus.pending;
      case AdStatus.sold:
        return AdStatus.active;
      case AdStatus.deleted:
        return null;
    }
  }
}
