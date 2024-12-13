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
