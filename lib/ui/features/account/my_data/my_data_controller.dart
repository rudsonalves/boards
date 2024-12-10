import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../data/repository/interfaces/remote/i_user_repository.dart';
import '../../../../data/models/user.dart';
import '/core/utils/extensions.dart';
import '../../../../data/models/address.dart';
import '/core/singletons/current_user.dart';
import '../../../components/form_controllers/masked_text_controller.dart';
import '../../../../core/get_it.dart';
import '../../../../logic/managers/addresses_manager.dart';

class MyDataController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(##) ####-#####');
  final passwordController = TextEditingController();
  final checkPasswordController = TextEditingController();

  final passwordFocusNode = FocusNode();

  final user = getIt<CurrentUser>().user!;
  final userRepository = getIt<IUserRepository>();

  final addressManager = getIt<AddressesManager>();
  List<AddressModel> get addresses => addressManager.addresses;
  List<String> get addressNames => addressManager.addressNames.toList();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    checkPasswordController.dispose();
    passwordFocusNode.dispose();

    super.dispose();
  }

  void init() {
    nameController.text = user.name ?? '';
    phoneController.text = user.phone ?? '';
  }

  bool get haveChanges {
    return (nameController.text.isNotEmpty &&
            nameController.text != user.name) ||
        (phoneController.text.isNotEmpty &&
            phoneController.text.onlyNumbers() != user.phone!.onlyNumbers()) ||
        (passwordController.text.trim().isNotEmpty &&
            checkPasswordController.text.trim().isNotEmpty &&
            passwordController.text.trim() ==
                checkPasswordController.text.trim());
  }

  bool get valid {
    return (formKey.currentState != null && formKey.currentState!.validate());
  }

  Future<void> updateUserData() async {
    try {
      final newName = nameController.text.trim();
      final newPhone = phoneController.text;
      final newPass = passwordController.text.trim();

      if (haveChanges && valid) {
        final newUser = UserModel(email: 'none@none');
        newUser.id = user.id;
        newUser.name =
            newName.isNotEmpty && newName != user.name ? newName : null;
        newUser.phone = newPhone.isNotEmpty &&
                newPhone.onlyNumbers() != user.phone!.onlyNumbers()
            ? newPhone
            : null;
        newUser.password = newPass.isNotEmpty ? newPass : null;

        final result = await userRepository.updatePassword(newUser);
        if (result.isFailure) {
          throw Exception(result.error!.message);
        }

        user.name = newUser.name ?? user.name;
        user.phone = newUser.phone ?? user.phone;
      }
    } catch (err) {
      log(err.toString());
    }
  }
}
