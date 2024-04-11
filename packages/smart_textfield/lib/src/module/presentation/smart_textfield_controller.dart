// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../smart_textfield.dart';
import '../domain/use_case/smart_textfield_use_case.dart';

typedef Offset = ({int start, int end});

const _noOffset = (start: -1, end: -1);

class SmartTextFieldController extends TextEditingController {
  SmartTextFieldController({
    List<SelectionMenu> selectionMenus = const [],
  }) : _selectionMenus = selectionMenus {
    addListener(_handleTextChange);
  }

  late final _useCase = SmartTextFieldUseCase();
  DateTimeData? _dateTimeValue;
  DateTimeData? get dateTimeValue => _dateTimeValue;
  // ignore: use_setters_to_change_properties
  void setDateTimeValue(DateTimeData value) => _dateTimeValue = value;

  final List<SelectionMenu> _selectionMenus;

  /// Map of values selected by the user.
  /// The key is the pattern and the value is the selected item.
  final selectedValues = <String, SelectionItemMetaData>{};

  /// The currently active selection menu based on the
  /// pattern matched in the text field.
  SelectionMenu? activeSelectionMenu;

  /// The offset of the currently active pattern from the selection menu in the text field.\
  /// For example, if the user types "p:query", then the offset will be (start: 0, end: 1).\
  @visibleForTesting
  Offset activePatternOffset = _noOffset;

  void selectValue(
    String pattern,
    SelectionMenuItem item,
  ) {
    final _term = '$pattern$query';
    final _offset = _getOffset(_term);
    text = replace(_offset, item.queryContent);

    final _updatedOffset = _getOffset(item.queryContent);

    final _metaData = SelectionItemMetaData(
      item: item,
      offset: _updatedOffset,
    );

    selectedValues[pattern] = _metaData;

    clearSelectionMenu();
  }

  /// Removes the currently active selection menu overlay.
  void removeActiveSelectionMenu() {
    activeSelectionMenu = null;
  }

  /// The list of [SelectionMenuItem]s that are currently shown to the user
  /// in the overlay.
  @internal
  final activeOptions = <SelectionMenuItem>[];

  void _updateActiveOptions() {
    activeOptions
      ..clear()
      ..addAll(getActiveOptions());
  }

  /// The current query that is being used to search in the list of SelectionMenuItems. \
  /// This is used to filter the list of items. \
  /// For example, if the user types "p:query", then the query will be "query". \
  @visibleForTesting
  String query = '';

  void _handleTextChange() {
    final _dateTime = _useCase.processDateTime(text);

    if (_dateTime != null) {
      final _textSubstring = text.substring(_dateTime.start, _dateTime.end);

      _dateTimeValue = DateTimeData(
        dateTime: _dateTime.value,
        value: _textSubstring,
        offset: (start: _dateTime.start, end: _dateTime.end),
      );
    }

    activeSelectionMenu = _getActiveSelectionMenu();

    if (activeSelectionMenu == null) {
      clearSelectionMenu();
      return;
    }

    activePatternOffset = _getOffset(activeSelectionMenu!.pattern);
    query = _getQuery();
    _updateActiveOptions();
  }

  SelectionMenu? _getActiveSelectionMenu() {
    final _currentWord = text.isNotEmpty ? text.split(' ').last : '';

    // final _lastTwoLetters = text.length >= 2 ? _currentWord.substring(0, text.length - 2) : '';
    final _lastTwoLetters = text.length >= 2 ? text.substring(text.length - 2) : '';

    if (_currentWord.isEmpty) return null;
    if (_lastTwoLetters == '  ') return null;

    if (activeSelectionMenu != null) return activeSelectionMenu;

    final _selectionMenu = _selectionMenus.firstWhereOrNull(
      (element) => _currentWord.startsWith(element.pattern),
    );

    if (selectedValues.containsKey(_selectionMenu?.pattern)) return null;

    return _selectionMenu;
  }

  Offset _getOffset(String word) {
    final _index = text.indexOf(word);
    if (_index == -1) return _noOffset;

    final _endIndex = _index + word.length;

    return (start: _index, end: _endIndex);
  }

  String replace(Offset offset, String replacement) {
    final _before = text.substring(0, offset.start);
    final _after = text.substring(offset.end);

    return '$_before$replacement$_after';
  }

  String _getQuery() {
    final _patternStart = text.lastIndexOf(activeSelectionMenu!.pattern);
    final _patternEnd = _patternStart + activeSelectionMenu!.pattern.length;

    return text.substring(_patternEnd);
  }

  List<SelectionMenuItem> getActiveOptions() {
    if (activeSelectionMenu == null) return [];

    return activeSelectionMenu!.items
        .where((element) => element.queryContent.contains(query))
        .toList();
  }

  bool get isCursorAtEnd => selection.start == text.length && selection.end == text.length;

  /// Boolean to determine if it needs to update the offset of the selected values based on the cursor position.
  /// Returns `true` if the cursor is not at the end and it's before any of the items, `false` otherwise.
  bool get updateSelectedValues {
    if (isCursorAtEnd) return false;
    return selectedValues.values.any((item) => selection.start < item.offset.start);
  }

  void clearSelectionMenu() {
    query = '';
    activeOptions.clear();
    activeSelectionMenu = null;
    activePatternOffset = _noOffset;
  }

  @visibleForTesting
  List<TextSpanInfo> convertToTextSpanInfo() {
    if (selectedValues.isEmpty)
      return [
        TextSpanInfo(
          text: text,
          isHighlighted: false,
          offset: (start: 0, end: text.length + 1),
        )
      ];

    final _textSpanInfo = <TextSpanInfo>[];

    var currentOffset = 0;

    selectedValues.forEach((pattern, value) {
      // Add the text before the selected value
      if (value.offset.start > currentOffset) {
        _textSpanInfo.add(
          TextSpanInfo(
            text: text.substring(currentOffset, value.offset.start),
            isHighlighted: false,
            offset: (start: currentOffset, end: value.offset.start),
          ),
        );
      }

      // Add the selected value
      _textSpanInfo.add(
        TextSpanInfo(
          text: value.item.queryContent,
          isHighlighted: true,
          offset: value.offset,
        ),
      );

      currentOffset = value.offset.end;
    });

    // Add the remaining text after the last selected value
    if (currentOffset < text.length) {
      _textSpanInfo.add(
        TextSpanInfo(
          text: text.substring(currentOffset),
          isHighlighted: false,
          offset: (start: currentOffset, end: text.length),
        ),
      );
    }

    return _textSpanInfo;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    final _value = _useCase.processDateTime(text);

    if (_value == null)
      return TextSpan(
        style: style,
        children: [
          TextSpan(
            text: text,
          ),
        ],
      );

    final _before = TextSpan(
      text: text.substring(0, _value.start),
      style: style,
    );

    final _highlight = TextSpan(
      text: text.substring(_value.start, _value.end),
      style: style?.copyWith(
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.dashed,
        decorationThickness: 1,
        decorationColor: Colors.grey,
      ),
    );

    final _after = TextSpan(
      text: text.substring(_value.end),
      style: style,
    );

    return TextSpan(
      children: [
        _before,
        _highlight,
        _after,
      ],
      style: style,
    );
  }
}

@immutable
class SelectionItemMetaData {
  const SelectionItemMetaData({
    required this.item,
    required this.offset,
  });

  final SelectionMenuItem item;
  final Offset offset;

  @override
  String toString() => 'SelectionItemMetaData(item: $item, offset: $offset)';

  @override
  bool operator ==(covariant SelectionItemMetaData other) {
    if (identical(this, other)) return true;

    return other.item == item && other.offset == offset;
  }

  @override
  int get hashCode => item.hashCode ^ offset.hashCode;
}

@immutable
class TextSpanInfo {
  const TextSpanInfo({
    required this.text,
    required this.isHighlighted,
    required this.offset,
  });

  final String text;
  final bool isHighlighted;
  final Offset offset;

  @override
  String toString() => 'TextSpanInfo(text: $text, isHighlighted: $isHighlighted, offset: $offset)';

  @override
  bool operator ==(covariant TextSpanInfo other) {
    if (identical(this, other)) return true;

    return other.text == text && other.isHighlighted == isHighlighted && other.offset == offset;
  }

  @override
  int get hashCode => text.hashCode ^ isHighlighted.hashCode ^ offset.hashCode;
}

@immutable
class DateTimeData {
  const DateTimeData({
    required this.dateTime,
    required this.value,
    required this.offset,
  });

  /// The text that is converted to a DateTime object.
  final DateTime dateTime;

  /// The text value passed by the user.
  final String value;

  /// The offset of the text value in the text field.
  final Offset offset;

  @override
  String toString() => 'DateTimeData(dateTime: $dateTime, value: $value, offset: $offset)';

  @override
  bool operator ==(covariant DateTimeData other) {
    if (identical(this, other)) return true;

    return other.dateTime == dateTime && other.value == value && other.offset == offset;
  }

  @override
  int get hashCode => dateTime.hashCode ^ value.hashCode ^ offset.hashCode;
}
