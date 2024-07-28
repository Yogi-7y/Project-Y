import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:network_y/src/exceptions/api_exception.dart';
import 'package:network_y/src/request/request.dart';
import 'package:test/test.dart';

void main() {
  late Request mockRequest;

  setUp(() {
    mockRequest = MockRequest();
  });

  group('ApiException', () {
    test('creates instance with correct properties', () {
      final exception = ApiException(
        request: mockRequest,
        stackTrace: StackTrace.empty,
        exception: Exception('Test'),
        statusCode: 500,
        response: const {'error': 'Server Error'},
      );

      expect(exception.request, equals(mockRequest));
      expect(exception.stackTrace, equals(StackTrace.empty));
      expect(exception.exception, isA<Exception>());
      expect(exception.statusCode, equals(500));
      expect(exception.response, equals({'error': 'Server Error'}));
    });

    test('correctly identifies network errors', () {
      final socketException = ApiException(
        request: mockRequest,
        stackTrace: StackTrace.empty,
        exception: const SocketException('No internet'),
      );

      final httpException = ApiException(
        request: mockRequest,
        stackTrace: StackTrace.empty,
        exception: const HttpException('HTTP error'),
      );

      expect(socketException.isNetworkError, isTrue);
      expect(httpException.isNetworkError, isTrue);
    });

    test('correctly identifies server errors', () {
      final serverError = ApiException(
        request: mockRequest,
        stackTrace: StackTrace.empty,
        exception: Exception('Server Error'),
        statusCode: 500,
      );

      expect(serverError.isServerError, isTrue);
      expect(serverError.isClientError, isFalse);
    });

    test('correctly identifies client errors', () {
      final clientError = ApiException(
        request: mockRequest,
        stackTrace: StackTrace.empty,
        exception: Exception('Client Error'),
        statusCode: 400,
      );

      expect(clientError.isClientError, isTrue);
      expect(clientError.isServerError, isFalse);
    });

    test('correctly identifies specific HTTP status codes', () {
      final unauthorizedError = ApiException(
        request: mockRequest,
        stackTrace: StackTrace.empty,
        exception: Exception('Unauthorized'),
        statusCode: 401,
      );

      final forbiddenError = ApiException(
        request: mockRequest,
        stackTrace: StackTrace.empty,
        exception: Exception('Forbidden'),
        statusCode: 403,
      );

      final notFoundError = ApiException(
        request: mockRequest,
        stackTrace: StackTrace.empty,
        exception: Exception('Not Found'),
        statusCode: 404,
      );

      expect(unauthorizedError.isUnauthorized, isTrue);
      expect(forbiddenError.isForbidden, isTrue);
      expect(notFoundError.isNotFound, isTrue);
    });

    test('correctly identifies timeout errors', () {
      final timeoutError = ApiException(
        request: mockRequest,
        stackTrace: StackTrace.empty,
        exception: TimeoutException('Request timed out'),
      );

      expect(timeoutError.isTimeoutError, isTrue);
    });

    test('provides correct user-friendly messages', () {
      final networkError = ApiException(
        request: mockRequest,
        stackTrace: StackTrace.empty,
        exception: const SocketException('No internet'),
      );

      final serverError = ApiException(
        request: mockRequest,
        stackTrace: StackTrace.empty,
        exception: Exception('Server Error'),
        statusCode: 500,
      );

      final unauthorizedError = ApiException(
        request: mockRequest,
        stackTrace: StackTrace.empty,
        exception: Exception('Unauthorized'),
        statusCode: 401,
      );

      expect(networkError.userFriendlyMessage, contains('Network connection error'));
      expect(serverError.userFriendlyMessage, contains('Server error'));
      expect(unauthorizedError.userFriendlyMessage, contains('Unauthorized'));
    });

    test('creates instance from DioException', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
          data: {'message': 'Not Found'},
        ),
        error: 'Not Found',
      );

      final apiException = ApiException.fromDioException(
        dioError,
        StackTrace.empty,
        mockRequest,
      );

      expect(apiException.statusCode, equals(404));
      expect(apiException.response, equals({'message': 'Not Found'}));
      expect(apiException.exception, equals('Not Found'));
    });

    test('creates instance from general Exception', () {
      final exception = Exception('Test Exception');
      final apiException = ApiException.fromException(
        exception,
        StackTrace.empty,
        mockRequest,
      );

      expect(apiException.exception, equals(exception));
      expect(apiException.statusCode, isNull);
      expect(apiException.response, isNull);
    });
  });
}

class MockRequest implements Request {
  @override
  String get baseUrl => 'https://api.example.com';

  @override
  String get endpoint => '/test';

  @override
  Map<String, String> get headers => {};

  @override
  Map<String, String> get queryParameters => {};

  @override
  Duration get timeout => const Duration(seconds: 30);

  @override
  String get url => 'https://api.example.com/test';
}
