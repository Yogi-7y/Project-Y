import 'package:flutter_test/flutter_test.dart';
import 'package:smart_textfield/src/module/domain/entity/parser_return_type.dart';
import 'package:smart_textfield/src/module/domain/entity/token.dart';
import 'package:smart_textfield/src/module/domain/entity/token_types.dart';
import 'package:smart_textfield/src/module/domain/use_case/smart_textfield_use_case.dart';

import '../entity/tokenizer_test.dart';

void main() {
  late final _systemUnderTest = SmartTextFieldUseCase(tokenizers: [
    ProjectTokenizer(
      values: const [
        Project(name: 'Foo bar'),
        Project(name: 'John Doe'),
        Project(name: 'Jane Doe'),
        Project(name: 'Baz qux'),
      ],
    )
  ]);

  test(
    'Do foo today at noon',
    () {
      const _input = 'Do foo today at noon';
      final _today = DateTime.now();
      final _expectedResult = ParserValue(
        value: DateTime(_today.year, _today.month, _today.day, 12),
        start: 7,
        end: 20,
      );

      final _result = _systemUnderTest.processDateTime(_input);

      expect(_result, _expectedResult);
    },
  );

  test(
    'Do foo tomorrow at midnight',
    () {
      const _input = 'Do foo tomorrow at midnight';
      final _today = DateTime.now();
      final _tomorrow = _today.add(const Duration(days: 1));
      final _expectedResult = ParserValue(
        value: DateTime(_tomorrow.year, _tomorrow.month, _tomorrow.day),
        start: 7,
        end: 27,
      );

      final _result = _systemUnderTest.processDateTime(_input);

      expect(_result, _expectedResult);
    },
  );

  test(
    'Do foo on 20th March 2018 at 13:00',
    () {
      const _input = 'Do foo on 20th March 2018 at 13:00';
      final _expectedResult = ParserValue(
        value: DateTime(2018, 3, 20, 13),
        start: 10,
        end: 34,
      );

      final _result = _systemUnderTest.processDateTime(_input);

      expect(_result, _expectedResult);
    },
  );

  test(
    'Do foo on 31st December 2022',
    () {
      const _input = 'Do foo on 31st December 2022';
      final _expectedResult = ParserValue(
        value: DateTime(2022, 12, 31),
        start: 10,
        end: 28,
      );

      final _result = _systemUnderTest.processDateTime(_input);

      expect(_result, _expectedResult);
    },
  );

  group(
    'tokenize',
    () {
      test(
        'returns empty when text is empty',
        () {
          const _text = '';

          final _result = _systemUnderTest.tokenize(text: _text);

          expect(_result, isEmpty);
        },
      );

      test(
        'returns a single token when no pattern is matched',
        () async {
          const _text = 'foo bar baz qux';

          final _result = _systemUnderTest.tokenize(text: _text);
          const _expectedResult = [
            Token<TokenableString>(
              rawValue: _text,
              displayValue: _text,
              value: TokenableString(_text),
              offset: TokenOffset(
                start: 0,
                end: 15,
              ),
            ),
          ];

          expect(_result, _expectedResult);
        },
      );

      test(
        'returns the value if the pattern is matched',
        () async {
          final _result =
              _systemUnderTest.tokenize(text: 'foo bar baz qux @John Doe');

          const _expectedResult = [
            Token<TokenableString>(
              rawValue: 'foo bar baz qux ',
              displayValue: 'foo bar baz qux ',
              value: TokenableString('foo bar baz qux '),
              offset: TokenOffset(
                start: 0,
                end: 16,
              ),
            ),
            Token<Project>(
              rawValue: '@John Doe',
              displayValue: 'John Doe',
              isHighlighted: true,
              value: Project(name: 'John Doe'),
              offset: TokenOffset(
                start: 16,
                end: 25,
              ),
            ),
          ];

          expect(_result, _expectedResult);
        },
      );

      test(
        'returns multiple values including date and time',
        () async {
          const _input = 'Meet @John Doe on 20th March 2018 at 1pm for Foo bar';

          final _expectedResult = [
            const Token<TokenableString>(
              rawValue: 'Meet ',
              displayValue: 'Meet ',
              value: TokenableString('Meet '),
              offset: TokenOffset(
                start: 0,
                end: 5,
              ),
            ),
            const Token<Project>(
              rawValue: '@John Doe',
              displayValue: 'John Doe',
              value: Project(name: 'John Doe'),
              isHighlighted: true,
              offset: TokenOffset(
                start: 5,
                end: 14,
              ),
            ),
            const Token<TokenableString>(
              rawValue: ' on ',
              displayValue: ' on ',
              value: TokenableString(' on '),
              offset: TokenOffset(
                start: 14,
                end: 18,
              ),
            ),
            Token<TokenableDateTime>(
              rawValue: '20th March 2018 at 1pm',
              displayValue: '20th March 2018 at 1pm',
              isHighlighted: true,
              offset: const TokenOffset(
                start: 18,
                end: 40,
              ),
              value: TokenableDateTime(2018, 3, 20, 13),
            ),
            const Token<TokenableString>(
              rawValue: ' for Foo bar',
              displayValue: ' for Foo bar',
              value: TokenableString(' for Foo bar'),
              offset: TokenOffset(
                start: 40,
                end: 52,
              ),
            ),
          ];

          final _result = _systemUnderTest.tokenize(text: _input);

          expect(_result, _expectedResult);
        },
      );
    },
  );
}
