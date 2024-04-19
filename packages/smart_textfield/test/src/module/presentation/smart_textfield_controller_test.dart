// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_textfield/smart_textfield.dart';
import 'package:smart_textfield/src/core/date_time_extension.dart';
import 'package:smart_textfield/src/module/presentation/smart_textfield_controller.dart';

void main() {
  late SmartTextFieldController controller;

  setUp(() {
    controller = SmartTextFieldController(
      selectionMenus: _selectionMenu,
    );
  });

  group(
    'activeSelectionMenu',
    () {
      test(
        'initially is null',
        () => expect(controller.activeSelectionMenu, isNull),
      );

      test(
        'is set to the correct selection menu when the pattern is matched',
        () {
          controller.text = 'p:';
          expect(controller.activeSelectionMenu, isA<Projects>());
        },
      );

      test(
        'is set to the correct selection menu when the pattern is matched',
        () {
          controller.text = 'l:';
          expect(controller.activeSelectionMenu, isA<Labels>());
        },
      );

      test(
        'is set to null once the pattern is not matched anymore',
        () {
          controller.text = 'p:';
          expect(controller.activeSelectionMenu, isA<Projects>());

          controller.text = 'p: ';
          expect(controller.activeSelectionMenu, isNull);

          controller.text = 'p:';
          expect(controller.activeSelectionMenu, isA<Projects>());

          controller.clear();
          expect(controller.activeSelectionMenu, isNull);
        },
      );

      test('is removed when removeActiveSelectionMenu is called', () {
        controller.text = 'p:';
        expect(controller.activeSelectionMenu, isA<Projects>());

        controller.removeActiveSelectionMenu();
        expect(controller.activeSelectionMenu, isNull);
      });

      test('is set to null when there is a whitespace after the pattern', () {
        controller.text = 'p: ';
        expect(controller.activeSelectionMenu, isNull);
      });

      test(
        'should take the last pattern when multiple patterns are present',
        () {
          controller.text = 'foo bar l: baz p:query';
          expect(controller.activeSelectionMenu, isA<Projects>());
        },
      );

      test(
        'along with query having white space',
        () {
          controller
            ..text = 'foo bar p:'
            ..text = 'foo bar p:query hi';

          expect(controller.activeSelectionMenu, isA<Projects>());
        },
      );
    },
  );

  group(
    'selectedValues',
    () {
      test(
        'is empty when the controller is initialized',
        () => expect(controller.selectedValues, isEmpty),
      );

      test('is updated correctly when a value is selected', () {
        final _expectedResult = <String, SelectionItemMetaData>{
          'p:': const SelectionItemMetaData(
            item: Project(name: 'Project1'),
            offset: (start: 0, end: 8),

            /// p:Project1 -> Project1
          ),
        };

        controller
          ..text = 'p:Project1'
          ..selectValue('p:', const Project(name: 'Project1'));

        expect(controller.selectedValues, isNotEmpty);
        expect(controller.selectedValues, equals(_expectedResult));
      });

      test(
        'updates text with the selected value',
        () {
          const _expectedText = 'lorem ipsum Project1';

          final _expectedResult = <String, SelectionItemMetaData>{
            'p:': const SelectionItemMetaData(
              item: Project(name: 'Project1'),
              offset: (start: 12, end: 20),
            ),
          };

          controller
            ..text = 'lorem ipsum '
            ..text = 'lorem ipsum p:Project1'
            ..selectValue('p:', const Project(name: 'Project1'));

          expect(controller.selectedValues, isNotEmpty);
          expect(controller.selectedValues['p:'], isNotNull);
          expect(controller.text, equals(_expectedText));
          expect(controller.selectedValues, equals(_expectedResult));
        },
      );

      test(
        'is updated correctly when multiple values are selected',
        () {
          const _expectedText = 'Project1 Label1';
          final _expectedResult = <String, SelectionItemMetaData>{
            'p:': const SelectionItemMetaData(
              item: Project(name: 'Project1'),
              offset: (start: 0, end: 8),
            ),
            'l:': const SelectionItemMetaData(
              item: Label(name: 'Label1'),
              offset: (start: 9, end: 15),
            ),
          };

          controller
            ..text = 'p:Project1'
            ..selectValue('p:', const Project(name: 'Project1')) // Project1
            ..text = 'Project1 l:Label1'
            ..selectValue('l:', const Label(name: 'Label1'));

          expect(controller.selectedValues, isNotEmpty);
          expect(controller.text, equals(_expectedText));
          expect(controller.selectedValues, equals(_expectedResult));
        },
      );

      test(
        'is removed when clearing the text',
        () {
          controller.text = 'foo bar p:Project1';
          controller.selectValue('p:', const Project(name: 'Project1'));

          expect(controller.selectedValues.length, equals(1));
          expect(controller.text, equals('foo bar Project1'));

          controller.selection = TextSelection.fromPosition(TextPosition(offset: 13));
          controller.text = 'foo bar Projec';
          expect(controller.selectedValues, isEmpty);
        },
      );
    },
  );

  group(
    'activePatternOffset',
    () {
      test(
        'initially is (-1, -1)',
        () => expect(controller.activePatternOffset, equals((start: -1, end: -1))),
      );

      test(
        'is set to (0, 2), when text is "p:"',
        () {
          controller.text = 'p:';
          expect(controller.activePatternOffset, equals((start: 0, end: 2)));
        },
      );

      test(
        'is set to (-1, -1) when there is a white space after the pattern',
        () {
          controller.text = 'p: ';
          expect(controller.activePatternOffset, equals((start: -1, end: -1)));
        },
      );

      test(
        'is set to correct offset when the pattern is in the middle of the text',
        () {
          controller.text = 'foo bar baz p:query';
          expect(controller.activePatternOffset, equals((start: 12, end: 14)));
        },
      );

      test(
        'is set to correct offset when pattern is at the end',
        () {
          controller.text = 'foo bar baz p:';
          expect(controller.activePatternOffset, equals((start: 12, end: 14)));
        },
      );
    },
  );

  group(
    'query',
    () {
      test(
        'is empty when the controller is initialized',
        () => expect(controller.query, isEmpty),
      );

      test(
        'is updated correctly when the pattern is matched',
        () {
          controller.text = 'p:Project1';
          expect(controller.query, equals('Project1'));
        },
      );

      test(
        'is updated correctly when the pattern is not matched',
        () {
          controller.text = 'x:Project1';
          expect(controller.query, isEmpty);
        },
      );

      test(
        'is updated correctly when the text is cleared',
        () {
          controller
            ..text = 'p:Project1'
            ..clear();
          expect(controller.query, isEmpty);
        },
      );

      test(
        'is empty when the text is "p: "',
        () {
          controller.text = 'p: ';
          expect(controller.query, isEmpty);
        },
      );

      test(
        'should match the latest pattern and ignore the prior ones',
        () {
          controller.text = 'foo bar p: baz p:query';
          expect(controller.query, equals('query'));
        },
      );

      test(
        'should match the latest pattern and ignore the prior ones',
        () {
          controller.text = 'foo bar p:abc baz p:query';
          expect(controller.query, equals('query'));
        },
      );

      test(
        'should handle single spaces between words in query',
        () {
          controller
            ..text = 'p:'
            ..text = 'p:query hi';

          expect(controller.query, equals('query hi'));
        },
      );

      test(
        'should remove the activeSelectionMenu on two space',
        () {
          controller
            ..text = 'p: '
            ..text = 'p:query hi  ';

          expect(controller.activeSelectionMenu, isNull);
          expect(controller.query, isEmpty);
        },
      );
    },
  );

  group(
    'activeOptions',
    () {
      test(
        'is empty when the controller is initialized',
        () => expect(controller.activeOptions, isEmpty),
      );

      test(
        'is updated correctly when the pattern is matched and query is present',
        () {
          controller
            ..text = 'p:'
            ..text = 'p:Project 1';
          expect(controller.activeOptions, isNotEmpty);
          expect(controller.query, 'Project 1');
        },
      );

      test(
        'is empty when the pattern is not matched',
        () {
          controller.text = 'x:Project1';
          expect(controller.activeOptions, isEmpty);
        },
      );

      test(
        'contains correct items when the pattern is matched and query is present',
        () {
          controller
            ..text = 'p:'
            ..text = 'p:Project 1';

          expect(controller.activeOptions, isNotEmpty);
          expect(controller.activeOptions[0].queryContent, equals('Project 1'));
        },
      );

      test(
        'contains correct items when multiple items match the query',
        () {
          controller.text = 'p:Project';
          expect(controller.activeOptions, isNotEmpty);
          expect(controller.activeOptions.length, equals(10));
        },
      );

      test(
        'does not contain items that do not match the query',
        () {
          controller.text = 'p:NonExistentProject';
          expect(controller.activeOptions, isEmpty);
        },
      );

      test(
        'is updated correctly when the text is cleared',
        () {
          controller
            ..text = 'p:Project1'
            ..clear();
          expect(controller.activeOptions, isEmpty);
        },
      );
    },
  );

  group(
    'replace text',
    () {
      test(
        'when an option is selected',
        () {
          controller
            ..text = 'foo bar'
            ..text = 'foo bar p:'
            ..text = 'foo bar p:Proj';

          expect(controller.activeSelectionMenu, isA<Projects>());
          expect(controller.query, equals('Proj'));
          expect(controller.activeOptions, isNotEmpty);
          expect(controller.activeOptions.length, equals(10));

          controller.selectValue('p:', const Project(name: 'Project 5'));

          expect(controller.text, equals('foo bar Project 5'));

          return null;
        },
      );

      test(
        'and same option selection menu should not be available',
        () {
          controller
            ..text = 'foo bar'
            ..text = 'foo bar p:'
            ..text = 'foo bar p:Proj';

          expect(controller.activeSelectionMenu, isA<Projects>());
          expect(controller.query, equals('Proj'));
          expect(controller.activeOptions, isNotEmpty);
          expect(controller.activeOptions.length, equals(10));

          controller.selectValue('p:', const Project(name: 'Project 5'));

          expect(controller.text, equals('foo bar Project 5'));

          controller.text = 'foo bar p:';
          expect(controller.activeSelectionMenu, isNull);
        },
      );
    },
  );

  group(
    'isCursorAtEnd',
    () {
      test('returns true when the cursor is at the end of the text', () {
        controller.text = 'Hello, World!';
        controller.selection =
            TextSelection.fromPosition(TextPosition(offset: controller.text.length));

        expect(controller.isCursorAtEnd, isTrue);
      });

      test('returns false when the cursor is not at the end of the text', () {
        controller.text = 'Hello, World!';
        controller.selection =
            TextSelection.fromPosition(const TextPosition(offset: 5)); // Cursor is at position 5

        expect(controller.isCursorAtEnd, isFalse);
      });

      test('returns true for an empty text', () {
        controller.text = '';
        controller.selection =
            TextSelection.fromPosition(const TextPosition(offset: 0)); // Cursor is at position 0

        expect(controller.isCursorAtEnd, isTrue);
      });
    },
  );

  group(
    'updateSelectedValues',
    () {
      test(
        'returns true if cursor is before any of the selected menu items',
        () {
          controller.text = 'foo bar p:Project1';
          controller.selectValue('p:', const Project(name: 'Project1'));

          controller.selection = const TextSelection.collapsed(offset: 0);

          expect(controller.updateSelectedValues, isTrue);
          expect(controller.selectedValues, isNotEmpty);
        },
      );

      test(
        'return false if the cursor is at the end of the text',
        () {
          controller.text = 'foo bar p:Project1';
          controller.selectValue('p:', const Project(name: 'Project1'));

          controller.text = 'foo bar Project1 lorem';
          controller.selection =
              TextSelection.fromPosition(TextPosition(offset: controller.text.length));

          expect(controller.updateSelectedValues, isFalse);
          expect(controller.selectedValues, isNotEmpty);
        },
      );

      test(
        'return false if the cursor is after any of the selected menu items',
        () {
          controller.text = 'foo bar p:Project1';
          controller.selectValue('p:', const Project(name: 'Project1'));

          controller.text = 'foo bar Project1 lorem';
          controller.selection = const TextSelection.collapsed(offset: 18);

          expect(controller.updateSelectedValues, isFalse);
          expect(controller.selectedValues, isNotEmpty);
        },
      );

      test(
        'return false when cursor is at the beginning but there are no selected menu items',
        () {
          controller.text = 'foo bar Project1 lorem';
          controller.selection = const TextSelection.collapsed(offset: 0);

          expect(controller.updateSelectedValues, isFalse);
          expect(controller.selectedValues, isEmpty);
        },
      );
    },
  );

  group(
    'convertToTextSpanInfo',
    () {
      test(
        'returns the entire text in a single object when there are not items to be highlighted',
        () {
          final _expectedResult = [
            const TextSpanInfo(
              text: 'foo bar Project1',
              isHighlighted: false,
              offset: (start: 0, end: 17),
            ),
          ];

          controller.text = 'foo bar Project1';
          expect(controller.convertToTextSpanInfo(), equals(_expectedResult));
        },
      );

      test(
        'returns an array with selected project being highlighted',
        () {
          const _expectedResult = [
            TextSpanInfo(
              text: 'foo bar ',
              isHighlighted: false,
              offset: (start: 0, end: 8),
            ),
            TextSpanInfo(
              text: 'Project1',
              isHighlighted: true,
              offset: (start: 8, end: 16),
            ),
          ];

          controller.text = 'foo bar p:Project1';
          controller.selectValue('p:', const Project(name: 'Project1'));

          expect(controller.selectedValues, isNotEmpty);
          expect(controller.selectedValues['p:']!.item, isA<Project>());
          expect(controller.text, equals('foo bar Project1'));
          expect(controller.convertToTextSpanInfo(), equals(_expectedResult));
        },
      );

      test(
        'with suffix text',
        () {
          controller
            ..text = 'foo bar p:Project1'
            ..selectValue('p:', const Project(name: 'Project1'))
            ..text = 'foo bar Project1 lorem';

          const _expectedText = 'foo bar Project1 lorem';
          const _expectedResult = [
            TextSpanInfo(
              text: 'foo bar ',
              isHighlighted: false,
              offset: (start: 0, end: 8),
            ),
            TextSpanInfo(
              text: 'Project1',
              isHighlighted: true,
              offset: (start: 8, end: 16),
            ),
            TextSpanInfo(
              text: ' lorem',
              isHighlighted: false,
              offset: (start: 16, end: 22),
            ),
          ];

          expect(controller.selectedValues, isNotEmpty);
          expect(controller.text, equals(_expectedText));
          expect(controller.convertToTextSpanInfo(), equals(_expectedResult));
        },
      );

      test(
        'with date and selected menu item',
        () {
          const _expectedText = 'foo bar today Project1';
          const _expectedResult = [
            TextSpanInfo(
              text: 'foo bar ',
              isHighlighted: false,
              offset: (start: 0, end: 8),
            ),
            TextSpanInfo(
              text: 'today',
              isHighlighted: true,
              offset: (start: 8, end: 13),
            ),
            TextSpanInfo(
              text: ' ',
              isHighlighted: false,
              offset: (start: 13, end: 14),
            ),
            TextSpanInfo(
              text: 'Project1',
              isHighlighted: true,
              offset: (start: 14, end: 22),
            ),
          ];

          controller.text = 'foo bar today p:Project1';
          controller.selectValue('p:', const Project(name: 'Project1'));

          expect(controller.selectedValues, isNotEmpty);
          expect(controller.text, equals(_expectedText));
          expect(controller.convertToTextSpanInfo(), isNotEmpty);
          expect(controller.convertToTextSpanInfo(), equals(_expectedResult));
        },
      );

      test(
        'handles multiple values in selectedValues correctly',
        () {
          controller
            ..text = 'foo bar p:Project1'
            ..selectValue('p:', const Project(name: 'Project1'))
            ..text = 'foo bar Project1 lorem l:Label1'
            ..selectValue('l:', const Label(name: 'Label1'))
            ..text = 'foo bar Project1 lorem Label1 qux';

          const _expectedText = 'foo bar Project1 lorem Label1 qux';

          const _expectedResult = [
            TextSpanInfo(
              text: 'foo bar ',
              isHighlighted: false,
              offset: (start: 0, end: 8),
            ),
            TextSpanInfo(
              text: 'Project1',
              isHighlighted: true,
              offset: (start: 8, end: 16),
            ),
            TextSpanInfo(
              text: ' lorem ',
              isHighlighted: false,
              offset: (start: 16, end: 23),
            ),
            TextSpanInfo(
              text: 'Label1',
              isHighlighted: true,
              offset: (start: 23, end: 29),
            ),
            TextSpanInfo(
              text: ' qux',
              isHighlighted: false,
              offset: (start: 29, end: 33),
            ),
          ];

          expect(controller.selectedValues, isNotEmpty);
          expect(controller.text, equals(_expectedText));
          expect(controller.convertToTextSpanInfo(), equals(_expectedResult));
        },
      );
    },
  );

  group(
    'dateTimeValue',
    () {
      test(
        'is null when the controller is initialized',
        () => expect(controller.dateTimeValue, isNull),
      );

      test(
        'is set to a value if a date time pattern is matched',
        () {
          final _now = DateTime.now().withoutTime;

          final _expectedResult = DateTimeData(
            dateTime: _now.add(const Duration(days: 1)),
            value: 'tomorrow',
            offset: (start: 7, end: 15),
          );

          controller.text = 'Do foo tomorrow';

          expect(controller.dateTimeValue, equals(_expectedResult));
        },
      );

      test(
        'with spaces between the date and time',
        () {
          final _expectedResult = DateTimeData(
            dateTime: DateTime(2018, 3, 20, 13),
            value: '20th March 2018 at 13:00',
            offset: (start: 10, end: 34),
          );

          controller.text = 'Do foo on 20th March 2018 at 13:00';

          expect(controller.dateTimeValue, equals(_expectedResult));
        },
      );
    },
  );
}

final _selectionMenu = <SelectionMenu>[
  Projects(
    builder: (context, item) => const SizedBox.shrink(),
    items: List.generate(
      10,
      (index) => Project(name: 'Project $index'),
    ),
  ),
  Labels(
    builder: (context, item) => const SizedBox.shrink(),
    items: List.generate(
      10,
      (index) => Label(name: 'Label $index'),
    ),
  ),
];

@immutable
class Projects extends SelectionMenu<Project> {
  const Projects({
    required super.builder,
    required super.items,
    super.pattern = 'p:',
  });
}

@immutable
class Project implements SelectionMenuItem {
  const Project({
    required this.name,
  });

  final String name;

  @override
  String get queryContent => name;
}

@immutable
class Labels extends SelectionMenu<Label> {
  const Labels({
    required super.builder,
    required super.items,
    super.pattern = 'l:',
  });
}

@immutable
class Label implements SelectionMenuItem {
  const Label({required this.name});

  final String name;

  @override
  String get queryContent => name;
}
