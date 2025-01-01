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

// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/core/singletons/search_filter.dart';
import '../../../../../data/models/filter.dart';
import '../../../filters/filters_screen.dart';
import '/core/singletons/app_settings.dart';
import '/core/singletons/search_history.dart';
import '../../../../../core/get_it.dart';

class SearchDialog extends SearchDelegate<String> {
  final searchHistory = getIt<SearchHistory>();
  final searchFilter = getIt<SearchFilter>();

  bool get isDark => getIt<AppSettings>().isDark;

  Future<void> _filterSearch(BuildContext context) async {
    final newfilter = await Navigator.pushNamed(
          context,
          FiltersScreen.routeName,
          arguments: searchFilter.filter,
        ) as FilterModel? ??
        FilterModel();

    searchFilter.updateFilter(newfilter);
  }

  Future<void> _filterClean() async {
    searchFilter.updateFilter(FilterModel());
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      InkWell(
        onTap: () {
          query = '';
        },
        borderRadius: BorderRadius.circular(50),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.clear),
        ),
      ),
      InkWell(
        onTap: () => _filterSearch(context),
        onLongPress: _filterClean,
        borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListenableBuilder(
            listenable: searchFilter.filterNotifier,
            builder: (context, _) {
              return Icon(
                searchFilter.filter == FilterModel()
                    ? Icons.filter_alt_outlined
                    : Icons.filter_alt_rounded,
              );
            },
          ),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        elevation: 5,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        backgroundColor:
            isDark ? colorScheme.onSecondary : colorScheme.secondaryContainer,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        titleTextStyle: theme.textTheme.titleLarge,
        toolbarTextStyle: theme.textTheme.bodyMedium,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => close(context, query));
    searchHistory.saveHistory(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final selected = query.isEmpty
        ? searchHistory.history
        : searchHistory.searchInHistory(query).toList();

    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      color: colorScheme.surfaceContainer,
      child: ListView.builder(
        itemCount: selected.length,
        shrinkWrap: true,
        itemBuilder: (_, index) => ListTile(
          title: Text(selected[index]),
          onTap: () {
            query = selected[index];
          },
        ),
      ),
    );
  }

  @override
  void close(BuildContext context, String result) {
    super.close(context, query);
  }
}
