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

// class SerializationException extends AppException {
//   const SerializationException({
//     required super.consoleMessage,
//     super.userFriendlyMessage,
//     super.code,
//   });
// }

// enum AppExceptionCode {
//   defaultCode(code: 'default_code'),

//   /// Used during serialization when a key is expected but not found
//   missingKey(code: 'missing_key');

//   const AppExceptionCode({required this.code});

//   final String code;
// }
