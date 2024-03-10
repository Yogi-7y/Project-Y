// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

typedef AsyncResult<S> = Future<Result<S>>;

/// A class that is a union of [Success] and [Failure] classes.
@immutable
abstract class Result<S> {
  /// Returns `true` if this is a [Success] otherwise `false`.
  bool get isSuccess => this is Success<S>;

  S? get valueOrNull => isSuccess ? (this as Success<S>).value : null;

  void when({
    required void Function(S? value) success,
    required void Function(String message, Object? error, StackTrace? stackTrace) failure,
  }) {
    if (this is Success<S>) {
      success((this as Success<S>).value);
    } else {
      final _failure = this as Failure<S>;
      failure(_failure.message, _failure.error, _failure.stackTrace);
    }
  }
}

/// {@template result_success}
/// Success representation of a [Result].
/// {@endtemplate}
@immutable
class Success<S> extends Result<S> {
  /// {@macro result_success}
  Success(this.value);

  /// The value of the [Result].
  final S? value;
}

/// {@template result_failure}
/// Failure representation of a [Result].
/// {@endtemplate}
@immutable
class Failure<S> extends Result<S> {
  /// {@macro result_failure}
  Failure({
    this.message = 'Something went wrong! Please try again later.',
    this.error,
    this.stackTrace,
  });

  /// User friendly message.
  final String message;

  /// The error object.
  final Object? error;

  /// The stack trace of the error.
  final StackTrace? stackTrace;
}
