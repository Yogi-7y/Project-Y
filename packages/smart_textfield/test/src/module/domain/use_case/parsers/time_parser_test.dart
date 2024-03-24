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

          expect(_result, _expectedResult);
        },
      );

      test(
        '10 pm',
        () {
          const _input = '10 pm';
          const _expectedResult = TimeOfDay(hour: 22, minute: 0);

          final _result = TwelveHourParser().parse(_input);

          expect(_result, _expectedResult);
        },
      );

      test(
        '10 am',
        () {
          const _input = '10 am';
          const _expectedResult = TimeOfDay(hour: 10, minute: 0);

          final _result = TwelveHourParser().parse(_input);

          expect(_result, _expectedResult);
        },
      );

      /// tests with noon and midnight
      test(
        'noon',
        () {
          const _input = '12:00am';
          const _expectedResult = TimeOfDay(hour: 12, minute: 0);

          final _result = TwelveHourParser().parse(_input);

          expect(_result, _expectedResult);
        },
      );

      test(
        'midnight',
        () {
          const _input = '12:00pm';
          const _expectedResult = TimeOfDay(hour: 0, minute: 0);

          final _result = TwelveHourParser().parse(_input);

          expect(_result, _expectedResult);
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

        expect(_result, _expectedResult);
      },
    );

    test(
      '22:00',
      () {
        const _input = '22:00';
        const _expectedResult = TimeOfDay(hour: 22, minute: 0);

        final _result = TwelveHourParser().parse(_input);

        expect(_result, _expectedResult);
      },
    );

    test(
      '10:00',
      () {
        const _input = '10:00';
        const _expectedResult = TimeOfDay(hour: 10, minute: 0);

        final _result = TwelveHourParser().parse(_input);

        expect(_result, _expectedResult);
      },
    );

    test(
      '12:00',
      () {
        const _input = '12:00';
        const _expectedResult = TimeOfDay(hour: 12, minute: 0);

        final _result = TwelveHourParser().parse(_input);

        expect(_result, _expectedResult);
      },
    );

    test(
      '00:00',
      () {
        const _input = '00:00';
        const _expectedResult = TimeOfDay(hour: 0, minute: 0);

        final _result = TwelveHourParser().parse(_input);

        expect(_result, _expectedResult);
      },
    );
  });

  test(
    'noon',
    () {
      const _input = 'Do foo today at noon';
      const _expectedResult = TimeOfDay(hour: 12, minute: 0);

      final _result = NoonParser().parse(_input);

      expect(_result, _expectedResult);
    },
  );

  test(
    'midnight',
    () {
      const _input = 'Do foo today at midnight';
      const _expectedResult = TimeOfDay(hour: 0, minute: 0);

      final _result = MidnightParser().parse(_input);

      expect(_result, _expectedResult);
    },
  );
}
