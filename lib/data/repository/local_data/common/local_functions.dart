import 'dart:developer';

import '../../../../core/abstracts/data_result.dart';

class LocalFunctions {
  LocalFunctions._();

  static DataResult<T> handleError<T>(
      String className, String module, Object error) {
    final fullMessage = '$className.$module: $error';
    log(fullMessage);
    return DataResult.failure(GenericFailure(message: fullMessage));
  }
}
