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

import '../../../../../data/models/boardgame.dart';
import '../../../../components/buttons/big_button.dart';
import 'bg_info_card.dart';

class ViewBoardgame extends StatelessWidget {
  final BoardgameModel bg;

  const ViewBoardgame(
    this.bg, {
    super.key,
  });

  static const routeName = '/view_br';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boardgame'),
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            children: [
              BGInfoCard(bg),
              BigButton(
                color: Colors.limeAccent.withValues(alpha: 0.45),
                onPressed: Navigator.of(context).pop,
                label: 'Voltar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
