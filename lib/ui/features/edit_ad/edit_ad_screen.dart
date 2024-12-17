import 'package:flutter/material.dart';

import '../../../data/models/ad.dart';
import '../../components/buttons/big_button.dart';
import '../../components/state_messages/state_error_message.dart';
import '../../components/state_messages/state_loading_message.dart';
import 'edit_ad_controller.dart';
import 'edit_ad_form/edit_ad_form.dart';
import 'edit_ad_store.dart';
import 'image_list/image_list_view.dart';

class EditAdScreen extends StatefulWidget {
  final AdModel? ad;

  const EditAdScreen({
    super.key,
    this.ad,
  });

  static const routeName = '/insert_ad';

  @override
  State<EditAdScreen> createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditAdScreen> {
  final store = EditAdStore();
  final ctrl = EditAdController();

  @override
  void initState() {
    super.initState();

    store.init(widget.ad);
    ctrl.init(store);
  }

  @override
  void dispose() {
    ctrl.dispoase();
    store.dispose();

    super.dispose();
  }

  Future<void> _saveAd() async {
    if (store.isValid) {
      FocusScope.of(context).unfocus();
      final result = await ctrl.saveAd();
      if (result.isFailure) {
        store.setStateSuccess();
        return;
      }
      if (mounted) Navigator.pop(context, store.ad);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ad != null ? 'Editar Anúncio' : 'Criar Anúncio'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: store.state,
        builder: (context, _, __) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImagesListView(
                        store: store,
                      ),
                      Column(
                        children: [
                          EditAdForm(store: store, ctrl: ctrl),
                          BigButton(
                            color: Colors.orange,
                            label: widget.ad != null ? 'Atualizar' : 'Salvar',
                            iconData:
                                widget.ad != null ? Icons.update : Icons.save,
                            onPressed: _saveAd,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (store.isLoading) const StateLoadingMessage(),
              if (store.isError)
                StateErrorMessage(
                  message: store.errorMessage,
                  closeDialog: store.setStateSuccess,
                ),
            ],
          );
        },
      ),
      // ),
    );
  }
}