// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:core_y/core_y.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../request/request.dart';

@immutable
class ApiException extends AppException {
  const ApiException({
    required this.request,
    required super.stackTrace,
    required super.exception,
    this.statusCode,
    this.response,
  });

  final Request request;
  final int? statusCode;
  final Object? response;

  bool get isNetworkError => exception is SocketException || exception is HttpException;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isClientError => statusCode != null && statusCode! >= 400 && statusCode! < 500;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isTimeoutError => exception is TimeoutException;

  @override
  String get userFriendlyMessage {
    if (isNetworkError)
      return 'Network connection error. Please check your internet connection and try again.';

    if (isServerError) return 'Server error. Please try again later.';

    if (isClientError) {
      if (isUnauthorized) return 'Unauthorized. Please login and try again.';
      if (isForbidden) return 'Forbidden. You do not have permission to access this resource.';
      if (isNotFound) return 'Resource not found. Please try again later.';
    }

    if (isTimeoutError) return 'Request timed out. Please try again later.';

    return 'Something went wrong. Please try again later.';
  }

  factory ApiException.fromDioException(
    DioException e,
    StackTrace s,
    Request request,
  ) {
    return ApiException(
      request: request,
      statusCode: e.response?.statusCode,
      response: e.response?.data,
      exception: e.error,
      stackTrace: s,
    );
  }

  factory ApiException.fromException(
    Object e,
    StackTrace s,
    Request request,
  ) {
    return ApiException(
      request: request,
      exception: e,
      stackTrace: s,
    );
  }
}
