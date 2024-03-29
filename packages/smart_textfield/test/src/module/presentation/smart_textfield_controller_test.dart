// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_textfield/smart_textfield.dart';
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
            offset: (start: 0, end: 10),
          ),
        };

        controller
          ..text = 'p:Project1'
          ..selectValue('p:', const Project(name: 'Project1'));

        expect(controller.selectedValues, isNotEmpty);
        expect(controller.selectedValues, equals(_expectedResult));
      });

      test(
        'is updated correctly when multiple values are selected',
        () {
          final _expectedResult = <String, SelectionItemMetaData>{
            'p:': const SelectionItemMetaData(
              item: Project(name: 'Project1'),
              offset: (start: 0, end: 10),
            ),
            'l:': const SelectionItemMetaData(
              item: Label(name: 'Label1'),
              offset: (start: 11, end: 19),
            ),
          };

          controller
            ..text = 'p:Project1'
            ..selectValue('p:', const Project(name: 'Project1'))
            ..text = 'p:Project1 l:Label1'
            ..selectValue('l:', const Label(name: 'Label1'));

          expect(controller.selectedValues, isNotEmpty);
          expect(controller.selectedValues, equals(_expectedResult));
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
