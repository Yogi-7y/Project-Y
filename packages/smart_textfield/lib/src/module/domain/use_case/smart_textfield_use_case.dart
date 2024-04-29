import '../entity/parser_return_type.dart';
import '../entity/token.dart';
import '../entity/token_types.dart';
import '../entity/tokenizer.dart';
import 'parsers/date_parsers.dart';
import 'parsers/time_parser.dart';

class SmartTextFieldUseCase {
  const SmartTextFieldUseCase({
    required this.tokenizers,
  });

  final List<Tokenizer> tokenizers;

  List<Token> tokenize({
    required String text,
  }) {
    if (text.isEmpty) return [];

    final _tokenizerTokens = <Token>[];

    for (final tokenizer in tokenizers) {
      final _tokensFromTokenizer = tokenizer.tokenize(text);
      _tokenizerTokens.addAll(_tokensFromTokenizer);
    }

    final _dateTimeToken = processDateTime(text);

    if (_dateTimeToken != null) {
      final _tokenableDateTimeValue = TokenableDateTime(
        _dateTimeToken.value.year,
        _dateTimeToken.value.month,
        _dateTimeToken.value.day,
        _dateTimeToken.value.hour,
        _dateTimeToken.value.minute,
        _dateTimeToken.value.second,
        _dateTimeToken.value.millisecond,
        _dateTimeToken.value.microsecond,
      );

      _tokenizerTokens.add(Token<TokenableDateTime>(
        rawValue: text.substring(_dateTimeToken.start, _dateTimeToken.end),
        displayValue: text.substring(_dateTimeToken.start, _dateTimeToken.end),
        value: _tokenableDateTimeValue,
        isHighlighted: true,
        offset: TokenOffset(
          start: _dateTimeToken.start,
          end: _dateTimeToken.end,
        ),
      ));
    }

    if (_tokenizerTokens.isEmpty)
      return [
        Token<TokenableString>(
          rawValue: text,
          displayValue: text,
          value: TokenableString(text),
          offset: TokenOffset(
            start: 0,
            end: text.length,
          ),
        ),
      ];

    var _offset = 0;
    final _tokens = <Token>[];

    for (final token in _tokenizerTokens) {
      final _substring = text.substring(_offset, token.offset.start);

      final _token = Token<TokenableString>(
        rawValue: _substring,
        displayValue: _substring,
        value: TokenableString(_substring),
        offset: TokenOffset(
          start: _offset,
          end: _offset + _substring.length,
        ),
      );

      _tokens
        ..add(_token)
        ..add(token);

      _offset = token.offset.end;
    }

    if (_offset < text.length) {
      final _suffixText = text.substring(_offset);
      final _token = Token<TokenableString>(
        rawValue: _suffixText,
        displayValue: _suffixText,
        value: TokenableString(_suffixText),
        offset: TokenOffset(
          start: _offset,
          end: _offset + _suffixText.length,
        ),
      );

      _tokens.add(_token);
    }

    return _tokens;
  }

  ParserValue<DateTime>? processDateTime(String value) {
    final _dateParser = extractDate(value);
    final _timeParser = extractTime(value);

    if (_dateParser != null && _timeParser != null) {
      final _date = _dateParser.parse(value);
      final _dateInterval = _dateParser.getStartAndEndIndex(value);

      final _time = _timeParser.parse(value);
      final _timeInterval = _timeParser.getStartAndEndIndex(value);

      if (_date == null || _time == null) return null;

      final _dateTime = DateTime(
          _date.year, _date.month, _date.day, _time.hour, _time.minute);

      final _interval = (
        start: _dateInterval!.start,
        end: _timeInterval!.end,
      );

      return ParserValue<DateTime>(
        start: _interval.start,
        end: _interval.end,
        value: _dateTime,
      );
    }

    if (_dateParser != null) {
      final _date = _dateParser.parse(value);
      final _interval = _dateParser.getStartAndEndIndex(value);

      if (_date == null) return null;

      return ParserValue<DateTime>(
        start: _interval!.start,
        end: _interval.end,
        value: _date,
      );
    }

    return null;
  }

  DateParser? extractDate(String value) {
    for (final parser in dateParsers) {
      if (parser.findMatch(value) != null) return parser;
    }
    return null;
  }

  TimeParser? extractTime(String value) {
    for (final parser in timeParsers) {
      if (parser.findMatch(value) != null) return parser;
    }
    return null;
  }
}

// ignore: avoid_implementing_value_types
class TokenableDateTime extends DateTime implements Tokenable {
  TokenableDateTime(
    super.year, [
    super.month = 1,
    super.day = 1,
    super.hour = 0,
    super.minute = 0,
    super.second = 0,
    super.millisecond = 0,
    super.microsecond = 0,
  ]);

  @override
  String get stringValue => '$year';
}
