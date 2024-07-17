import 'package:core_y/core.dart';

import '../../request/request.dart';

abstract class ApiExecutor {
  Future<void> setUp();

  AsyncResult<T> get<T>(Request request);

  AsyncResult<T> post<T>(Request request);
}
