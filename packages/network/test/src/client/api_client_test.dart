import 'package:core_y/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_y/network.dart';
import 'package:network_y/src/client/executors/api_executor.dart';
import 'package:network_y/src/request/request.dart';

class MockApiExecutor extends Mock implements ApiExecutor {}

void main() {
  late ApiClient client;
  setUp(
    () {
      client = ApiClient(apiExecutor: MockApiExecutor());
    },
  );

  test('get request', () async {
    const request = GetRequest(host: 'api.example.com', endpoint: '/users');

    when(() => client.apiExecutor.get<MapPayload>(request)).thenAnswer(
      (_) async => Success(null),
    );

    await client.call<MapPayload>(request);

    verify(() => client.apiExecutor.get<MapPayload>(request));
    verifyNever(() => client.apiExecutor.post<MapPayload>(request));
  });

  test('post request', () async {
    const request = PostRequest(host: 'api.example.com', endpoint: '/users');

    when(() => client.apiExecutor.post<MapPayload>(request)).thenAnswer(
      (_) async => Success(null),
    );

    await client.call<MapPayload>(request);

    verify(() => client.apiExecutor.post<MapPayload>(request));
    verifyNever(() => client.apiExecutor.get<MapPayload>(request));
  });

  test(
    'unsupported request throws UnimplementedError',
    () {
      const request = _UnsupportedRequest();

      expect(
        () async => client.call<MapPayload>(request),
        throwsA(isA<UnsupportedError>()),
      );
    },
  );
}

class _UnsupportedRequest extends Request {
  const _UnsupportedRequest({
    // ignore: unused_element
    super.host = 'api.example.com',
    // ignore: unused_element
    super.endpoint = '/users',
  });
}
