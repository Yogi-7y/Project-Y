// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../use_case/smart_textfield_use_case.dart';

@immutable
class ParserValue<T> {
  const ParserValue({
    required this.start,
    required this.end,
    required this.value,
  });

  final int start;
  final int end;
  final T value;

  @override
  String toString() => 'ParserValue(start: $start, end: $end, value: $value)';

  @override
  bool operator ==(covariant ParserValue<T> other) {
    if (identical(this, other)) return true;

    return other.start == start && other.end == end && other.value == value;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ value.hashCode;
}
