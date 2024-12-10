import 'dart:developer';

import 'package:boards/core/abstracts/data_result.dart';

class DataFunctions {
  DataFunctions._();

  /// Handles errors by logging and wrapping them in a [DataResult] failure
  /// response.
  ///
  /// This method takes the name of the method where the error occurred and the
  /// actual error object.
  /// It logs a detailed error message and returns a failure wrapped in
  /// [DataResult].
  ///
  /// Parameters:
  /// - [className]: The name of the class where error occurred.
  /// - [method]: The name of the method where the error occurred.
  /// - [error]: The error object that describes what went wrong.
  ///
  /// Returns:
  /// A [DataResult.failure] with a [GenericFailure] that includes a detailed
  /// message.
  static DataResult<T> handleError<T>(
    String className,
    String module,
    Object error, [
    int? code,
  ]) {
    final fullMessage = '$className.$module: $error';
    log(fullMessage);
    return DataResult.failure(GenericFailure(
      message: fullMessage,
      code: code ?? 0,
    ));
  }
}
