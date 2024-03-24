import 'package:flutter_test/flutter_test.dart';
import 'package:smart_textfield/src/module/domain/use_case/parsers/date_parsers.dart';

void main() {
  group(
    'today',
    () {
      test(
        'Do foo today',
        () {
          const _input = 'Do foo today';
          final _today = DateTime.now();
          final _expectedResult = DateTime(_today.year, _today.month, _today.day);

          final _result = TodayDateParser().parse(_input);

          expect(_result, _expectedResult);
        },
      );
    },
  );

  /// tomorrow tests
  group(
    'tomorrow',
    () {
      test(
        'Do foo tomorrow',
        () {
          const _input = 'Do foo tomorrow';
          final _today = DateTime.now();
          final _tomorrow = _today.add(const Duration(days: 1));
          final _expectedResult = DateTime(_tomorrow.year, _tomorrow.month, _tomorrow.day);

          final _result = TomorrowDateParser().parse(_input);

          expect(_result, _expectedResult);
        },
      );
    },
  );

  /// overmorrow tests
  group(
    'overmorrow',
    () {
      test(
        'Do foo overmorrow',
        () {
          const _input = 'Do foo overmorrow';
          final _today = DateTime.now();
          final _overmorrow = _today.add(const Duration(days: 2));
          final _expectedResult = DateTime(_overmorrow.year, _overmorrow.month, _overmorrow.day);

          final _result = OvermorrowDateParser().parse(_input);

          expect(_result, _expectedResult);
        },
      );
    },
  );

  group(
    'LittleEndianDateParser',
    () {
      _customTest(
        inputDate: '20/08/2024',
        expectedResult: DateTime(2024, 8, 20),
        parser: LittleEndianDateParser().parse,
      );

      _customTest(
        inputDate: '01/01/2019',
        expectedResult: DateTime(2019),
        parser: LittleEndianDateParser().parse,
      );
    },
  );

  group(
    'DateWithSuffixAndFullMonthParser',
    () {
      test(
        'Do foo on 20th August 2024',
        () {
          const _input = 'Do foo on 20th August 2024';
          final _expectedResult = DateTime(2024, 8, 20);

          final _result = DateWithSuffixAndFullMonthParser().parse(_input);

          expect(_result, _expectedResult);
        },
      );
    },
  );

  group(
    'DateWithSuffixAndShortMonthNameParser',
    () {
      test(
        'Do foo on 20th Aug 2024',
        () {
          const _input = 'Do foo on 20th Aug 2024';
          final _expectedResult = DateTime(2024, 8, 20);

          final _result = DateWithSuffixAndShortMonthNameParser().parse(_input);

          expect(_result, _expectedResult);
        },
      );

      test(
        'Do foo on 20th Jan 2024',
        () {
          const _input = 'Do foo on 20th Jan 2024';
          final _expectedResult = DateTime(2024, 1, 20);

          final _result = DateWithSuffixAndShortMonthNameParser().parse(_input);

          expect(_result, _expectedResult);
        },
      );

      test(
        'Do foo on 20th Feb 2024',
        () {
          const _input = 'Do foo on 20th Feb 2024';
          final _expectedResult = DateTime(2024, 2, 20);

          final _result = DateWithSuffixAndShortMonthNameParser().parse(_input);

          expect(_result, _expectedResult);
        },
      );

      test(
        'Do foo on 20th Mar 2024',
        () {
          const _input = 'Do foo on 20th Mar 2024';
          final _expectedResult = DateTime(2024, 3, 20);

          final _result = DateWithSuffixAndShortMonthNameParser().parse(_input);

          expect(_result, _expectedResult);
        },
      );
    },
  );

  group(
    'getMonthNumberFromName',
    () {
      test('Should return 1 for January', () {
        const _input = 'January';
        const _expectedResult = 1;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 2 for February', () {
        const _input = 'February';
        const _expectedResult = 2;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 3 for March', () {
        const _input = 'March';
        const _expectedResult = 3;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 4 for April', () {
        const _input = 'April';
        const _expectedResult = 4;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 5 for May', () {
        const _input = 'May';
        const _expectedResult = 5;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 6 for June', () {
        const _input = 'June';
        const _expectedResult = 6;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 7 for July', () {
        const _input = 'July';
        const _expectedResult = 7;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 8 for August', () {
        const _input = 'August';
        const _expectedResult = 8;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 9 for September', () {
        const _input = 'September';
        const _expectedResult = 9;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 10 for October', () {
        const _input = 'October';
        const _expectedResult = 10;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 11 for November', () {
        const _input = 'November';
        const _expectedResult = 11;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 12 for December', () {
        const _input = 'December';
        const _expectedResult = 12;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 1 for Jan', () {
        const _input = 'Jan';
        const _expectedResult = 1;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 2 for Feb', () {
        const _input = 'Feb';
        const _expectedResult = 2;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 3 for Mar', () {
        const _input = 'Mar';
        const _expectedResult = 3;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 4 for Apr', () {
        const _input = 'Apr';
        const _expectedResult = 4;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 6 for Jun', () {
        const _input = 'Jun';
        const _expectedResult = 6;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 7 for Jul', () {
        const _input = 'Jul';
        const _expectedResult = 7;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 8 for Aug', () {
        const _input = 'Aug';
        const _expectedResult = 8;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 9 for Sep', () {
        const _input = 'Sep';
        const _expectedResult = 9;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 10 for Oct', () {
        const _input = 'Oct';
        const _expectedResult = 10;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 11 for Nov', () {
        const _input = 'Nov';
        const _expectedResult = 11;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });

      test('Should return 12 for Dec', () {
        const _input = 'Dec';
        const _expectedResult = 12;

        final _result = getMonthNumberFromName(_input);

        expect(_result, _expectedResult);
      });
    },
  );
}

void _customTest({
  required String inputDate,
  required DateTime expectedResult,
  required DateTime? Function(String) parser,
}) {
  return test(
    'Do foo on $inputDate',
    () {
      final _input = 'Do foo on $inputDate';

      final _result = LittleEndianDateParser().parse(_input);

      expect(_result, expectedResult);

      return null;
    },
  );
}
