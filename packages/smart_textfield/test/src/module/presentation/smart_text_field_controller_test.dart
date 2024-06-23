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
        final _tokenizers = <Tokenizer>[
          TokenizerA(values: []),
          TokenizerB(prefix: '#', values: []),
        ];

        _systemUnderTest = SmartTextFieldController(tokenizers: _tokenizers);

        expect(_systemUnderTest.tokenizers, _tokenizers);
      });

      test('clearAll removes all the tokenizers', () {
        final _tokenizers = <Tokenizer>[
          TokenizerA(prefix: '@', values: []),
          TokenizerB(prefix: '#', values: []),
        ];

        _systemUnderTest = SmartTextFieldController(tokenizers: _tokenizers)..clearAll();

        expect(_systemUnderTest.tokenizers, isEmpty);
      });

      test('add adds a tokenizer to the tokenizers list', () {
        final _tokenizers = <Tokenizer>[
          TokenizerA(prefix: '@', values: []),
          TokenizerB(prefix: '#', values: []),
        ];

        _systemUnderTest = SmartTextFieldController(tokenizers: _tokenizers);

        final _tokenizer = TokenizerA(prefix: '!', values: []);

        _systemUnderTest.addTokenizer(_tokenizer);

        expect(_systemUnderTest.tokenizers, contains(_tokenizer));
      });

      test('addAll adds multiple tokenizers to the tokenizers list', () {
        final _tokenizers = <Tokenizer>[
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

  group(
    'plainText',
    () {
      test('is empty initially', () {
        expect(_systemUnderTest.plainText, isEmpty);
      });

      test('removes the time token and returns the rest', () {
        const _text = 'Pick up the kids tomorrow';
        const _expected = 'Pick up the kids';

        _systemUnderTest.text = _text;

        expect(_systemUnderTest.plainText, _expected);
      });

      test('removes the tokens from the Tokenizers passed in by the client', () {
        _systemUnderTest = SmartTextFieldController(
          tokenizers: [
            TokenizerA(values: [
              const Project(name: 'Foo bar'),
              const Project(name: 'Baz qux'),
            ]),
          ],
        );

        const _text = 'Pick up the kids @Foo bar and take them to zoo';

        const _expected = 'Pick up the kids and take them to zoo';

        _systemUnderTest.text = _text;

        expect(_systemUnderTest.plainText, _expected);
      });
    },
  );
}

class TokenizerA extends Tokenizer<Project> {
  TokenizerA({super.prefix = '@', required super.values});
}

class TokenizerB extends Tokenizer {
  TokenizerB({required super.prefix, required super.values});
}

class Project implements Tokenable {
  const Project({
    required this.name,
  });

  final String name;

  @override
  String get prefix => '@';

  @override
  String get stringValue => name;
}
