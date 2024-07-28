// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../request/request.dart';

@immutable
class ApiException implements Exception {
  const ApiException({
    required this.request,
    this.statusCode,
    this.response,
    this.error,
    this.stackTrace,
  });

  final Request request;
  final int? statusCode;
  final Object? response;
  final Object? error;
  final StackTrace? stackTrace;
}
