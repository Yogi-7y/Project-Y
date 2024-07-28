import 'package:core_y/core_y.dart';
import 'package:dio/dio.dart';

import '../../exceptions/api_exception.dart';
import '../../request/request.dart';

import 'api_executor.dart';

class DioApiExecutor implements ApiExecutor {
  late final _dio = Dio();

  @override
  AsyncResult<T, ApiException> get<T>(Request request) async {
    try {
      final _response = await _dio.get<T>(
        request.url,
        queryParameters: request.queryParameters,
        options: Options(
          headers: request.headers,
          sendTimeout: request.timeout,
          receiveTimeout: request.timeout,
        ),
      );

      return Success(_response.data as T);
    } on DioException catch (e, s) {
      return Failure(ApiException.fromDioException(e, s, request));
    } catch (e, s) {
      return Failure(ApiException.fromException(e, s, request));
    }
  }

  @override
  AsyncResult<T, ApiException> post<T>(Request request) {
    throw UnimplementedError();
  }

  @override
  AsyncResult<void, Exception> setUp({SetupRequest? request}) async {
    try {
      if (request != null) {
        _dio.options.headers.addAll(request.headers);
      }

      return const Success(null);
    } catch (e) {
      return Failure(e as Exception);
    }
  }
}
