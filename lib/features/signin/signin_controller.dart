import '../../repository/data/interfaces/i_user_repository.dart';
import '../../core/models/user.dart';
import '../../core/singletons/app_settings.dart';
import '../../core/singletons/current_user.dart';
import '../../get_it.dart';
import 'signin_store.dart';

enum RecoverStatus { error, success, fail }

class SignInController {
  late final SignInStore store;
  final userRepository = getIt<IUserRepository>();

  final app = getIt<AppSettings>();
  final currentUser = getIt<CurrentUser>();

  init(SignInStore store) {
    this.store = store;
  }

  Future<bool> login() async {
    store.setStateLoading();
    final user = UserModel(
      email: store.email!,
      password: store.password!,
    );
    final result = await userRepository.signInWithEmail(user);
    if (result.isFailure) {
      switch (result.error!.code) {
        case 201:
          store.setError('Desculpe, ocorreu um erro. Tente mais tarde.');
          break;
        case 202:
          store.setError(
              'Sua conta ainda não foi verificada. Cheque seu email.');
          break;
        case 203:
        case 204:
          store.setError('Usuário ou email desconhecidos.');
          break;
        case 205:
        case 206:
        default:
          store.setEmail('Estamos com algum problema. Tente mais tarde.');
      }
      return false;
    }
    final newUser = result.data;
    currentUser.initialize(newUser);
    store.setStateSuccess();
    return true;
  }

  void closeErroMessage() {
    store.setStateSuccess();
  }

  Future<RecoverStatus> recoverPassword() async {
    store.setStateLoading();
    store.validateEmail();
    if (store.errorEmail.value != null) {
      store.setStateSuccess();
      return RecoverStatus.fail;
    }
    final result = await userRepository.requestResetPassword(store.email!);
    if (result.isFailure) {
      store.setError(result.error!.message!);
      return RecoverStatus.error;
    }
    store.setStateSuccess();
    return RecoverStatus.success;
  }
}
