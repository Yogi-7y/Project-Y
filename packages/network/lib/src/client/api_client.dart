import 'package:core_y/core_y.dart';

import '../exceptions/api_exception.dart';
import '../request/request.dart';
import 'executors/api_executor.dart';

typedef MapPayload = Map<String, Object?>;

class ApiClient {
  const ApiClient({
    required this.apiExecutor,
  });

  final ApiExecutor apiExecutor;

  Future<void> setup() async => apiExecutor.setUp();

  AsyncResult<T, ApiException> call<T>(Request request) async {
    if (request is GetRequest) return apiExecutor.get<T>(request);

    if (request is PostRequest) return apiExecutor.post<T>(request);

    return Failure<T, ApiException>(
      ApiException(
        request: request,
        exception: Exception('Unsupported request type'),
        stackTrace: StackTrace.current,
      ),
    );
  }
}
