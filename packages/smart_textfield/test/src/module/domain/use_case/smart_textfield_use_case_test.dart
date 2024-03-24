import 'package:flutter_test/flutter_test.dart';
import 'package:smart_textfield/src/module/domain/use_case/smart_textfield_use_case.dart';

void main() {
  late final _systemUnderTest = SmartTextFieldUseCase();

  test(
    'Do foo today at noon',
    () {
      const _input = 'Do foo today at noon';
      final _today = DateTime.now();
      final _expectedResult = DateTime(_today.year, _today.month, _today.day, 12);

      final _result = _systemUnderTest.processDateTime(_input);

      expect(_result, _expectedResult);
    },
  );

  test(
    'Do foo tomorrow at midnight',
    () {
      const _input = 'Do foo tomorrow at midnight';
      final _today = DateTime.now();
      final _tomorrow = _today.add(const Duration(days: 1));
      final _expectedResult = DateTime(_tomorrow.year, _tomorrow.month, _tomorrow.day);

      final _result = _systemUnderTest.processDateTime(_input);

      expect(_result, _expectedResult);
    },
  );

  test(
    'Do foo on 20th March 2018 at 13:00',
    () {
      const _input = 'Do foo on 20th March 2018 at 13:00';
      final _expectedResult = DateTime(2018, 3, 20, 13);

      final _result = _systemUnderTest.processDateTime(_input);

      expect(_result, _expectedResult);
    },
  );

  test(
    'Do foo on 31st December 2022',
    () {
      const _input = 'Do foo on 31st December 2022';
      final _expectedResult = DateTime(2022, 12, 31);

      final _result = _systemUnderTest.processDateTime(_input);

      expect(_result, _expectedResult);
    },
  );
}
