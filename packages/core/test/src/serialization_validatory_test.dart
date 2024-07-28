import 'package:core_y/core_y.dart';
import 'package:test/test.dart';

const _source = <String, Object?>{
  'foo': 'bar',
  'baz': 42,
  'list': [1, 2, 3],
  'map': {'a': 1, 'b': 2, 'c': 3},
  'bool': true,
  'null': null,
};

void main() {
  late ValidatorCallback _serializer;

  setUp(() {
    _serializer = SerializationValidator()(_source);
  });

  test('serialize string', () {
    expect(_serializer<String>('foo'), 'bar');
  });

  test('serialize int', () {
    expect(_serializer<int>('baz'), 42);
  });

  test('serialize list', () {
    expect(_serializer<List<int>>('list'), [1, 2, 3]);
  });

  test('serialize map', () {
    expect(_serializer<Map<String, int>>('map'), {'a': 1, 'b': 2, 'c': 3});
  });

  test('serialize bool', () {
    expect(_serializer<bool>('bool'), true);
  });

  test('serialize null', () {
    expect(_serializer<Object?>('null'), null);
  });

  test('serialize invalid type', () {
    expect(
      () => _serializer<int>('foo'),
      throwsA(isA<SerializationException>()),
    );
  });

  test('serialize invalid type with message', () {
    expect(
      () => _serializer<int>('foo'),
      throwsA(
        isA<SerializationException>().having(
          (e) => e.consoleMessage,
          'message',
          contains('Expected type: int'),
        ),
      ),
    );
  });

  test('serialize invalid type with key', () {
    expect(
      () => _serializer<int>('foo'),
      throwsA(
        isA<SerializationException>().having(
          (e) => e.consoleMessage,
          'message',
          contains('Key: foo'),
        ),
      ),
    );
  });

  test('serialize invalid type with source', () {
    expect(
      () => _serializer<int>('foo'),
      throwsA(
        isA<SerializationException>().having(
          (e) => e.consoleMessage,
          'message',
          contains('Source: $_source'),
        ),
      ),
    );
  });

  test('serialize invalid type with stack trace', () {
    expect(
      () => _serializer<int>('foo'),
      throwsA(
        isA<SerializationException>().having(
          (e) => e.consoleMessage,
          'message',
          contains('Stack Trace:'),
        ),
      ),
    );
  });
}
