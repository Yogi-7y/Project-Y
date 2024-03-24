import 'package:flutter/material.dart';

import 'parsers/date_parsers.dart';
import 'parsers/time_parser.dart';

class SmartTextFieldUseCase {
  DateTime? processDateTime(String value) {
    final _date = extractDate(value);
    final _time = extractTime(value);

    if (_date != null && _time != null) {
      return DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
    }

    if (_date != null) {
      return DateTime(_date.year, _date.month, _date.day);
    }

    return null;
  }

  DateTime? extractDate(String value) {
    for (final parser in dateParsers) {
      final _date = parser.parse(value);

      if (_date != null) return _date;
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
