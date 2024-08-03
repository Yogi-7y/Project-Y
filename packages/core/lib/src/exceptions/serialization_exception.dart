import 'package:meta/meta.dart';

import '../../core_y.dart';

@immutable
class SerializationException extends AppException {
  const SerializationException({
    required super.exception,
    required super.stackTrace,
    required this.payload,
    required this.code,
  });

  final Object? payload;
  final SerializationExceptionCode code;
}

enum SerializationExceptionCode {
  missingKey,
  invalidType,
}
