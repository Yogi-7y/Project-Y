import 'package:core_y/core_y.dart';

import '../../exceptions/api_exception.dart';
import '../../request/request.dart';

typedef SetupRequest = ({
  Headers headers,
});

abstract class ApiExecutor {
  AsyncResult<void, AppException> setUp({SetupRequest? request});

  AsyncResult<T, ApiException> get<T>(Request request);

  AsyncResult<T, ApiException> post<T>(PostRequest request);
}
