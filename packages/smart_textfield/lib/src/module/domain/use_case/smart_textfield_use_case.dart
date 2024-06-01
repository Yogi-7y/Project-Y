import 'package:flutter/foundation.dart';

import '../entity/parser_return_type.dart';
import '../entity/token.dart';
import '../entity/token_types.dart';
import '../entity/tokenizer.dart';
import 'parsers/date_parsers.dart';
import 'parsers/time_parser.dart';

const dateTimePrefix = 't:';

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

      _tokenizerTokens.add(
        Token<TokenableDateTime>(
          prefix: dateTimePrefix,
          rawValue: text.substring(_dateTimeToken.start, _dateTimeToken.end),
          displayValue: text.substring(_dateTimeToken.start, _dateTimeToken.end),
          value: _tokenableDateTimeValue,
          isHighlighted: true,
          offset: TokenOffset(
            start: _dateTimeToken.start,
            end: _dateTimeToken.end,
          ),
        ),
      );
    }

    for (final tokenizer in tokenizers) {
      final _tokensFromTokenizer = tokenizer.tokenize(text);
      _tokenizerTokens.addAll(_tokensFromTokenizer);
    }

    _tokenizerTokens.sort((a, b) => a.offset.start.compareTo(b.offset.start));

    if (_tokenizerTokens.isEmpty)
      return [
        Token<TokenableString>(
          prefix: '',
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
        prefix: '',
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
        prefix: '',
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

    final _date = _dateParser?.parse(value);
    final _time = _timeParser?.parse(value);

    final _dateInterval = _dateParser?.getStartAndEndIndex(value);
    final _timeInterval = _timeParser?.getStartAndEndIndex(value);

    if (_date != null && _time != null) {
      final _isWithinRange = isWithinRange(
        dateOffset: _dateInterval!,
        timeOffset: _timeInterval!,
      );

      if (_isWithinRange) {
        final _dateTime = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

        final _intervalStart =
            _dateInterval.start < _timeInterval.start ? _dateInterval.start : _timeInterval.start;

        final _intervalEnd =
            _dateInterval.end > _timeInterval.end ? _dateInterval.end : _timeInterval.end;

        final _interval = (
          start: _intervalStart,
          end: _intervalEnd,
        );

        return ParserValue<DateTime>(
          start: _interval.start,
          end: _interval.end,
          value: _dateTime,
        );
      } else {
        /// to determine if the time is later than the date in the text
        final _isTimeLater = _timeInterval.start > _dateInterval.end;

        if (_isTimeLater) {
          final _today = DateTime.now();

          final _dateTime =
              DateTime(_today.year, _today.month, _today.day, _time.hour, _time.minute);

          return ParserValue<DateTime>(
            start: _timeInterval.start,
            end: _timeInterval.end,
            value: _dateTime,
          );
        } else {
          final _dateTime = DateTime(_date.year, _date.month, _date.day);

          return ParserValue<DateTime>(
            start: _dateInterval.start,
            end: _timeInterval.end,
            value: _dateTime,
          );
        }
      }
    }

    if (_time != null) {
      final _today = DateTime.now();

      final _dateTime = DateTime(_today.year, _today.month, _today.day, _time.hour, _time.minute);

      return ParserValue<DateTime>(
        start: _timeInterval!.start,
        end: _timeInterval.end,
        value: _dateTime,
      );
    }

    if (_date != null) {
      return ParserValue<DateTime>(
        start: _dateInterval!.start,
        end: _dateInterval.end,
        value: _date,
      );
    }

    return null;
  }

  /// Returns true if the noise between the date and time is less than the threshold.
  ///
  /// Noise is defined by number of characters between the date and time.
  /// It excludes the characters that are part of the date and time.
  /// For example
  /// "Do foo on 31st December 2024 at 10pm", has a noise of 4 characters (" at ").
  ///
  /// This is to ensure that there are no longer highlighted tokens in case date and time is far apart.
  @visibleForTesting
  bool isWithinRange({
    required StartAndEndOfPattern dateOffset,
    required StartAndEndOfPattern timeOffset,
  }) {
    const _threshold = 9;

    final _firstOffset = dateOffset.start < timeOffset.start ? dateOffset : timeOffset;
    final _secondOffset = dateOffset.start < timeOffset.start ? timeOffset : dateOffset;

    final _noise = _secondOffset.start - _firstOffset.end;

    if (_noise <= _threshold) return true;

    return false;
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

  @override
  String get prefix => dateTimePrefix;
}
