// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:meta/meta.dart';

@immutable
class AppException implements Exception {
  const AppException({
    required this.consoleMessage,
    this.code = AppExceptionCode.defaultCode,
    this.message = 'Something went wrong. Please try again later.',
  });

  final AppExceptionCode code;

  /// User-friendly message
  final String message;

  /// Console-friendly message
  final String consoleMessage;
}

class SerializationException extends AppException {
  const SerializationException({
    required super.consoleMessage,
    super.message,
    super.code,
  });
}

enum AppExceptionCode {
  defaultCode(code: 'default_code'),

  /// Used during serialization when a key is expected but not found
  missingKey(code: 'missing_key');

  const AppExceptionCode({required this.code});

  final String code;
}
