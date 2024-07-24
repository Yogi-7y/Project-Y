import 'package:network_y/src/request/request.dart';
import 'package:test/test.dart';

class TestRequest extends Request {
  const TestRequest({
    required super.baseUrl,
    required super.endpoint,
    super.headers,
    super.queryParameters,
    super.timeout,
  });
}

// This concrete implementation is just for testing purposes
class TestGetRequest extends Request implements GetRequest {
  const TestGetRequest({
    required super.baseUrl,
    required super.endpoint,
    super.headers,
    super.queryParameters,
    super.timeout,
  });
}

void main() {
  group('Request', () {
    test('creates instance with required parameters', () {
      const request = TestRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
      );

      expect(request.baseUrl, 'https://api.example.com');
      expect(request.endpoint, '/users');
      expect(request.headers, isEmpty);
      expect(request.queryParameters, isEmpty);
      expect(request.timeout, const Duration(seconds: 30));
    });

    test('creates instance with all parameters', () {
      const request = TestRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
        headers: {'Authorization': 'Bearer token'},
        queryParameters: {'page': '1', 'limit': '10'},
        timeout: Duration(seconds: 45),
      );

      expect(request.baseUrl, 'https://api.example.com');
      expect(request.endpoint, '/users');
      expect(request.headers, {'Authorization': 'Bearer token'});
      expect(request.queryParameters, {'page': '1', 'limit': '10'});
      expect(request.timeout, const Duration(seconds: 45));
    });

    group('url getter', () {
      test('returns correct URL without query parameters', () {
        const request = TestRequest(
          baseUrl: 'https://api.example.com',
          endpoint: '/users',
        );

        expect(request.url, 'https://api.example.com/users');
      });

      test('returns correct URL with query parameters', () {
        const request = TestRequest(
          baseUrl: 'https://api.example.com',
          endpoint: '/users',
          queryParameters: {'page': '1', 'limit': '10'},
        );

        expect(request.url, 'https://api.example.com/users?page=1&limit=10');
      });

      test('handles trailing slash in baseUrl correctly', () {
        const request = TestRequest(
          baseUrl: 'https://api.example.com/',
          endpoint: '/users',
        );

        expect(request.url, 'https://api.example.com/users');
      });

      test('handles leading slash in endpoint correctly', () {
        const request = TestRequest(
          baseUrl: 'https://api.example.com',
          endpoint: 'users',
        );

        expect(request.url, 'https://api.example.com/users');
      });

      test('encodes query parameters correctly', () {
        const request = TestRequest(
          baseUrl: 'https://api.example.com',
          endpoint: '/search',
          queryParameters: {'q': 'flutter dart'},
        );

        expect(request.url, 'https://api.example.com/search?q=flutter+dart');
      });

      test('handles special characters in query parameters', () {
        const request = TestRequest(
          baseUrl: 'https://api.example.com',
          endpoint: '/search',
          queryParameters: {'q': 'flutter&dart', 'filter': 'year>2020'},
        );

        expect(request.url, 'https://api.example.com/search?q=flutter%26dart&filter=year%3E2020');
      });
    });
  });

  group('GetRequest', () {
    test('can be instantiated as a Request', () {
      const request = TestGetRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
      );

      expect(request, isA<Request>());
      expect(request, isA<GetRequest>());
    });

    test('inherits properties from Request', () {
      const request = TestGetRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
        headers: {'Authorization': 'Bearer token'},
        queryParameters: {'page': '1'},
        timeout: Duration(seconds: 45),
      );

      expect(request.baseUrl, 'https://api.example.com');
      expect(request.endpoint, '/users');
      expect(request.headers, {'Authorization': 'Bearer token'});
      expect(request.queryParameters, {'page': '1'});
      expect(request.timeout, const Duration(seconds: 45));
    });

    test('generates correct URL', () {
      const request = TestGetRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
        queryParameters: {'page': '1', 'limit': '10'},
      );

      expect(request.url, 'https://api.example.com/users?page=1&limit=10');
    });

    test('can be used in a list of Requests', () {
      final requests = <Request>[
        const TestGetRequest(baseUrl: 'https://api.example.com', endpoint: '/users'),
        const TestGetRequest(baseUrl: 'https://api.example.com', endpoint: '/posts'),
      ];

      expect(requests, everyElement(isA<GetRequest>()));
      expect(requests, everyElement(isA<Request>()));
    });

    test('maintains immutability', () {
      const request = TestGetRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
      );

      expect(() => (request as dynamic).baseUrl = 'https://new.example.com', throwsA(anything));
      expect(() => (request as dynamic).endpoint = '/new', throwsA(anything));
    });
  });
}
