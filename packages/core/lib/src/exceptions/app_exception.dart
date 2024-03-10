// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

@immutable
class AppException implements Exception {
  const AppException({
    required this.consoleMessage,
    this.message = 'Something went wrong. Please try again later.',
  });

  /// User-friendly message
  final String message;

  /// Console-friendly message
  final String consoleMessage;
}

class SerializationException extends AppException {
  const SerializationException({required super.consoleMessage, super.message});
}
