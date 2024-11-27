import '../../repository/data/interfaces/i_user_repository.dart';
import '../../core/abstracts/data_result.dart';
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

  Future<DataResult<void>> login() async {
    store.setStateLoading();
    final user = UserModel(
      email: store.email!,
      password: store.password!,
    );
    final result = await userRepository.signInWithEmail(user);
    if (result.isFailure) {
      store.setError(result.error!.message!);
      return DataResult.failure(const GenericFailure());
    }
    final newUser = result.data;
    currentUser.init(newUser);
    store.setStateSuccess();
    return DataResult.success(null);
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
    final result = await userRepository.resetPassword(store.email!);
    if (result.isFailure) {
      store.setError(result.error!.message!);
      return RecoverStatus.error;
    }
    store.setStateSuccess();
    return RecoverStatus.success;
  }
}
