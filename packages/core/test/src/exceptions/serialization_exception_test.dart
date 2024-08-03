import 'package:core_y/core_y.dart';
import 'package:test/test.dart';

void main() {
  group('SerializationException', () {
    test('constructor creates instance with correct properties', () {
      final exception = SerializationException(
        exception: 'Test exception',
        stackTrace: StackTrace.current,
        payload: const {'key': 'value'},
        code: SerializationExceptionCode.other,
      );

      expect(exception.exception, 'Test exception');
      expect(exception.payload, {'key': 'value'});
      expect(exception.code, SerializationExceptionCode.other);
      expect(exception.userFriendlyMessage, 'An error occurred while processing data.');
    });

    group('getValue', () {
      test('returns correct value for existing key', () {
        final json = {'key': 'value'};
        expect(SerializationException.getValue<String>(json, 'key'), 'value');
      });

      test('throws SerializationException for missing key', () {
        final json = {'key': 'value'};

        expect(
          () => SerializationException.getValue<String>(json, 'nonexistent_key'),
          throwsA(isA<SerializationException>()
              .having((e) => e.code, 'code', SerializationExceptionCode.missingKey)),
        );
      });

      test('throws SerializationException for invalid type', () {
        final json = {'key': 42};
        expect(
          () => SerializationException.getValue<String>(json, 'key'),
          throwsA(isA<SerializationException>()
              .having((e) => e.code, 'code', SerializationExceptionCode.invalidType)),
        );
      });

      test('handles null values correctly', () {
        final json = {'key': null};
        expect(SerializationException.getValue<String?>(json, 'key'), null);
      });

      test('handles complex types correctly', () {
        final json = {
          'key': [1, 2, 3]
        };
        expect(SerializationException.getValue<List<int>>(json, 'key'), [1, 2, 3]);
      });
    });
  });
}
