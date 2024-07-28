import 'package:core_y/core_y.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    group('Success', () {
      late Success<int, Exception> success;

      setUp(() {
        success = const Success<int, Exception>(5);
      });

      test('isSuccess should be true', () {
        expect(success.isSuccess, isTrue);
      });

      test('isFailure should be false', () {
        expect(success.isFailure, isFalse);
      });

      test('valueOrNull should return the value', () {
        expect(success.valueOrNull, equals(5));
      });

      test('fold should call onSuccess', () {
        final folded = success.fold(
          (value) => 'Success: $value',
          (error) => 'Failure: $error',
        );
        expect(folded, equals('Success: 5'));
      });

      test('map should transform the value', () {
        final mapped = success.map((value) => value * 2);
        expect(mapped, isA<Success<int, Exception>>());
        expect(mapped.valueOrNull, equals(10));
      });
    });

    group('Failure', () {
      late Failure<int, Exception> failure;
      late Exception error;

      setUp(() {
        error = Exception('Error');
        failure = Failure<int, Exception>(error);
      });

      test('isSuccess should be false', () {
        expect(failure.isSuccess, isFalse);
      });

      test('isFailure should be true', () {
        expect(failure.isFailure, isTrue);
      });

      test('valueOrNull should return null', () {
        expect(failure.valueOrNull, isNull);
      });

      test('fold should call onFailure', () {
        final folded = failure.fold(
          (value) => 'Success: $value',
          (error) => 'Failure: $error',
        );
        expect(folded, equals('Failure: Exception: Error'));
      });

      test('map should not transform the value', () {
        final mapped = failure.map((value) => value * 2);
        expect(mapped, isA<Failure<int, Exception>>());
        expect((mapped as Failure<int, Exception>).error, equals(error));
      });
    });

    group('base class', () {
      test('Success should be a Result', () {
        expect(const Success<int, Exception>(5), isA<Result<int, Exception>>());
      });

      test('Failure should be a Result', () {
        expect(Failure<int, Exception>(Exception('Error')), isA<Result<int, Exception>>());
      });
    });
  });
}
