import 'package:network_y/src/request/request.dart';
import 'package:test/test.dart';

class TestRequest extends Request {
  TestRequest({
    required super.baseUrl,
    required super.endpoint,
    super.headers,
    super.queryParameters,
    super.timeout,
  });
}

// This concrete implementation is just for testing purposes
class TestGetRequest extends Request implements GetRequest {
  TestGetRequest({
    required super.baseUrl,
    required super.endpoint,
    super.headers,
    super.queryParameters,
    super.timeout,
  });
}

class TestPostRequest extends Request implements PostRequest {
  TestPostRequest({
    required super.baseUrl,
    required super.endpoint,
    required this.body,
    super.headers,
    super.queryParameters,
    super.timeout,
  });

  @override
  final Payload body;
}

class TestPatchRequest extends Request implements PatchRequest {
  TestPatchRequest({
    required super.baseUrl,
    required super.endpoint,
    required this.body,
    super.headers,
    super.queryParameters,
    super.timeout,
  });

  @override
  final Payload body;
}

void main() {
  group('Request', () {
    test('creates instance with required parameters', () {
      final request = TestRequest(
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
      final request = TestRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
        headers: const {'Authorization': 'Bearer token'},
        queryParameters: const {'page': '1', 'limit': '10'},
        timeout: const Duration(seconds: 45),
      );

      expect(request.baseUrl, 'https://api.example.com');
      expect(request.endpoint, '/users');
      expect(request.headers, {'Authorization': 'Bearer token'});
      expect(request.queryParameters, {'page': '1', 'limit': '10'});
      expect(request.timeout, const Duration(seconds: 45));
    });

    test('throws assertion error when baseUrl is empty', () {
      expect(
        () => TestRequest(baseUrl: '', endpoint: '/users'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when baseUrl is not a valid absolute URL', () {
      expect(
        () => TestRequest(baseUrl: 'not-a-url', endpoint: '/users'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when endpoint is empty', () {
      expect(
        () => TestRequest(baseUrl: 'https://api.example.com', endpoint: ''),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when endpoint contains query parameters', () {
      expect(
        () => TestRequest(baseUrl: 'https://api.example.com', endpoint: '/users?page=1'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when timeout is not positive', () {
      expect(
        () => TestRequest(
          baseUrl: 'https://api.example.com',
          endpoint: '/users',
          timeout: Duration.zero,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    group('url getter', () {
      test('returns correct URL without query parameters', () {
        final request = TestRequest(
          baseUrl: 'https://api.example.com',
          endpoint: '/users',
        );

        expect(request.url, 'https://api.example.com/users');
      });

      test('returns correct URL with query parameters', () {
        final request = TestRequest(
          baseUrl: 'https://api.example.com',
          endpoint: '/users',
          queryParameters: const {'page': '1', 'limit': '10'},
        );

        expect(request.url, 'https://api.example.com/users?page=1&limit=10');
      });

      test('handles trailing slash in baseUrl correctly', () {
        final request = TestRequest(
          baseUrl: 'https://api.example.com/',
          endpoint: '/users',
        );

        expect(request.url, 'https://api.example.com/users');
      });

      test('handles leading slash in endpoint correctly', () {
        final request = TestRequest(
          baseUrl: 'https://api.example.com',
          endpoint: 'users',
        );

        expect(request.url, 'https://api.example.com/users');
      });

      test('encodes query parameters correctly', () {
        final request = TestRequest(
          baseUrl: 'https://api.example.com',
          endpoint: '/search',
          queryParameters: const {'q': 'flutter dart'},
        );

        expect(request.url, 'https://api.example.com/search?q=flutter+dart');
      });

      test('handles special characters in query parameters', () {
        final request = TestRequest(
          baseUrl: 'https://api.example.com',
          endpoint: '/search',
          queryParameters: const {'q': 'flutter&dart', 'filter': 'year>2020'},
        );

        expect(request.url, 'https://api.example.com/search?q=flutter%26dart&filter=year%3E2020');
      });
    });
  });

  group('GetRequest', () {
    test('can be instantiated as a Request', () {
      final request = TestGetRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
      );

      expect(request, isA<Request>());
      expect(request, isA<GetRequest>());
    });

    test('inherits properties from Request', () {
      final request = TestGetRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
        headers: const {'Authorization': 'Bearer token'},
        queryParameters: const {'page': '1'},
        timeout: const Duration(seconds: 45),
      );

      expect(request.baseUrl, 'https://api.example.com');
      expect(request.endpoint, '/users');
      expect(request.headers, {'Authorization': 'Bearer token'});
      expect(request.queryParameters, {'page': '1'});
      expect(request.timeout, const Duration(seconds: 45));
    });

    test('generates correct URL', () {
      final request = TestGetRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
        queryParameters: const {'page': '1', 'limit': '10'},
      );

      expect(request.url, 'https://api.example.com/users?page=1&limit=10');
    });

    test('can be used in a list of Requests', () {
      final requests = <Request>[
        TestGetRequest(baseUrl: 'https://api.example.com', endpoint: '/users'),
        TestGetRequest(baseUrl: 'https://api.example.com', endpoint: '/posts'),
      ];

      expect(requests, everyElement(isA<GetRequest>()));
      expect(requests, everyElement(isA<Request>()));
    });

    test('maintains immutability', () {
      final request = TestGetRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
      );

      expect(() => (request as dynamic).baseUrl = 'https://new.example.com', throwsA(anything));
      expect(() => (request as dynamic).endpoint = '/new', throwsA(anything));
    });
  });

  group('PostRequest', () {
    test('creates instance with valid parameters', () {
      expect(
        () => TestPostRequest(
          baseUrl: 'https://api.example.com',
          endpoint: '/users',
          body: const {'name': 'John Doe', 'email': 'john@example.com'},
        ),
        returnsNormally,
      );
    });

    test('implements both Request and PostRequest', () {
      final request = TestPostRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
        body: const {'name': 'John Doe'},
      );

      expect(request, isA<Request>());
      expect(request, isA<PostRequest>());
    });

    test('contains body data', () {
      final request = TestPostRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users',
        body: const {'name': 'John Doe'},
      );

      expect(request.body, {'name': 'John Doe'});
    });
  });
  group('PatchRequest', () {
    test('creates instance with valid parameters', () {
      expect(
        () => TestPatchRequest(
          baseUrl: 'https://api.example.com',
          endpoint: '/users/1',
          body: const {'name': 'Jane Doe'},
        ),
        returnsNormally,
      );
    });

    test('implements both Request and PatchRequest', () {
      final request = TestPatchRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users/1',
        body: const {'name': 'Jane Doe'},
      );

      expect(request, isA<Request>());
      expect(request, isA<PatchRequest>());
    });

    test('contains body data', () {
      final request = TestPatchRequest(
        baseUrl: 'https://api.example.com',
        endpoint: '/users/1',
        body: const {'name': 'Jane Doe'},
      );

      expect(request.body, {'name': 'Jane Doe'});
    });
  });
}
