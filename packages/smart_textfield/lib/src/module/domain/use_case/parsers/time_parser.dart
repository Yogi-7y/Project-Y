import 'package:flutter/material.dart';

typedef Time = ({int hour, int minute});

final timeParsers = <TimeParser>[
  TwelveHourParser(),
  TwentyFourHourParser(),
  NoonParser(),
  MidnightParser(),
];

abstract class TimeParser {
  Time? extractTime(String value);

  TimeOfDay? parse(String value) {
    final _time = extractTime(value);

    if (_time != null) return TimeOfDay(hour: _time.hour, minute: _time.minute);

    return null;
  }
}

class TwelveHourParser extends TimeParser {
  static final regex = RegExp(r'\b((?:[01]?\d|2[0-3]):[0-5]\d\s*(?:am|pm)?|1?[0-9]\s*(?:am|pm))\b');

  @override
  Time? extractTime(String value) {
    final match = regex.firstMatch(value);

    if (match != null) {
      final time = match.group(0);

      if (time == null) return null;

      final isPm = time.contains('pm');

      final _timeWithoutAmPm = time.replaceAll(RegExp('am|pm'), '').trim();

      final _timeParts =
          _timeWithoutAmPm.contains(':') ? _timeWithoutAmPm.split(':') : [_timeWithoutAmPm, '00'];

      final hour = int.parse(_timeParts[0]);
      final minute = int.parse(_timeParts[1]);

      final _hour = hour == 12 ? (isPm ? 0 : 12) : hour + (isPm ? 12 : 0);

      return (hour: _hour, minute: minute);
    }

    return null;
  }
}

class TwentyFourHourParser extends TimeParser {
  static final regex = RegExp(r'\b((?:[01]?\d|2[0-3]):[0-5]\d)\b');

  @override
  Time? extractTime(String value) {
    final match = regex.firstMatch(value);

    if (match != null) {
      final time = match.group(0);

      if (time == null) return null;

      final _timeParts = time.split(':');

      final hour = int.parse(_timeParts[0]);
      final minute = int.parse(_timeParts[1]);

      return (hour: hour, minute: minute);
    }

    return null;
  }
}

class NoonParser extends TimeParser {
  static final regex = RegExp(r'\bnoon\b');

  @override
  Time? extractTime(String value) {
    if (regex.hasMatch(value)) return (hour: 12, minute: 0);

    return null;
  }
}

class MidnightParser extends TimeParser {
  static final regex = RegExp(r'\bmidnight\b');

  @override
  Time? extractTime(String value) {
    if (regex.hasMatch(value)) return (hour: 0, minute: 0);

    return null;
  }
}
