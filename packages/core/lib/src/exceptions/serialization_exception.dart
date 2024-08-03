import 'package:meta/meta.dart';

import '../../core_y.dart';

/// An exception that is thrown when an error occurs during serialization or deserialization.
///
/// This exception provides detailed information about the error, including the payload
/// that caused the error and a specific error code.
@immutable
class SerializationException extends AppException {
  const SerializationException({
    required super.exception,
    required super.stackTrace,
    required this.payload,
    required this.code,
  }) : super(
          userFriendlyMessage: 'An error occurred while processing data.',
        );

  /// The data that was being processed when the error occurred.
  final Object? payload;

  /// The specific error code that describes the error.
  final SerializationExceptionCode code;

  /// Safely retrieves a value of type [T] from a JSON map.
  ///
  /// [json] is the map to retrieve the value from.
  /// [key] is the key of the value to retrieve.
  ///
  /// Throws a [SerializationException] if the key is missing or the value is of the wrong type.
  ///
  /// Returns the value if it exists and is of the correct type.
  static T getValue<T>(
    Map<String, Object?> json,
    String key,
  ) {
    if (!json.containsKey(key)) {
      throw SerializationException(
        exception: 'Key $key not found in payload',
        stackTrace: StackTrace.current,
        payload: json,
        code: SerializationExceptionCode.missingKey,
      );
    }

    final value = json[key];

    if (value is T) return value;

    throw SerializationException(
      exception: 'Invalid type ${value.runtimeType} for key $key',
      stackTrace: StackTrace.current,
      payload: json,
      code: SerializationExceptionCode.invalidType,
    );
  }

  @override
  String toString() {
    return 'SerializationException: $code \n'
        'Payload: $payload\n'
        'Original error: $exception\n'
        'Stack trace: $stackTrace';
  }
}

/// Enum representing different types of serialization errors.
enum SerializationExceptionCode {
  /// Indicates that a required key is missing from the data.
  missingKey,

  /// Indicates that a value is of an incorrect type.
  invalidType,

  /// Indicates an error that does not fit into any other category.
  other,
}
