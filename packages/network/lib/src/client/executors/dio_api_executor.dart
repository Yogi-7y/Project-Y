import 'package:core/core.dart';
import 'package:dio/dio.dart';

import '../../exceptions/api_exception.dart';
import '../../request/request.dart';
import '../api_executor.dart';

class DioApiExecutor implements ApiExecutor {
  late Dio dio;

  @override
  Future<void> setUp() async {
    dio = Dio();
  }

  @override
  AsyncResult<T> get<T>(Request request) async {
    try {
      final _response = await dio.get<T>(request.url);
      return Success(_response.data as T);
    } catch (e, s) {}
  }

  @override
  AsyncResult<T> post<T>(Request request) {
    throw UnimplementedError();
  }

  void _catch(Object? exception, StackTrace? stackTrace) {
    if (exception is DioException) {
      throw ApiException(
        request: request,
        error: e,
        response: e.response,
        stackTrace: s,
      );
    }

    throw ApiException(request: request, error: e, stackTrace: s);
  }
}
