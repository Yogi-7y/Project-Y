import 'package:core/core.dart';

import '../request/request.dart';
import 'api_executor.dart';

typedef MapPayload = Map<String, Object?>;

class ApiClient {
  const ApiClient({
    required this.apiExecutor,
  });

  final ApiExecutor apiExecutor;

  AsyncResult<T> call<T>(Request request) {
    if (request is GetRequest) {
      return apiExecutor.get(request);
    } else if (request is PostRequest) {
      return apiExecutor.post(request);
    } else {
      throw UnsupportedError('Request type(${request.runtimeType}) not supported!');
    }
  }
}
