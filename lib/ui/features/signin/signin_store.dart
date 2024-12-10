import 'package:flutter/material.dart';

import '../../../core/utils/validators.dart';
import '../../components/state/state_store.dart';

class SignInStore extends StateStore {
  final errorEmail = ValueNotifier<String?>(null);
  final errorPassword = ValueNotifier<String?>(null);

  String? email;
  String? password;

  @override
  void dispose() {
    super.dispose();
    errorEmail.dispose();
    errorPassword.dispose();
  }

  void setEmail(String value) {
    email = value;
    validateEmail();
  }

  void validateEmail() {
    errorEmail.value = Validator.email(email);
  }

  void setPassword(String value) {
    password = value;
    validatePassword();
  }

  void validatePassword() {
    errorPassword.value = Validator.password(password);
  }

  bool isValid() {
    validateEmail();
    validatePassword();

    return errorEmail.value == null && errorPassword.value == null;
  }
}
