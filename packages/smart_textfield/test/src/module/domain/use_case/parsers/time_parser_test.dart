import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_textfield/src/module/domain/use_case/parsers/time_parser.dart';

void main() {
  group(
    'TwelveHourParser',
    () {
      test(
        '8 am',
        () {
          const _input = '8 am';
          const _expectedResult = TimeOfDay(hour: 8, minute: 0);

          final _result = TwelveHourParser().parse(_input);
          final _offset = TwelveHourParser().getStartAndEndIndex(_input);

          expect(_result, _expectedResult);
          expect(_offset, const (start: 0, end: 4));
        },
      );

      test(
        '10 pm',
        () {
          const _input = '10 pm';
          const _expectedResult = TimeOfDay(hour: 22, minute: 0);

          final _result = TwelveHourParser().parse(_input);
          final _offset = TwelveHourParser().getStartAndEndIndex(_input);

          expect(_result, _expectedResult);
          expect(_offset, const (start: 0, end: 5));
        },
      );

      test(
        '10 am',
        () {
          const _input = '10 am';
          const _expectedResult = TimeOfDay(hour: 10, minute: 0);

          final _result = TwelveHourParser().parse(_input);
          final _offset = TwelveHourParser().getStartAndEndIndex(_input);

          expect(_result, _expectedResult);
          expect(_offset, const (start: 0, end: 5));
        },
      );

      /// tests with noon and midnight
      test(
        'noon',
        () {
          const _input = '12:00am';
          const _expectedResult = TimeOfDay(hour: 12, minute: 0);

          final _result = TwelveHourParser().parse(_input);
          final _offset = TwelveHourParser().getStartAndEndIndex(_input);

          expect(_result, _expectedResult);
          expect(_offset, (start: 0, end: 7));
        },
      );

      test(
        'midnight',
        () {
          const _input = '12:00pm';
          const _expectedResult = TimeOfDay(hour: 0, minute: 0);

          final _result = TwelveHourParser().parse(_input);
          final _offset = TwelveHourParser().getStartAndEndIndex(_input);

          expect(_result, _expectedResult);
          expect(_offset, (start: 0, end: 7));
        },
      );
    },
  );

  group('TwentyFourHourParser', () {
    test(
      '8:00',
      () {
        const _input = '8:00';
        const _expectedResult = TimeOfDay(hour: 8, minute: 0);

        final _result = TwelveHourParser().parse(_input);
        final _offset = TwelveHourParser().getStartAndEndIndex(_input);

        expect(_result, _expectedResult);
        expect(_offset, (start: 0, end: 4));
      },
    );

    test(
      '22:00',
      () {
        const _input = '22:00';
        const _expectedResult = TimeOfDay(hour: 22, minute: 0);

        final _result = TwelveHourParser().parse(_input);
        final _offset = TwelveHourParser().getStartAndEndIndex(_input);

        expect(_result, _expectedResult);
        expect(_offset, (start: 0, end: 5));
      },
    );

    test(
      '10:00',
      () {
        const _input = '10:00';
        const _expectedResult = TimeOfDay(hour: 10, minute: 0);

        final _result = TwelveHourParser().parse(_input);
        final _offset = TwelveHourParser().getStartAndEndIndex(_input);

        expect(_result, _expectedResult);
        expect(_offset, (start: 0, end: 5));
      },
    );

    test(
      '12:00',
      () {
        const _input = '12:00';
        const _expectedResult = TimeOfDay(hour: 12, minute: 0);

        final _result = TwelveHourParser().parse(_input);
        final _offset = TwelveHourParser().getStartAndEndIndex(_input);

        expect(_result, _expectedResult);
        expect(_offset, (start: 0, end: 5));
      },
    );

    test(
      '00:00',
      () {
        const _input = '00:00';
        const _expectedResult = TimeOfDay(hour: 0, minute: 0);

        final _result = TwelveHourParser().parse(_input);
        final _offset = TwelveHourParser().getStartAndEndIndex(_input);

        expect(_result, _expectedResult);
        expect(_offset, (start: 0, end: 5));
      },
    );
  });

  test(
    'noon',
    () {
      const _input = 'Do foo today at noon';
      const _expectedResult = TimeOfDay(hour: 12, minute: 0);

      final _result = NoonParser().parse(_input);
      final _offset = NoonParser().getStartAndEndIndex(_input);

      expect(_result, _expectedResult);
      expect(_offset, (start: 16, end: 20));
    },
  );

  test(
    'midnight',
    () {
      const _input = 'Do foo today at midnight';
      const _expectedResult = TimeOfDay(hour: 0, minute: 0);

      final _result = MidnightParser().parse(_input);
      final _offset = MidnightParser().getStartAndEndIndex(_input);

      expect(_result, _expectedResult);
      expect(_offset, (start: 16, end: 24));
    },
  );
}
