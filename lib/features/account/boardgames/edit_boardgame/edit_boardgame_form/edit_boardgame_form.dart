import 'package:flutter/material.dart';

import '../../../mechanics/mechanics_screen.dart';
import '../edit_boardgame_store.dart';
import '../get_image/get_image.dart';
import 'edit_boardgame_form_controller.dart';
import '/core/theme/app_text_style.dart';
import '/components/form_fields/custom_form_field.dart';
import '/components/form_fields/custom_names_form_field.dart';
import '/components/widgets/image_view.dart';
import '/components/widgets/spin_box_field.dart';
import '../../../../shop/product/widgets/sub_title_product.dart';

class EditBoardgameForm extends StatefulWidget {
  final EditBoardgameStore store;

  const EditBoardgameForm({
    super.key,
    required this.store,
  });

  @override
  State<EditBoardgameForm> createState() => _EditBoardgameFormState();
}

class _EditBoardgameFormState extends State<EditBoardgameForm> {
  final ctrl = EditBoardgameFormController();
  EditBoardgameStore get store => widget.store;

  @override
  void initState() {
    super.initState();

    ctrl.init(store);
  }

  Future<void> _addMecanics() async {
    final mechPsIds = await Navigator.pushNamed(
      context,
      MechanicsScreen.routeName,
      arguments: store.bg.mechsPsIds,
    ) as List<String>?;

    if (mechPsIds != null) {
      ctrl.setMechanicsPsIds(mechPsIds);
      if (mounted) FocusScope.of(context).nextFocus();
    }
  }

  Future<void> _setImage() async {
    final result = await GetImage.openDialog(context);
    ctrl.setImage(result);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width * .8;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
            valueListenable: store.errorName,
            builder: (context, errorName, _) {
              return CustomNamesFormField(
                labelText: 'Nome do Jogo:',
                labelStyle: AppTextStyle.font18Bold.copyWith(
                  color: colorScheme.primary,
                ),
                hintText: 'Entre o nome do jogo aqui',
                controller: ctrl.nameController,
                names: ctrl.bgNames,
                fullBorder: false,
                textCapitalization: TextCapitalization.sentences,
                errorText: errorName,
                onChanged: store.setName,
              );
            }),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubTitleProduct(
                subtile: 'Publicado em: ',
                color: colorScheme.primary,
                padding: const EdgeInsets.only(top: 8, bottom: 0),
              ),
              SpinBoxField(
                value: 2020,
                minValue: 1978,
                maxValue: DateTime.now().year,
                controller: ctrl.yearController,
                onChange: store.setPublishYear,
              ),
            ],
          ),
        ),
        Ink(
          width: width,
          height: width,
          child: ListenableBuilder(
            listenable: ctrl.imageController,
            builder: (context, _) {
              return InkWell(
                onTap: _setImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ImageView(
                      image: ctrl.imageController.text,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubTitleProduct(
                subtile: '# de Jogadores:',
                color: colorScheme.primary,
                padding: const EdgeInsets.only(top: 8, bottom: 0),
              ),
              SpinBoxField(
                value: 2,
                controller: ctrl.minPlayersController,
                onChange: store.setMinPlayers,
              ),
              const Text('-'),
              SpinBoxField(
                value: 4,
                controller: ctrl.maxPlayersController,
                onChange: store.setMaxPlayers,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubTitleProduct(
                subtile: 'Tempo (min):',
                color: colorScheme.primary,
                padding: const EdgeInsets.only(top: 8, bottom: 0),
              ),
              SpinBoxField(
                value: 25,
                minValue: 12,
                maxValue: 360,
                controller: ctrl.minTimeController,
                onChange: store.setMinTime,
              ),
              const Text('-'),
              SpinBoxField(
                value: 50,
                minValue: 12,
                maxValue: 720,
                controller: ctrl.maxTimeController,
                onChange: store.setMaxTime,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubTitleProduct(
              subtile: 'Idade mínima: ',
              color: colorScheme.primary,
              padding: const EdgeInsets.only(top: 8, bottom: 0),
            ),
            SpinBoxField(
              value: 10,
              minValue: 3,
              maxValue: 25,
              controller: ctrl.ageController,
              onChange: store.setMinAge,
            ),
          ],
        ),
        Card(
          color: colorScheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomFormField(
              labelText: 'Designer(s):',
              labelStyle: AppTextStyle.font18Bold.copyWith(
                color: colorScheme.primary,
              ),
              fullBorder: false,
              controller: ctrl.designerController,
              onChanged: store.setDesigner,
            ),
          ),
        ),
        Card(
          color: colorScheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomFormField(
              labelText: 'Artista(s):',
              labelStyle: AppTextStyle.font18Bold.copyWith(
                color: colorScheme.primary,
              ),
              fullBorder: false,
              controller: ctrl.artistController,
              onChanged: store.setArtist,
              nextFocusNode: ctrl.descriptionFocus,
            ),
          ),
        ),
        Card(
          color: colorScheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ValueListenableBuilder(
                valueListenable: store.errorDescription,
                builder: (context, errorDescription, _) {
                  return CustomFormField(
                    // FIXME: This was a CustomLongFormField
                    focusNode: ctrl.descriptionFocus,
                    labelText: 'Descrição:',
                    labelStyle: AppTextStyle.font18Bold.copyWith(
                      color: colorScheme.primary,
                    ),
                    controller: ctrl.descriptionController,
                    onChanged: store.setDescription,
                    errorText: errorDescription,
                    fullBorder: false,
                    maxLines: null,
                  );
                }),
          ),
        ),
        InkWell(
          onTap: _addMecanics,
          child: AbsorbPointer(
            child: Card(
              color: colorScheme.surfaceContainerHigh,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ValueListenableBuilder(
                    valueListenable: store.errorMechsPsIds,
                    builder: (context, errorMechsPsIds, _) {
                      return CustomFormField(
                        labelText: 'Mecânicas *',
                        labelStyle: AppTextStyle.font18Bold.copyWith(
                          color: colorScheme.primary,
                        ),
                        controller: ctrl.mechsController,
                        errorText: errorMechsPsIds,
                        fullBorder: false,
                        maxLines: null,
                        floatingLabelBehavior: null,
                        readOnly: true,
                        suffixIcon: const Icon(Icons.ads_click),
                      );
                    }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
