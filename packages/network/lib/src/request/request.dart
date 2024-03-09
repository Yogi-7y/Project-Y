import 'package:meta/meta.dart';

/// {@template request}
/// Contract for a HTTP request.
/// {@endtemplate}
@immutable
@internal
abstract class Request {
  /// {@macro request}
  const Request({
    required this.host,
    required this.endpoint,
    this.scheme = 'https',
    this.headers = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  /// Host for the URL.
  /// Example: `abc.example.com/`
  final String host;

  /// Scheme for the URL.
  /// Example: `https`
  final String scheme;

  /// Endpoint of the request.
  /// Example: `/users`
  /// Will be appended to the `url` resulting in `https://example.com/api/v1/users`
  final String endpoint;

  /// Request headers.
  final Map<String, String> headers;

  /// Query parameters.
  /// Example: `{'page': '1', 'limit': '10'}`
  /// Will be converted to `?page=1&limit=10`
  /// for url `https://example.com/api/v1/users`
  /// resulting in `https://example.com/api/v1/users?page=1&limit=10`
  final Map<String, String> queryParameters;

  /// Returns the URL string representation of the request.
  String get url => Uri(
        scheme: scheme,
        host: host,
        path: endpoint,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      ).toString();
}

@immutable
class GetRequest extends Request {
  const GetRequest({
    required super.host,
    required super.endpoint,
    super.scheme,
    super.queryParameters,
    super.headers,
  });
}

@immutable
class PostRequest extends Request {
  const PostRequest({
    required super.host,
    required super.endpoint,
    required this.body,
    super.scheme,
    super.headers,
    super.queryParameters,
  });

  /// Body of the request for a POST request.
  /// Example: `{'name': 'John Doe', 'age': 25}`
  /// For a GET request, it will be ignored.
  final Map<String, Object?> body;
}
