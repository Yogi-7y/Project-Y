import '../entity/parser_return_type.dart';
import 'parsers/date_parsers.dart';
import 'parsers/time_parser.dart';

class SmartTextFieldUseCase {
  ParserValue<DateTime>? processDateTime(String value) {
    final _dateParser = extractDate(value);
    final _timeParser = extractTime(value);

    if (_dateParser != null && _timeParser != null) {
      final _date = _dateParser.parse(value);
      final _dateInterval = _dateParser.getStartAndEndIndex(value);

      final _time = _timeParser.parse(value);
      final _timeInterval = _timeParser.getStartAndEndIndex(value);

      if (_date == null || _time == null) return null;

      final _dateTime = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

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
      // final _time = parser.parse(value);

      // if (_time != null) return _time;
    }
    return null;
  }
}
