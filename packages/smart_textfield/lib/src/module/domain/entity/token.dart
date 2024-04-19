// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Represents the extracted value form the input text.
@immutable
class Token<T> {
  const Token({
    required this.rawValue,
    required this.displayValue,
    required this.offset,
    required this.value,
  });

  /// Value extracted directly from input without any modification.
  /// Looks like: `@JohnDoe`
  final String rawValue;

  /// Value that will be displayed in the input field once the token is matched for better readability.
  final String displayValue;

  final T value;

  final TokenOffset offset;

  @override
  String toString() {
    return 'Token(rawValue: $rawValue, displayValue: $displayValue, value: $value, offset: $offset)';
  }

  @override
  bool operator ==(covariant Token<T> other) {
    if (identical(this, other)) return true;

    return other.rawValue == rawValue &&
        other.displayValue == displayValue &&
        other.value == value &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    return rawValue.hashCode ^ displayValue.hashCode ^ value.hashCode ^ offset.hashCode;
  }
}

@immutable
class TokenOffset {
  const TokenOffset({
    required this.start,
    required this.end,
  });

  final int start;
  final int end;

  @override
  String toString() => 'TokenOffset(start: $start, end: $end)';

  @override
  bool operator ==(covariant TokenOffset other) {
    if (identical(this, other)) return true;

    return other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

@immutable
abstract class Tokenable {
  const Tokenable({
    required this.stringValue,
  });

  final String stringValue;

  @override
  String toString() => 'Tokenable(stringValue: $stringValue)';

  @override
  bool operator ==(covariant Tokenable other) {
    if (identical(this, other)) return true;

    return other.stringValue == stringValue;
  }

  @override
  int get hashCode => stringValue.hashCode;
}
