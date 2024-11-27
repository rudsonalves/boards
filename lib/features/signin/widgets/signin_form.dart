import 'package:flutter/material.dart';

import '/components/form_fields/custom_form_field.dart';
import '/components/form_fields/password_form_field.dart';
import '../signin_store.dart';

class SignInForm extends StatefulWidget {
  final SignInStore store;
  final void Function() userLogin;
  final void Function() navLostPassword;

  const SignInForm({
    super.key,
    required this.store,
    required this.userLogin,
    required this.navLostPassword,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final passwordFocus = FocusNode();

  @override
  void dispose() {
    passwordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder(
            valueListenable: widget.store.errorEmail,
            builder: (context, errorEmail, _) {
              return CustomFormField(
                labelText: 'E-mail',
                hintText: 'seu-email@provedor.com',
                keyboardType: TextInputType.emailAddress,
                errorText: errorEmail,
                onChanged: widget.store.setEmail,
                nextFocusNode: passwordFocus,
              );
            }),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: widget.navLostPassword,
            child: Text(
              'Esqueceu a senha?',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: widget.store.errorPassword,
          builder: (context, errorPassword, _) {
            return PasswordFormField(
              labelText: 'Senha',
              errorText: errorPassword,
              onChanged: widget.store.setPassword,
              focusNode: passwordFocus,
              onFieldSubmitted: (value) => widget.userLogin(),
            );
          },
        ),
      ],
    );
  }
}
