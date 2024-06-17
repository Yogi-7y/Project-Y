import 'package:flutter_test/flutter_test.dart';
import 'package:smart_textfield/smart_textfield.dart';

void main() {
  late SmartTextFieldController _systemUnderTest;

  setUp(() {
    _systemUnderTest = SmartTextFieldController();
  });

  group(
    'tokenizers',
    () {
      test(
        'is empty initially',
        () {
          expect(_systemUnderTest.tokenizers, isEmpty);
        },
      );

      test('is prefilled if data is passed via constructor', () {
        final _tokenizers = [
          TokenizerA(prefix: '@', values: []),
          TokenizerB(prefix: '#', values: []),
        ];

        _systemUnderTest = SmartTextFieldController(tokenizers: _tokenizers);

        expect(_systemUnderTest.tokenizers, _tokenizers);
      });

      test('clearAll removes all the tokenizers', () {
        final _tokenizers = [
          TokenizerA(prefix: '@', values: []),
          TokenizerB(prefix: '#', values: []),
        ];

        _systemUnderTest = SmartTextFieldController(tokenizers: _tokenizers)..clearAll();

        expect(_systemUnderTest.tokenizers, isEmpty);
      });

      test('add adds a tokenizer to the tokenizers list', () {
        final _tokenizers = [
          TokenizerA(prefix: '@', values: []),
          TokenizerB(prefix: '#', values: []),
        ];

        _systemUnderTest = SmartTextFieldController(tokenizers: _tokenizers);

        final _tokenizer = TokenizerA(prefix: '!', values: []);

        _systemUnderTest.addTokenizer(_tokenizer);

        expect(_systemUnderTest.tokenizers, contains(_tokenizer));
      });

      test('addAll adds multiple tokenizers to the tokenizers list', () {
        final _tokenizers = [
          TokenizerA(prefix: '@', values: []),
          TokenizerB(prefix: '#', values: []),
        ];

        _systemUnderTest = SmartTextFieldController(tokenizers: _tokenizers);

        final _tokenizer1 = TokenizerA(prefix: '!', values: []);
        final _tokenizer2 = TokenizerB(prefix: '!', values: []);

        _systemUnderTest.addAllTokenizers([_tokenizer1, _tokenizer2]);

        expect(_systemUnderTest.tokenizers, containsAll([_tokenizer1, _tokenizer2]));
      });
    },
  );
}

class TokenizerA extends Tokenizer {
  TokenizerA({required super.prefix, required super.values});
}

class TokenizerB extends Tokenizer {
  TokenizerB({required super.prefix, required super.values});
}
