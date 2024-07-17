import 'dart:developer' as developer;
import 'package:core_y/core.dart';
import 'package:dio/dio.dart';

import '../../exceptions/api_exception.dart';
import '../../request/request.dart';
import 'api_executor.dart';

class DioApiExecutor implements ApiExecutor {
  late Dio dio;

  @override
  Future<void> setUp() async {
    dio = Dio();
  }

  @override
  AsyncResult<T> get<T>(Request request) async {
    try {
      final _response = await dio.get<T>(
        request.url,
        options: Options(
          headers: request.headers,
        ),
      );
      return Success(_response.data as T);
    } catch (exception, stackTrace) {
      return _catch(request, exception, stackTrace);
    }
  }

  @override
  AsyncResult<T> post<T>(Request request) async {
    try {
      if (request is! PostRequest) throw ArgumentError('post method only accepts PostRequest');

      final _response = await dio.post<T>(request.url,
          data: request.body,
          options: Options(
            headers: request.headers,
          ));
      return Success(_response.data as T);
    } catch (exception, stackTrace) {
      return _catch(request, exception, stackTrace);
    }
  }

  Failure<T> _catch<T>(
    Request request,
    Object? exception,
    StackTrace? stackTrace,
  ) {
    developer.log('Error: $exception', error: exception, stackTrace: stackTrace);
    if (exception is DioException) {
      return Failure<T>(
        error: ApiException(
          request: request,
          error: exception,
          response: exception.response,
          stackTrace: stackTrace,
        ),
        stackTrace: stackTrace,
      );
    }

    return Failure(
      error: exception,
      stackTrace: stackTrace,
    );
  }
}
