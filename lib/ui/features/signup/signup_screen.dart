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

import '../../components/buttons/big_button.dart';
import '../../components/dialogs/simple_message.dart';
import '../signin/signin_screen.dart';
import 'signup_controller.dart';
import 'signup_store.dart';
import 'widgets/signup_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/signup';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final store = SignupStore();
  final ctrl = SignupController();

  @override
  void initState() {
    super.initState();

    ctrl.init(store);
  }

  @override
  void dispose() {
    ctrl.dispose();

    super.dispose();
  }

  Future<void> _signupUser() async {
    if (store.isValid()) {
      try {
        final user = await ctrl.signupUser();
        if (user == null || user.id == null) {
          throw Exception('-1	Error code indicating that an unknown error or an'
              ' error unrelated to Parse occurred.');
        }

        if (!mounted) return;
        await SimpleMessage.open(
          context,
          title: 'Usuário Criado',
          message: 'Sua conta foi criada com sucesso.'
              ' Verifique a sua caixa de mensagem (${user.email}) para'
              ' confirmar seu cadastro.',
        );
        if (mounted) Navigator.pop(context);
        return;
      } catch (err) {
        if (!mounted) return;
        await SimpleMessage.open(
          context,
          title: 'Ocorreu um Error',
          message: 'ParserServerErrors.message(err.toString())',
          type: MessageType.error,
        );

        return;
      }
    }
  }

  void _navLogin() {
    Navigator.pop(context);
    Navigator.pushNamed(context, SignInScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: ctrl.app.isDark
          ? null
          : colorScheme.onPrimary.withValues(alpha: 0.85),
      appBar: AppBar(
        title: const Text('Cadastrar'),
        centerTitle: true,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: ListenableBuilder(
        listenable: store.state,
        builder: (context, _) {
          return Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: SingleChildScrollView(
                    child: Card(
                      color: ctrl.app.isDark
                          ? colorScheme.primary.withValues(alpha: .15)
                          : null,
                      margin: const EdgeInsets.all(20),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // BigButton(
                            //   color: Colors.blue,
                            //   label: 'Cadastrar com Facebook',
                            //   onPressed: () {},
                            // ),
                            // const OrRow(),
                            SignUpForm(
                              store: store,
                              signupUser: _signupUser,
                            ),
                            BigButton(
                              color: Colors.amber,
                              label: 'Registrar',
                              onPressed: _signupUser,
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Possui uma conta?'),
                                TextButton(
                                  onPressed: _navLogin,
                                  child: const Text('Entrar'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (store.isLoading)
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (store.isError)
                Positioned.fill(
                  child: Center(
                    child: Text(store.errorMessage.toString()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
