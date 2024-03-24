import 'package:flutter/material.dart';

typedef DateType = ({
  int day,
  int month,
  int year,
});

final dateParsers = <DateParser>[
  TodayDateParser(),
  TomorrowDateParser(),
  OvermorrowDateParser(),
  LittleEndianDateParser(),
  DateWithSuffixAndFullMonthParser(),
  DateWithSuffixAndShortMonthNameParser(),
];

@immutable
abstract class DateParser {
  @protected
  DateType? extractDate(String value);

  DateTime? parse(String value) {
    final _date = extractDate(value);

    if (_date != null) return DateTime(_date.year, _date.month, _date.day);

    return null;
  }
}

/// Handles the parsing of dates which include the word 'today'
class TodayDateParser extends DateParser {
  @override
  DateType? extractDate(String value) {
    if (value.contains('today')) {
      final _now = DateTime.now();

      return (day: _now.day, month: _now.month, year: _now.year);
    }

    return null;
  }
}

/// Handles the parsing of dates which include the word 'tomorrow'
class TomorrowDateParser extends DateParser {
  @override
  DateType? extractDate(String value) {
    if (value.contains('tomorrow')) {
      final _now = DateTime.now();
      final _tomorrow = _now.add(const Duration(days: 1));

      return (day: _tomorrow.day, month: _tomorrow.month, year: _tomorrow.year);
    }

    return null;
  }
}

/// Handles the parsing of dates which include the word 'overmorrow'
class OvermorrowDateParser extends DateParser {
  @override
  DateType? extractDate(String value) {
    if (value.contains('overmorrow')) {
      final _now = DateTime.now();
      final _overmorrow = _now.add(const Duration(days: 2));

      return (day: _overmorrow.day, month: _overmorrow.month, year: _overmorrow.year);
    }

    return null;
  }
}

/// Handles the parsing of dates in the format dd/MM/yyyy
class LittleEndianDateParser extends DateParser {
  static const _regEx = r'\b(\d{2}/\d{2}/\d{4})\b';

  @override
  DateType? extractDate(String value) {
    final _valueInLowercase = value.toLowerCase();

    final _match = RegExp(_regEx).firstMatch(_valueInLowercase);

    if (_match != null) {
      final _dateParts = _match.group(0)!.split('/');

      final _day = int.parse(_dateParts[0]);
      final _month = int.parse(_dateParts[1]);
      final _year = int.parse(_dateParts[2]);

      return (day: _day, month: _month, year: _year);
    }

    return null;
  }
}

/// Handles the parsing of dates in 20th August 2024 format
class DateWithSuffixAndFullMonthParser extends DateParser {
  static const _dateWithSuffixAndFullMonthRegEx =
      r'\b(\d{1,2}(?:st|nd|rd|th)?\s(?:January|February|March|April|May|June|July|August|September|October|November|December)\s\d{4})\b';

  @override
  DateType? extractDate(String value) {
    final _match = RegExp(_dateWithSuffixAndFullMonthRegEx).firstMatch(value);

    if (_match != null) {
      final _dateParts = _match.group(0)!.split(' ');

      final _day = int.parse(_dateParts[0].replaceAll(RegExp('[a-z]'), ''));
      final _month = getMonthNumberFromName(_dateParts[1]);
      final _year = int.parse(_dateParts[2]);

      return (day: _day, month: _month, year: _year);
    }

    return null;
  }
}

class DateWithSuffixAndShortMonthNameParser extends DateParser {
  static const _dateWithSuffixAndShortMonthRegEx =
      r'\b(\d{1,2}(?:st|nd|rd|th)?\s(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{4})\b';

  @override
  DateType? extractDate(String value) {
    final _match = RegExp(_dateWithSuffixAndShortMonthRegEx).firstMatch(value);

    if (_match != null) {
      final _dateParts = _match.group(0)!.split(' ');

      final _day = int.parse(_dateParts[0].replaceAll(RegExp('[a-z]'), ''));
      final _month = getMonthNumberFromName(_dateParts[1]);
      final _year = int.parse(_dateParts[2]);

      return (day: _day, month: _month, year: _year);
    }

    return null;
  }
}

@visibleForTesting
int getMonthNumberFromName(String monthName) {
  switch (monthName) {
    case 'January':
      return 1;
    case 'February':
      return 2;
    case 'March':
      return 3;
    case 'April':
      return 4;
    case 'May':
      return 5;
    case 'June':
      return 6;
    case 'July':
      return 7;
    case 'August':
      return 8;
    case 'September':
      return 9;
    case 'October':
      return 10;
    case 'November':
      return 11;
    case 'December':
      return 12;
    case 'Jan':
      return 1;
    case 'Feb':
      return 2;
    case 'Mar':
      return 3;
    case 'Apr':
      return 4;
    case 'Jun':
      return 6;
    case 'Jul':
      return 7;
    case 'Aug':
      return 8;
    case 'Sep':
      return 9;
    case 'Oct':
      return 10;
    case 'Nov':
      return 11;
    case 'Dec':
      return 12;
    default:
      return 0;
  }
}
