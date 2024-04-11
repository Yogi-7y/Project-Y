import 'package:flutter_test/flutter_test.dart';
import 'package:smart_textfield/src/core/date_time_extension.dart';

void main() {
  group('DateTimeExtension', () {
    test('withoutTime should remove time from DateTime', () {
      final dateTimeWithTime = DateTime(2022, 12, 31, 13, 45, 30);
      final dateTimeWithoutTime = dateTimeWithTime.withoutTime;

      expect(dateTimeWithoutTime.year, equals(2022));
      expect(dateTimeWithoutTime.month, equals(12));
      expect(dateTimeWithoutTime.day, equals(31));
      expect(dateTimeWithoutTime.hour, equals(0));
      expect(dateTimeWithoutTime.minute, equals(0));
      expect(dateTimeWithoutTime.second, equals(0));
      expect(dateTimeWithoutTime.millisecond, equals(0));
      expect(dateTimeWithoutTime.microsecond, equals(0));
    });
  });
}
