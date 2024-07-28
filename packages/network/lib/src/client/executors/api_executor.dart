import '../../request/request.dart';

typedef SetupRequest = ({
  Headers headers,
});

abstract class ApiExecutor {
  Future<void> setUp({SetupRequest? request});
}
