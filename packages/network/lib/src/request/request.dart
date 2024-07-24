import 'package:flutter/foundation.dart';

typedef Headers = Map<String, String>;
typedef QueryParameters = Map<String, String>;
typedef Payload = Map<String, Object?>;

@immutable
abstract class Request {
  const Request({
    required this.baseUrl,
    required this.endpoint,
    this.headers = const {},
    this.queryParameters = const {},
    this.timeout = const Duration(seconds: 30),
  });

  /// Eg. https://api.example.com
  final String baseUrl;

  /// Eg. /users
  final String endpoint;

  /// Headers to be sent with the request
  final Headers headers;

  /// Query parameters to be sent with the request
  /// Eg. {'page': '1', 'limit': '10'}
  /// will be converted to `?page=1&limit=10`
  final QueryParameters queryParameters;

  /// Timeout duration for the request
  final Duration timeout;

  /// Computed full URL including base URL, endpoint, and query parameters
  String get url => Uri.parse(baseUrl)
      .replace(
        path: endpoint,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      )
      .toString();
}

abstract class GetRequest implements Request {}
