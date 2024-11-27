import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '/components/widgets/state_error_message.dart';
import '/components/widgets/state_count_loading_message.dart';
import 'check_controller.dart';
import 'check_store.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  static const routeName = '/check_page';

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  final store = CheckStore();
  final ctrl = CheckController();

  @override
  void initState() {
    super.initState();

    ctrl.init(store);
  }

  @override
  void dispose() {
    store.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar Mecânicas'),
        centerTitle: true,
        elevation: 5,
      ),
      body: ListenableBuilder(
        listenable: store.state,
        builder: (context, _) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                          'Os dados das mecânicas locais serão comparadas com'
                          ' os do servidor Parse Server'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text('No momento existem ${ctrl.mechanics.length}'
                          ' mecânicas no arquivo local.'),
                    ),
                    Row(
                      children: [
                        const Text('Reiniciar Mecânicas'),
                        const Spacer(),
                        FilledButton.tonalIcon(
                          onPressed: ctrl.resetMechanics,
                          label: const Text('Resetar'),
                          icon: const Icon(Symbols.sync_rounded),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Verificar'),
                        const Spacer(),
                        FilledButton.tonalIcon(
                          onPressed: ctrl.checkMechanics,
                          label: const Text('Iniciar'),
                          icon: const Icon(Symbols.sync_rounded),
                        ),
                        const Spacer(),
                      ],
                    ),
                    ValueListenableBuilder(
                      valueListenable: store.checkList,
                      builder: (context, checkList, _) => Expanded(
                        child: ListView.builder(
                          itemCount: checkList.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: Text(checkList[index].mech.id!),
                            title: Text(checkList[index].mech.name),
                            trailing: checkList[index].isChecked
                                ? Icon(Icons.check, color: Colors.green)
                                : Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (store.isLoading)
                ValueListenableBuilder(
                  valueListenable: store.count,
                  builder: (context, value, _) {
                    int length = store.counterMax;
                    length = length != 0 ? length : 1;
                    return StateCountLoadingMessage(
                      maxCount: length,
                      value: value,
                    );
                  },
                ),
              if (store.isError)
                StateErrorMessage(
                  message: store.errorMessage,
                  closeDialog: store.setStateSuccess,
                ),
            ],
          );
        },
      ),
    );
  }
}
