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

import '../../../data/repository/interfaces/remote/i_user_repository.dart';
import '../../../data/models/user.dart';
import '../../../core/singletons/app_settings.dart';
import '../../../core/get_it.dart';
import 'signup_store.dart';

class SignupController {
  late final SignupStore store;

  final app = getIt<AppSettings>();
  final userRepository = getIt<IUserRepository>();

  void init(SignupStore store) {
    this.store = store;
  }

  void dispose() {}

  Future<UserModel?> signupUser() async {
    try {
      store.setStateLoading();
      final user = UserModel(
        name: store.name!,
        email: store.email!,
        phone: store.phone!,
        password: store.password!,
      );

      final result = await userRepository.signUp(user);
      if (result.isFailure) {
        throw Exception(result.error!.message);
      }
      final newUser = result.data;
      store.setStateSuccess();
      return newUser;
    } catch (err) {
      store.setError('Ocorreu um erro. Tente mais tarde.');
      throw Exception(err);
    }
  }
}
