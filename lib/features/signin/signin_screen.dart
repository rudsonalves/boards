import 'package:flutter/material.dart';

import '../../components/buttons/big_button.dart';
import '../../components/widgets/state_error_message.dart';
import '../../components/widgets/state_loading_message.dart';
import '../signup/signup_screen.dart';
import 'signin_controller.dart';
import 'signin_store.dart';
import 'widgets/signin_form.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/signin';
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final ctrl = SignInController();
  final store = SignInStore();

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

  Future<void> _userLogin() async {
    if (store.isValid()) {
      final result = await ctrl.login();
      if (result) {
        if (mounted) Navigator.pop(context);
      }
    }
  }

  void _navSignUp() {
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      SignUpScreen.routeName,
    );
  }

  Future<void> _navLostPassword() async {
    final result = await ctrl.recoverPassword();
    if (result == RecoverStatus.success) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => StateErrorMessage(
          message: 'Uma mensagem foi enviada para a sua caixa de email'
              ' ${store.email}. Acesse para alterar sua senha',
          icon: const Icon(
            Icons.warning,
            color: Colors.green,
            size: 60,
          ),
          closeDialog: Navigator.of(context).pop,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor:
          ctrl.app.isDark ? null : colorScheme.onPrimary.withOpacity(0.85),
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: store.state,
        builder: (context, state, _) {
          return Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: SingleChildScrollView(
                    child: Card(
                      color: ctrl.app.isDark
                          ? colorScheme.primary.withOpacity(.15)
                          : null,
                      margin: const EdgeInsets.all(20),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // BigButton(
                            //   color: Colors.blue,
                            //   label: 'Entrar com Facebook',
                            //   onPressed: () {
                            //     throw Exception('Has not yet been implemented');
                            //   },
                            // ),
                            // const OrRow(),
                            SignInForm(
                              store: store,
                              userLogin: _userLogin,
                              navLostPassword: _navLostPassword,
                            ),
                            BigButton(
                              color: Colors.amber,
                              label: 'Entrar',
                              onPressed: _userLogin,
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Não possui uma conta?'),
                                TextButton(
                                  onPressed: _navSignUp,
                                  child: const Text('Cadastrar'),
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
                  child: StateLoadingMessage(),
                ),
              if (store.isError)
                Positioned.fill(
                  child: StateErrorMessage(
                    message: store.errorMessage,
                    closeDialog: ctrl.closeErroMessage,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
