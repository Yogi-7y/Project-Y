// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Represents the extracted value form the input text.
@immutable
class Token<T extends Tokenable> {
  Token({
    required this.rawValue,
    required this.displayValue,
    required this.offset,
    required this.prefix,
    this.value,
    this.isHighlighted = false,
  }) : assert(
          !isHighlighted || prefix.isNotEmpty,
          'isHighlighted should be true only when prefix is not empty.',
        );

  /// Value extracted directly from input without any modification.
  /// Looks like: `@JohnDoe`
  final String rawValue;

  /// Value that will be displayed in the input field once the token is matched for better readability.
  final String displayValue;

  final T? value;

  final TokenOffset offset;

  /// Indicates if the token should be highlighted in the input field.
  final bool isHighlighted;

  /// Special character that invokes the tokenizer and is used to match the pattern in the input text.
  /// Empty string means that it's a normal text.
  final String prefix;

  @override
  String toString() {
    return 'Token(rawValue: $rawValue, displayValue: $displayValue, value: $value, offset: $offset, isHighlighted: $isHighlighted, prefix: $prefix)';
  }

  @override
  bool operator ==(covariant Token<T> other) {
    if (identical(this, other)) return true;

    return other.rawValue == rawValue &&
        other.displayValue == displayValue &&
        other.value == value &&
        other.offset == offset &&
        other.isHighlighted == isHighlighted &&
        other.prefix == prefix;
  }

  @override
  int get hashCode {
    return rawValue.hashCode ^
        displayValue.hashCode ^
        value.hashCode ^
        offset.hashCode ^
        isHighlighted.hashCode ^
        prefix.hashCode;
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
    required this.prefix,
  });

  final String stringValue;

  final String prefix;
}
