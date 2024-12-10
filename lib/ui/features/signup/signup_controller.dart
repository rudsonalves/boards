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
