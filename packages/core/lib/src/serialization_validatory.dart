import 'exceptions/app_exception.dart';

typedef ValidatorCallback = T Function<T>(String key);

class SerializationValidator {
  ValidatorCallback call(Map<String, Object?> source) => <T extends Object?>(key) {
        final _value = source[key];
        final _buffer = StringBuffer();

        if (_value is! T) {
          _buffer
            ..writeln()
            ..writeln('Expected type: $T')
            ..writeln('Got: ${_value.runtimeType}')
            ..writeln('Key: $key')
            ..writeln('Source: $source')
            ..writeln()
            ..writeln('Stack Trace: ${StackTrace.current}');
          throw SerializationException(consoleMessage: _buffer.toString());
        }

        return _value;
      };
}
