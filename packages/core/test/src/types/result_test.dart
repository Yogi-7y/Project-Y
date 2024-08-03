import 'package:core_y/core_y.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    group('Success', () {
      late Success<int, AppException> success;

      setUp(() {
        success = const Success<int, AppException>(5);
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
          onSuccess: (value) => 'Success: $value',
          onFailure: (error) => 'Failure: $error',
        );
        expect(folded, equals('Success: 5'));
      });

      test('map should transform the value', () {
        final mapped = success.map((value) => value * 2);
        expect(mapped, isA<Success<int, AppException>>());
        expect(mapped.valueOrNull, equals(10));
      });
    });

    group('Failure', () {
      late Failure<int, AppException> failure;
      late Exception error;

      setUp(() {
        error = Exception('Error');
        failure = Failure<int, AppException>(AppException.fromException(error, StackTrace.empty));
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
          onSuccess: (value) => 'Success: $value',
          onFailure: (error) => 'Failure: $error',
        );
        expect(folded, contains('Failure'));
      });

      test('map should not transform the value', () {
        final mapped = failure.map((value) => value * 2);

        expect(mapped, isA<Failure<int, AppException>>());
        expect((mapped as Failure<int, AppException>).error.exception, equals(error));
      });
    });
  });

  group('base class', () {
    test('Success should be a Result', () {
      expect(const Success<int, AppException>(5), isA<Result<int, AppException>>());
    });

    test('Failure should be a Result', () {
      expect(
          Failure<int, AppException>(
              AppException.fromException(Exception('Error'), StackTrace.empty)),
          isA<Result<int, AppException>>());
    });
  });
}
