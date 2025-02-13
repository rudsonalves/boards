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
import 'package:flutter/scheduler.dart';
import 'package:material_symbols_icons/symbols.dart';

import '/core/singletons/app_settings.dart';
import '/ui/components/widgets/app_snackbar.dart';
import '/core/get_it.dart';
import '/data/models/boardgame.dart';
import '/core/theme/app_text_style.dart';
import '../sub_title_product.dart';
import 'game_data_controller.dart';
import 'game_data_store.dart';

class GameDataWidget extends StatefulWidget {
  final String? bgId;
  final double indent;

  const GameDataWidget({
    super.key,
    this.bgId,
    required this.indent,
  });

  @override
  State<GameDataWidget> createState() => _GameDataWidgetState();
}

class _GameDataWidgetState extends State<GameDataWidget> {
  final store = GameDataStore();
  late final GameDataController ctrl;
  final app = getIt<AppSettings>();

  BoardgameModel? get boardgame => ctrl.boardgame;

  @override
  void initState() {
    super.initState();

    ctrl = GameDataController(
      store: store,
      bgId: widget.bgId,
    );
  }

  void _loadBoardgame() {
    ctrl.loadBoardgame();
  }

  Widget _richTextRow(String title, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    // Color? color = app.isDark ? colorScheme.onSurface
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title: ',
              style: AppTextStyle.font15SemiBold.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            TextSpan(
              text: value,
              style: AppTextStyle.font15.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _richTextColumn(String title, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          text: '$title:\n',
          style: AppTextStyle.font16SemiBold.copyWith(
            color: colorScheme.onSurface,
          ),
          children: [
            TextSpan(
              text: value,
              style: AppTextStyle.font15.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bgInfo() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _richTextRow(
          'Número de jogadores',
          '${boardgame!.minPlayers} a ${boardgame!.maxPlayers}',
        ),
        _richTextRow(
          'Duração média',
          '${boardgame!.minTime} a ${boardgame!.maxTime}',
        ),
        _richTextRow('Idade recomendada', '${boardgame!.minAge}+'),
        _richTextRow('Designer', boardgame!.designer ?? ''),
        _richTextRow('Artistas', boardgame!.artist ?? ''),
        _richTextColumn('Descrição', boardgame!.description ?? ''),
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 4),
          child: RichText(
            text: TextSpan(
              text: 'Mecânicas:',
              style: AppTextStyle.font16SemiBold.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
        ...boardgame!.mechIds.map((id) {
          final mech = ctrl.mechFromId(id);
          return _richTextRow(mech.name, mech.description ?? '');
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(indent: widget.indent, endIndent: widget.indent),
        SubTitleProduct(
          subtile: 'Dados do Jogo',
          color: primary,
        ),
        ListenableBuilder(
          listenable: store.state,
          builder: (context, _) {
            if (store.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (store.isSuccess) {
              if (boardgame == null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _loadBoardgame,
                      icon: Icon(Symbols.refresh_rounded),
                      label: Text('Carregar informações do jogo!'),
                    ),
                  ],
                );
              } else {
                return bgInfo();
              }
            } else if (store.isError) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                AppSnackbar.show(
                  context,
                  message: store.errorMessage ??
                      'Ocorreu um erro. Tente mais tarde.',
                  onClosed: store.setStateSuccess,
                );
              });
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _loadBoardgame,
                  icon: Icon(Symbols.refresh_rounded),
                  label: Text('Carregar informações do jogo!'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
