import 'package:meta/meta.dart';

import '../../core_y.dart';

typedef AsyncResult<S, E extends AppException> = Future<Result<S, E>>;

@immutable
sealed class Result<S, E extends AppException> {
  const Result();

  bool get isSuccess => this is Success<S, E>;
  bool get isFailure => this is Failure<S, E>;

  S? get valueOrNull => isSuccess ? (this as Success<S, E>).value : null;

  /// Ensures that all the states are handled and returns a common type.
  T fold<T>({
    required T Function(S value) onSuccess,
    required T Function(E error) onFailure,
  });

  Result<T, E> map<T>(T Function(S value) transform);
}

final class Success<S, E extends AppException> extends Result<S, E> {
  const Success(this.value);

  final S value;

  @override
  T fold<T>({
    required T Function(S value) onSuccess,
    required T Function(E error) onFailure,
  }) =>
      onSuccess(value);

  @override
  Result<T, E> map<T>(T Function(S value) transform) => Success(transform(value));
}

final class Failure<S, E extends AppException> extends Result<S, E> {
  const Failure(this.error);

  final E error;

  @override
  T fold<T>({
    required T Function(S value) onSuccess,
    required T Function(E error) onFailure,
  }) =>
      onFailure(error);

  @override
  Result<T, E> map<T>(T Function(S value) transform) => Failure(error);
}
