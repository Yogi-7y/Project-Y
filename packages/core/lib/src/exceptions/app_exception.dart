// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:meta/meta.dart';

@immutable
class AppException implements Exception {
  const AppException({
    required this.exception,
    required this.stackTrace,
    this.userFriendlyMessage = 'Something went wrong. Please try again later.',
  });

  factory AppException.fromException(Exception e, StackTrace s) {
    return AppException(
      exception: e,
      stackTrace: s,
    );
  }

  /// User-friendly message
  final String userFriendlyMessage;

  final Object? exception;

  final StackTrace stackTrace;
}
