import 'package:core_y/core.dart';

import '../../request/request.dart';

typedef SetupRequest = ({
  Headers headers,
});

abstract class ApiExecutor {
  Future<void> setUp({SetupRequest? request});

  AsyncResult<T> get<T>(Request request);

  AsyncResult<T> post<T>(Request request);
}
