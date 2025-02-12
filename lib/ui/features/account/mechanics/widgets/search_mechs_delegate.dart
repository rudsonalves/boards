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

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../../core/get_it.dart';
import '../../../../../logic/managers/mechanics_manager.dart';

class SearchMechsDelegate extends SearchDelegate {
  final void Function(String) selectMechByName;

  SearchMechsDelegate(
    this.selectMechByName,
  );

  final _matchCase = ValueNotifier<bool>(false);

  _toogleMatchCase(BuildContext context) {
    _matchCase.value = !_matchCase.value;
    query = query;
  }

  final mechanicManager = getIt<MechanicsManager>();

  @override
  List<Widget>? buildActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return [
      IconButton(
        onPressed: () => _toogleMatchCase(context),
        icon: ValueListenableBuilder(
          valueListenable: _matchCase,
          builder: (context, value, _) {
            return Text(
              value ? 'Aa' : 'aa',
              style: TextStyle(
                color: colorScheme.outline,
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
      ),
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, query);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    log(query);
    // FIXME: check the operation of this method on the android emulator.
    WidgetsBinding.instance.addPostFrameCallback((_) => close(context, query));
    return Container();
  }

  List<String> _filterNames() {
    if (query.isEmpty) return [];
    if (_matchCase.value) {
      return mechanicManager.mechanicsNames
          .where(
            (mech) => mech.contains(query),
          )
          .toList();
    } else {
      final search = query.toLowerCase();
      return mechanicManager.mechanicsNames
          .where(
            (mech) => mech.toLowerCase().contains(search),
          )
          .toList();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final names = _filterNames();

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 4, 4, 12),
      color: colorScheme.surfaceContainerHigh,
      child: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(names[index]),
          onTap: () {
            query = names[index];
            selectMechByName(names[index]);
            close(context, query);
          },
        ),
      ),
    );
  }
}
