import 'package:flutter_test/flutter_test.dart';
import 'package:network/src/request/request.dart';

void main() {
  test('test endpoint', () {
    const _request = GetRequest(host: 'api.example.com', endpoint: '/users');
    const _expectedResult = 'https://api.example.com/users';
    expect(_request.url, _expectedResult);
  });

  test(
    'query parameters',
    () {
      const _request = GetRequest(
        host: 'api.example.com',
        endpoint: '/users',
        queryParameters: {'page': '1', 'limit': '10'},
      );

      const _expectedResult = 'https://api.example.com/users?page=1&limit=10';

      expect(_request.url, _expectedResult);
    },
  );

  test(
    'query parameters with empty headers',
    () {
      const _request = GetRequest(
        host: 'api.example.com',
        endpoint: '/users',
        queryParameters: {'page': '1', 'limit': '10'},
        headers: {'token': '123'},
      );

      const _expectedResult = 'https://api.example.com/users?page=1&limit=10';

      expect(_request.url, _expectedResult);
      expect(_request.headers, {'token': '123'});
    },
  );

  test(
    'custom scheme',
    () {
      const _request = GetRequest(
        host: 'api.example.com',
        endpoint: '/users',
        scheme: 'http',
      );

      const _expectedResult = 'http://api.example.com/users';

      expect(_request.url, _expectedResult);
    },
  );

  test('post request', () {
    const _request = PostRequest(
      host: 'api.example.com',
      endpoint: '/users',
      body: {'name': 'John Doe'},
      queryParameters: {'page': '1', 'limit': '10'},
      headers: {'token': '123'},
    );

    const _expectedResult = 'https://api.example.com/users?page=1&limit=10';

    expect(_request.url, _expectedResult);
    expect(_request.body, {'name': 'John Doe'});
    expect(_request.headers, {'token': '123'});
  });
}
