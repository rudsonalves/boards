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
