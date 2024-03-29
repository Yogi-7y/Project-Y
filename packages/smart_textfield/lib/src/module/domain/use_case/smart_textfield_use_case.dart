import 'package:flutter/material.dart';

import '../entity/parser_return_type.dart';
import 'parsers/date_parsers.dart';
import 'parsers/time_parser.dart';

class SmartTextFieldUseCase {
  ParserValue<DateTime>? processDateTime(String value) {
    final _dateParser = extractDate(value);
    final _time = extractTime(value);

    if (_dateParser != null && _time != null) {
      final _date = _dateParser.parse(value);
      final _interval = _dateParser.getStartAndEndIndex(value);

      if (_date == null) return null;

      final _dateTime = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

      return ParserValue<DateTime>(
        start: _interval!.start,
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

  TimeOfDay? extractTime(String value) {
    for (final parser in timeParsers) {
      final _time = parser.parse(value);

      if (_time != null) return _time;
    }
    return null;
  }
}
