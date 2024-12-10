import 'package:flutter/material.dart';

import '/core/utils/validators.dart';
import '../../../components/buttons/big_button.dart';
import '../../../components/dialogs/simple_question.dart';
import '../../../components/form_fields/custom_form_field.dart';
import '../../../components/form_fields/password_form_field.dart';
import '../../shop/widgets/ad_text_subtitle.dart';
import 'my_data_controller.dart';

class MyDataScreen extends StatefulWidget {
  const MyDataScreen({super.key});

  static const routeName = '/mydata';

  @override
  State<MyDataScreen> createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen> {
  final ctrl = MyDataController();

  @override
  void initState() {
    super.initState();

    ctrl.init();
  }

  Future<void> backScreen() async {
    if (ctrl.haveChanges) {
      final result = await SimpleQuestionDialog.open(
        context,
        title: 'Atenção',
        message:
            'Houve alterações nos atributos do usuário.\nDeseja descartar as alterações?',
      );

      if (result) {
        if (ctrl.valid) {
          ctrl.updateUserData();
        } else {
          return;
        }
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Dados'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: backScreen,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: ctrl.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomFormField(
                      labelText: 'Nome',
                      hintText: 'Como aparecerá em seus anúncios',
                      controller: ctrl.nameController,
                      validator: DataValidator.name,
                      fullBorder: false,
                    ),
                    CustomFormField(
                      labelText: 'Telefone',
                      hintText: '(19) 9999-9999',
                      controller: ctrl.phoneController,
                      validator: DataValidator.phone,
                      keyboardType: TextInputType.phone,
                      fullBorder: false,
                    ),
                    PasswordFormField(
                      labelText: 'Nova Senha',
                      hintText: '6+ letras e números',
                      passwordController: ctrl.passwordController,
                      validator: DataValidator.password,
                      textInputAction: TextInputAction.next,
                      nextFocusNode: ctrl.passwordFocusNode,
                      fullBorder: false,
                    ),
                    PasswordFormField(
                      labelText: 'Confirmar nova senha',
                      hintText: '6+ letras e números',
                      passwordController: ctrl.checkPasswordController,
                      focusNode: ctrl.passwordFocusNode,
                      fullBorder: false,
                      validator: (value) => DataValidator.checkPassword(
                        ctrl.passwordController.text,
                        value,
                      ),
                    ),
                    BigButton(
                      color: Colors.blue.withOpacity(0.75),
                      label: 'Salvar Alterações',
                      onPressed: () {
                        Navigator.pop(context);
                        ctrl.updateUserData();
                      },
                    ),
                    const Divider(),
                    const AdTextSubtitle('Endereços:'),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: ctrl.addressNames.length,
                        itemBuilder: (context, index) {
                          final address = ctrl.addresses[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(address.name),
                                subtitle: Text(
                                  address.addressString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
