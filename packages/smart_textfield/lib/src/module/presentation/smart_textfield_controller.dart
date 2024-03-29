// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../smart_textfield.dart';

typedef Offset = ({int start, int end});

const _noOffset = (start: -1, end: -1);

class SmartTextFieldController extends TextEditingController {
  SmartTextFieldController({
    List<SelectionMenu> selectionMenus = const [],
  }) : _selectionMenus = selectionMenus {
    addListener(_handleTextChange);
  }

  // late final _useCase = SmartTextFieldUseCase();
  final List<SelectionMenu> _selectionMenus;

  /// Map of values selected by the user.
  /// The key is the pattern and the value is the selected item.
  final selectedValues = <String, SelectionItemMetaData>{};

  /// The currently active selection menu based on the
  /// pattern matched in the text field.
  @visibleForTesting
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

    final _metaData = SelectionItemMetaData(
      item: item,
      offset: _offset,
    );
    selectedValues[pattern] = _metaData;
    clearSelectionMenu();
    text = replace(_offset, item.queryContent);
  }

  /// Removes the currently active selection menu overlay.
  void removeActiveSelectionMenu() {
    activeSelectionMenu = null;
  }

  /// The list of [SelectionMenuItem]s that are currently shown to the user
  /// in the overlay.
  @visibleForTesting
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

  void clearSelectionMenu() {
    query = '';
    activeOptions.clear();
    activeSelectionMenu = null;
    activePatternOffset = _noOffset;
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
