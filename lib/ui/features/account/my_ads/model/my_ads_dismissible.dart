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

import '/data/models/ad.dart';

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
        return Colors.blue.withValues(alpha: 0.45);
      case AdStatus.active:
        return Colors.green.withValues(alpha: 0.45);
      case AdStatus.sold:
        return null;
      case AdStatus.deleted:
        return null;
      case AdStatus.reserved:
        return null;
    }
  }

  Color? _getColorRight() {
    switch (adStatus) {
      case AdStatus.pending:
        return null;
      case AdStatus.active:
        return Colors.yellow.withValues(alpha: 0.45);
      case AdStatus.sold:
        return Colors.blue.withValues(alpha: 0.45);
      case AdStatus.deleted:
        return null;
      case AdStatus.reserved:
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
      case AdStatus.reserved:
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
      case AdStatus.reserved:
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
      case AdStatus.reserved:
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
      case AdStatus.reserved:
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
      case AdStatus.reserved:
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
      case AdStatus.reserved:
        return null;
    }
  }
}
