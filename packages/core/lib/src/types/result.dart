import 'package:meta/meta.dart';

import '../../core_y.dart';

/// Type alias for asynchronous Result operations
///
/// Useful when working with methods that return a Future<Result>
typedef AsyncResult<S, E extends AppException> = Future<Result<S, E>>;

/// Callback type for synchronous success operations in [Result.fold]
///
/// [S] is the success value type
/// [T] is the return type of the callback
typedef SyncSuccessCallback<S, T> = T Function(S value);

/// Callback type for synchronous failure operations in [Result.fold]
///
/// [E] is the error type, constrained to [AppException]
/// [T] is the return type of the callback
typedef SyncFailureCallback<E extends AppException, T> = T Function(E error);

/// Callback type for asynchronous success operations in [Result.asyncFold]
///
/// [S] is the success value type
/// [T] is the return type of the callback wrapped in a Future
typedef AsyncSuccessCallback<S, T> = Future<T> Function(S value);

/// Callback type for failure operations in [Result.asyncFold]
/// Note: This remains synchronous as error handling typically doesn't need to be async
///
/// [E] is the error type, constrained to [AppException]
/// [T] is the return type of the callback
typedef AsyncFailureCallback<E extends AppException, T> = T Function(E error);

/// A type that represents either a success value of type [S] or a failure value of type [E].
///
/// This implementation is based on the Either monad pattern, commonly used for error handling
/// in functional programming. It forces explicit handling of both success and failure cases,
/// making error handling more predictable and type-safe.
///
/// Type parameters:
/// * [S]: The type of the success value
/// * [E]: The type of the error value, must extend [AppException]
@immutable
sealed class Result<S, E extends AppException> {
  const Result();

  /// Whether this instance represents a successful result
  bool get isSuccess => this is Success<S, E>;

  /// Whether this instance represents a failed result
  bool get isFailure => this is Failure<S, E>;

  /// Returns the success value if present, null otherwise
  ///
  /// This is a convenience method for cases where null is an acceptable fallback.
  /// For more robust error handling, prefer using [fold] or [asyncFold].
  S? get valueOrNull => isSuccess ? (this as Success<S, E>).value : null;

  /// Transforms this result into a value of type [T] by applying the appropriate callback
  /// based on whether this is a success or failure.
  ///
  /// This method only accepts synchronous callbacks. For async operations, use [asyncFold].
  ///
  /// Example:
  /// ```dart
  /// final result = Success(42);
  /// final string = result.fold(
  ///   onSuccess: (value) => 'Success: $value',
  ///   onFailure: (error) => 'Error: ${error.message}',
  /// );
  /// ```
  T fold<T>({
    required SyncSuccessCallback<S, T> onSuccess,
    required SyncFailureCallback<E, T> onFailure,
  });

  /// Asynchronous version of [fold] that handles Future operations in the success case.
  ///
  /// This is particularly useful when the success transformation needs to perform
  /// asynchronous operations. The failure callback remains synchronous as error
  /// handling typically doesn't need to be async.
  ///
  /// Example:
  /// ```dart
  /// final result = Success(userId);
  /// final userDetails = await result.asyncFold(
  ///   onSuccess: (id) async => await fetchUserDetails(id),
  ///   onFailure: (error) => UserDetails.empty(),
  /// );
  /// ```
  Future<T> asyncFold<T>({
    required AsyncSuccessCallback<S, T> onSuccess,
    required AsyncFailureCallback<E, T> onFailure,
  });

  /// Transforms the success value of this result while preserving the Result wrapper.
  ///
  /// If this is a failure, the error is preserved and the transform is not applied.
  ///
  /// Example:
  /// ```dart
  /// final result = Success(42);
  /// final doubled = result.map((value) => value * 2); // Success(84)
  /// ```
  Result<T, E> map<T>(T Function(S value) transform);
}

/// Represents a successful result containing a value of type [S].
final class Success<S, E extends AppException> extends Result<S, E> {
  const Success(this.value);

  /// The success value
  final S value;

  @override
  T fold<T>({
    required SyncSuccessCallback<S, T> onSuccess,
    required SyncFailureCallback<E, T> onFailure,
  }) =>
      onSuccess(value);

  @override
  Future<T> asyncFold<T>({
    required AsyncSuccessCallback<S, T> onSuccess,
    required AsyncFailureCallback<E, T> onFailure,
  }) async {
    try {
      return await onSuccess(value);
    } catch (e, stackTrace) {
      if (e is E) {
        return onFailure(e);
      }
      // If it's not the expected exception type, wrap it in AppException
      return onFailure(AppException(
        exception: e.toString(),
        stackTrace: stackTrace,
      ) as E);
    }
  }

  @override
  Result<T, E> map<T>(T Function(S value) transform) => Success(transform(value));
}

/// Represents a failed result containing an error of type [E].
final class Failure<S, E extends AppException> extends Result<S, E> {
  const Failure(this.error);

  /// The error value
  final E error;

  @override
  T fold<T>({
    required SyncSuccessCallback<S, T> onSuccess,
    required SyncFailureCallback<E, T> onFailure,
  }) =>
      onFailure(error);

  @override
  Future<T> asyncFold<T>({
    required AsyncSuccessCallback<S, T> onSuccess,
    required AsyncFailureCallback<E, T> onFailure,
  }) async =>
      onFailure(error);

  @override
  Result<T, E> map<T>(T Function(S value) transform) => Failure(error);
}
