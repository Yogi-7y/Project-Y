import 'package:flutter/material.dart';

import '../domain/entity/tokenizer.dart';
import '../domain/use_case/smart_textfield_use_case.dart';

class SmartTextFieldController extends TextEditingController {
  SmartTextFieldController({
    required this.tokenizers,
  });

  final List<Tokenizer> tokenizers;

  late final _useCase = SmartTextFieldUseCase(tokenizers: tokenizers);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    final _inlineSpans = <InlineSpan>[];

    final _tokens = _useCase.tokenize(text: text);

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
                numberOfSpans: token.displayValue.length - 1),
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
