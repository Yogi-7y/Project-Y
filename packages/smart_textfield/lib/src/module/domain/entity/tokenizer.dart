import 'package:flutter/material.dart';

import 'token.dart';

/// [Tokenizer] is a class responsible for extracting specific values from user input
/// based on predefined patterns and presenting a list of possible values to the user.
///
/// The [Tokenizer] is used by the SmartTextField to parse user input and extract
/// relevant information.
abstract class Tokenizer<T extends Tokenable> {
  Tokenizer({
    required this.prefix,
    required this.values,
  }) {
    _populateValuesWithPrefix();
  }

  /// A prefix that will be used to match the pattern in the input text.
  final String prefix;

  /// A list of possible values that can be suggested to the user when the
  /// pattern is matched in the input text.
  final List<T> values;

  final valuesWithPrefix = <({String prefixValue, T value})>[];

  void _populateValuesWithPrefix() {
    final _values = values.map((e) => (prefixValue: '$prefix${e.stringValue}', value: e)).toList();
    valuesWithPrefix.addAll(_values);
  }

  @protected
  WidgetBuilder suggestionBuilder(BuildContext context, Token<T> token);

  @visibleForTesting
  List<T> suggestions(String input) {
    /// find if the prefix is being used anywhere in the input
    /// if not, return an empty list
    /// If yes, then take the substring from that index forward till the end of the input.
    /// Then, find the matching values from the values list and return them.

    final _prefixPattern = RegExp(prefix);
    final _prefixMatch = _prefixPattern.firstMatch(input);

    if (_prefixMatch != null) {
      final _query = input.substring(_prefixMatch.start);

      final _suggestions = valuesWithPrefix
          .where(
            (value) => value.prefixValue.startsWith(_query),
          )
          .toList();

      return _suggestions.map((e) => e.value).toList();
    }

    return [];
  }

  List<Token<T>> tokenize(String input) {
    final _tokens = <Token<T>>[];

    for (final value in values) {
      final _pattern = RegExp('$prefix${value.stringValue}');
      final _match = _pattern.firstMatch(input);

      if (_match != null)
        _tokens.add(Token<T>(
          rawValue: '$prefix${value.stringValue}',
          displayValue: value.stringValue,
          value: value,
          offset: TokenOffset(
            start: _match.start,
            end: _match.end,
          ),
        ));
    }

    return _tokens;
  }
}
