// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef SelectionMenuBuilder<T> = Widget Function(BuildContext context, T item);

@immutable
abstract class SelectionMenu<T extends SelectionMenuItem> {
  const SelectionMenu({
    required this.pattern,
    required this.builder,
    required this.items,
  });

  /// The [pattern] which will be used to match in the text field.
  /// For example, "@", "/", "p:" etc.
  ///
  /// This pattern is matched only when the latest word from the sentence starts
  /// with the pattern.
  final String pattern;

  /// The [builder] which will be used to build the widget.
  final SelectionMenuBuilder<T> builder;

  /// The [items] which will be used to show the list of items in the overlay
  /// when the pattern is matched.
  final List<T> items;
}

@immutable
abstract class SelectionMenuItem {
  const SelectionMenuItem({
    required this.queryContent,
  });

  /// The text that will be populated in the text field when the item is selected.
  final String queryContent;

  @override
  String toString() => 'SelectionMenuItem(queryContent: $queryContent)';

  @override
  bool operator ==(covariant SelectionMenuItem other) {
    if (identical(this, other)) return true;

    return other.queryContent == queryContent;
  }

  @override
  int get hashCode => queryContent.hashCode;
}
