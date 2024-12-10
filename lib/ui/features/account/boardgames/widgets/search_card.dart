import 'package:flutter/material.dart';

import '../../../../../data/models/bg_name.dart';

class SearchCard extends StatelessWidget {
  final List<BGNameModel> bgSearchList;
  final void Function(String id) getBoardInfo;

  const SearchCard({
    super.key,
    required this.getBoardInfo,
    required this.bgSearchList,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 200,
      child: Card(
        color: colorScheme.surfaceContainer,
        margin: const EdgeInsets.all(8),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: bgSearchList.length,
          itemBuilder: (context, index) {
            final bgBoard = bgSearchList[index];

            return ListTile(
              onTap: () {
                getBoardInfo(bgBoard.id!);
              },
              title: Text(bgBoard.name!),
              // subtitle: Text(
              //   'Publicado em ${bgBoard.yearpublished ?? '***'}',
              // ),
            );
          },
        ),
      ),
    );
  }
}
