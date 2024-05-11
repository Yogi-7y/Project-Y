import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../domain/entity/token.dart';
import '../domain/entity/tokenizer.dart';
import '../domain/use_case/smart_textfield_use_case.dart';

class SmartTextFieldController extends TextEditingController {
  SmartTextFieldController({
    required this.tokenizers,
  });

  final List<Tokenizer> tokenizers;

  final _tokens = <Token>[];

  /// DateTime that was identified from the text.
  DateTime? highlightedDateTime;

  /// Tokens that were identified from the text based on the [tokenizers].
  /// To read the value of a specific token, lookup via its prefix.
  /// For example, to get the value of a token with the prefix '@', use:
  /// ```dart
  /// final value = highlightedTokens['@']?.value as Type?;
  /// ```
  final highlightedTokens = ValueNotifier<Map<String, Token>>({});

  late final _useCase = SmartTextFieldUseCase(tokenizers: tokenizers);
  late final suggestions = ValueNotifier<List<Tokenable>>([]);

  void setDateTime() {
    final _dateTimeToken = _tokens.firstWhereOrNull(
      (token) => token.prefix == dateTimePrefix,
    );

    final _value = _dateTimeToken?.value;

    if (_value is TokenableDateTime) {
      highlightedDateTime = _value;
    }
  }

  void _updateSuggestions() {
    suggestions.value = [];

    for (final tokenizer in tokenizers) {
      final _suggestions = tokenizer.suggestions(text);

      if (_suggestions.isNotEmpty) {
        suggestions.value.addAll(_suggestions);
        suggestions.notifyListeners();
        return;
      }
    }
  }

  @override
  void dispose() {
    suggestions.dispose();
    super.dispose();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    final _inlineSpans = <InlineSpan>[];

    final _tokenizeResult = _useCase.tokenize(text: text);

    highlightedTokens.value.clear();
    highlightedTokens.notifyListeners();

    _tokens
      ..clear()
      ..addAll(_tokenizeResult);

    setDateTime();

    Future.delayed(
      Duration.zero,
      _updateSuggestions,
    );

    for (final token in _tokenizeResult) {
      if (token.isHighlighted) {
        _inlineSpans
          ..add(
            buildHighlightedTextSpan(
              context: context,
              text: token.displayValue,
              style: style,
            ),
          )
          ..addAll(
            buildHighlightedSpanWhiteSpaces(
              numberOfSpans: token.prefix == dateTimePrefix
                  ? token.displayValue.length - 1
                  : token.displayValue.length,
            ),
          );

        highlightedTokens.value[token.prefix] = token;
        highlightedTokens.notifyListeners();
      } else {
        _inlineSpans.add(
          buildNormalTextSpan(
            text: token.displayValue,
            style: style,
          ),
        );
      }
    }

    return TextSpan(
      children: _inlineSpans,
      style: style,
    );
  }

  InlineSpan buildNormalTextSpan({
    required String text,
    TextStyle? style,
  }) =>
      TextSpan(
        text: text,
        style: style,
      );

  InlineSpan buildHighlightedTextSpan({
    required BuildContext context,
    required String text,
    TextStyle? style,
  }) =>
      WidgetSpan(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(.2),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2.5,
              ),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: style,
          ),
        ),
        alignment: PlaceholderAlignment.middle,
        style: style,
        baseline: TextBaseline.alphabetic,
      );

  List<InlineSpan> buildHighlightedSpanWhiteSpaces({
    required int numberOfSpans,
  }) =>
      List.generate(
        numberOfSpans,
        (index) => const WidgetSpan(child: Text('')),
      );
}
