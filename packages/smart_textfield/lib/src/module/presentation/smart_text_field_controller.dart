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

  /// Map of tokens that were extracted from the raw text.
  /// To access the token, use the prefix of the tokenizer.
  /// For example, if the prefix is @,
  /// ```dart
  /// final projectToken = highlightedTokens['@'];
  /// ```
  final highlightedTokens = <String, Token>{};

  late final _useCase = SmartTextFieldUseCase(tokenizers: tokenizers);
  late final suggestions = ValueNotifier<List<Tokenable>>([]);

  @override
  void notifyListeners() {
    final _result = _useCase.tokenize(text: text);

    _tokens
      ..clear()
      ..addAll(_result);

    setDateTime();
    setHighlightedTokens();
    super.notifyListeners();
  }

  void setDateTime() {
    final _dateTimeToken = _tokens.firstWhereOrNull(
      (token) => token.prefix == dateTimePrefix,
    );

    if (_dateTimeToken == null) {
      highlightedDateTime = null;
      return;
    }

    final _value = _dateTimeToken.value;

    if (_value is TokenableDateTime) {
      highlightedDateTime = _value;
    }
  }

  void setHighlightedTokens() {
    highlightedTokens.clear();

    for (final token in _tokens) {
      if (token.isHighlighted) {
        highlightedTokens[token.prefix] = token;
      }
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

  int _lastCursorPosition = 0;

  @override
  set selection(TextSelection newSelection) {
    final _cursorPosition = newSelection.baseOffset;

    final _token = _tokens.firstWhereOrNull(
      (element) =>
          element.isHighlighted &&
          _cursorPosition > element.offset.start &&
          _cursorPosition < element.offset.end,
    );

    if (_token != null) {
      final _newPosition =
          newSelection.baseOffset < _lastCursorPosition ? _token.offset.start : _token.offset.end;

      super.selection = TextSelection.fromPosition(TextPosition(offset: _newPosition));
      _lastCursorPosition = _newPosition;
      return;
    }

    super.selection = newSelection;
    _lastCursorPosition = newSelection.baseOffset;
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

    Future.delayed(
      Duration.zero,
      _updateSuggestions,
    );

    for (final token in _tokens) {
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
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(.2),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: style?.copyWith(height: 1.4),
          ),
        ),
        // alignment: PlaceholderAlignment.middle,
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
