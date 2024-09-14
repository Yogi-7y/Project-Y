import 'package:core_y/src/extensions/time_ago.dart';
import 'package:test/test.dart';

void main() {
  group('DateTimeExtension', () {
    test('less than 1 minute ago', () {
      final now = DateTime.now();
      final dateTime = now.subtract(const Duration(seconds: 30));
      expect(dateTime.timeAgo, '< 1m ago');
    });

    test('minutes ago', () {
      final now = DateTime.now();
      final dateTime = now.subtract(const Duration(minutes: 5));
      expect(dateTime.timeAgo, '5m ago');
    });

    test('hours ago', () {
      final now = DateTime.now();
      final dateTime = now.subtract(const Duration(hours: 3));
      expect(dateTime.timeAgo, '3h ago');
    });

    test('days ago', () {
      final now = DateTime.now();
      final dateTime = now.subtract(const Duration(days: 5));
      expect(dateTime.timeAgo, '5d ago');
    });

    test('months ago', () {
      final now = DateTime.now();
      final dateTime = now.subtract(const Duration(days: 60));
      expect(dateTime.timeAgo, '2mo ago');
    });

    test('years ago', () {
      final now = DateTime.now();
      final dateTime = now.subtract(const Duration(days: 400));
      expect(dateTime.timeAgo, '1y ago');
    });
  });
}
