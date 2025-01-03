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

// The code below was inspired by my swift implementation
// https://gist.github.com/CassiusPacheco/4378d30d69316e4a6ba28a0c3af72628
// and Avdosev's Dart Either
// https://github.com/avdosev/either_dart/blob/master/lib/src/either.dart
// Article:
// https://cassiuspacheco.com/result-dataerror-wrapper-in-dart-for-flutter

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  final String? message;
  final int code;

  const Failure({
    this.message,
    this.code = 0,
  });

  @override
  String toString() =>
      '$runtimeType Exception${message != null ? ': $message' : ''}';

  @override
  List<Object?> get props => [message];
}

// General failures
class GenericFailure extends Failure {
  const GenericFailure({super.message, super.code});
}

class APIFailure extends Failure {
  const APIFailure({super.message, super.code});
}

class TimeoutFailure extends GenericFailure {
  const TimeoutFailure({super.message, super.code});
}

/// This abstraction contains either a success data of generic type `S` or a
/// failure error of type `Failure` as its result.
///
/// `data` property must only be retrieved when `DataResult` was constructed by
/// using `DataResult.success(value)`. It can be validated by calling
/// `isSuccess` first. Alternatively, `dataOrElse` can be used instead since it
/// ensures a valid value is returned in case the result is a failure.
///
/// `error` must only be retrieved when `DataResult` was constructed by using
/// `DataResult.failure(error)`. It can be validated by calling `isFailure`
/// first.
abstract class DataResult<S> extends Equatable {
  static DataResult<S> failure<S>(Failure failure) => _FailureResult(failure);
  static DataResult<S> success<S>(S data) => _SuccessResult(data);

  /// Get [error] value, returns null when the value is actually [data]
  Failure? get error => fold<Failure?>((error) => error, (data) => null);

  /// Get [data] value, returns null when the value is actually [error]
  S? get data => fold<S?>((error) => null, (data) => data);

  /// Returns `true` if the object is of the `SuccessResult` type, which means
  /// `data` will return a valid result.
  bool get isSuccess => this is _SuccessResult<S>;

  /// Returns `true` if the object is of the `FailureResult` type, which means
  /// `error` will return a valid result.
  bool get isFailure => this is _FailureResult<S>;

  /// Returns `data` if `isSuccess` returns `true`, otherwise it returns
  /// `other`.
  S dataOrElse(S other) => isSuccess && data != null ? data! : other;

  /// Sugar syntax that calls `dataOrElse` under the hood. Returns left value if
  /// `isSuccess` returns `true`, otherwise it returns the right value.
  S operator |(S other) => dataOrElse(other);

  /// Transforms values of [error] and [data] in new a `DataResult` type. Only
  /// the matching function to the object type will be executed. For example,
  /// for a `SuccessResult` object only the [fnData] function will be executed.
  DataResult<T> either<T>(
      Failure Function(Failure error) fnFailure, T Function(S data) fnData);

  /// Transforms value of [data] allowing a new `DataResult` to be returned.
  /// A `SuccessResult` might return a `FailureResult` and vice versa.
  DataResult<T> then<T>(DataResult<T> Function(S data) fnData);

  /// Transforms value of [data] always keeping the original identity of the
  /// `DataResult`, meaning that a `SuccessResult` returns a `SuccessResult` and
  /// a `FailureResult` always returns a `FailureResult`.
  DataResult<T> map<T>(T Function(S data) fnData);

  /// Folds [error] and [data] into the value of one type. Only the matching
  /// function to the object type will be executed. For example, for a
  /// `SuccessResult` object only the [onSuccess] function will be executed.
  T fold<T>(T Function(Failure error) onFailure, T Function(S data) onSuccess);

  void when({
    required void Function(S data) onSuccess,
    required void Function(Failure error) onFailure,
  }) {
    fold(onFailure, onSuccess);
  }

  @override
  List<Object?> get props => [if (isSuccess) data else error];
}

/// Success implementation of `DataResult`. It contains `data`. It's abstracted
/// away by `DataResult`. It shouldn't be used directly in the app.
class _SuccessResult<S> extends DataResult<S> {
  final S _value;

  _SuccessResult(this._value);

  @override
  _SuccessResult<T> either<T>(
      Failure Function(Failure error) fnFailure, T Function(S data) fnData) {
    return _SuccessResult<T>(fnData(_value));
  }

  @override
  DataResult<T> then<T>(DataResult<T> Function(S data) fnData) {
    return fnData(_value);
  }

  @override
  _SuccessResult<T> map<T>(T Function(S data) fnData) {
    return _SuccessResult<T>(fnData(_value));
  }

  @override
  T fold<T>(T Function(Failure error) onFailure, T Function(S data) onSuccess) {
    return onSuccess(_value);
  }
}

/// Failure implementation of `DataResult`. It contains `error`.  It's
/// abstracted away by `DataResult`. It shouldn't be used directly in the app.
class _FailureResult<S> extends DataResult<S> {
  final Failure _value;

  _FailureResult(this._value);

  @override
  _FailureResult<T> either<T>(
      Failure Function(Failure error) fnFailure, T Function(S data) fnData) {
    return _FailureResult<T>(fnFailure(_value));
  }

  @override
  _FailureResult<T> map<T>(T Function(S data) fnData) {
    return _FailureResult<T>(_value);
  }

  @override
  _FailureResult<T> then<T>(DataResult<T> Function(S data) fnData) {
    return _FailureResult<T>(_value);
  }

  @override
  T fold<T>(T Function(Failure error) onFailure, T Function(S data) onSuccess) {
    return onFailure(_value);
  }
}
