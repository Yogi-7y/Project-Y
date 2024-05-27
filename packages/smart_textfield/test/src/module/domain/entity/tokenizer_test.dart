import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_textfield/src/module/domain/entity/token.dart';
import 'package:smart_textfield/src/module/domain/entity/tokenizer.dart';

void main() {
  late ProjectTokenizer projectTokenizer;

  setUp(
    () {
      projectTokenizer = ProjectTokenizer(
        values: const [
          Project(name: 'Foo bar'),
          Project(name: 'John Doe'),
          Project(name: 'Jane Doe'),
          Project(name: 'Baz qux'),
        ],
      );
    },
  );

  group(
    'tokenize',
    () {
      test(
        'should extract tokens based on prefix and value',
        () {
          final _result = projectTokenizer.tokenize('foo bar baz qux @John Doe');

          final _expectedResult = [
            Token<Project>(
              prefix: '@',
              rawValue: '@John Doe',
              displayValue: 'John Doe',
              isHighlighted: true,
              value: const Project(name: 'John Doe'),
              offset: const TokenOffset(
                start: 16,
                end: 25,
              ),
            ),
          ];

          expect(_result, _expectedResult);
        },
      );
    },
  );

  group(
    'valuesWithPrefix',
    () {
      test('is populated correctly on initialization ', () {
        final _result = projectTokenizer.valuesWithPrefix.toList();

        const _expectedResult = [
          (prefixValue: '@Foo bar', value: Project(name: 'Foo bar')),
          (prefixValue: '@John Doe', value: Project(name: 'John Doe')),
          (prefixValue: '@Jane Doe', value: Project(name: 'Jane Doe')),
          (prefixValue: '@Baz qux', value: Project(name: 'Baz qux')),
        ];

        expect(_result, _expectedResult);
      });
    },
  );

  group(
    'suggestions',
    () {
      test(
        'is shown based on the matching query',
        () {
          final _result = projectTokenizer.suggestions('foo bar baz qux @J');

          const _expectedResult = [
            Project(name: 'John Doe'),
            Project(name: 'Jane Doe'),
          ];

          expect(_result, _expectedResult);
        },
      );

      test(
        'should perform fuzzy search and return matching suggestions',
        () {
          final _result = projectTokenizer.suggestions('foo bar baz qux @doe');
          const _expectedResult = [
            Project(name: 'John Doe'),
            Project(name: 'Jane Doe'),
          ];
          expect(_result, _expectedResult);
        },
      );
    },
  );
}

@immutable
class ProjectTokenizer extends Tokenizer<Project> {
  ProjectTokenizer({
    required super.values,
    super.prefix = '@',
  });
}

@immutable
// ignore: avoid_implementing_value_types
class Project implements Tokenable {
  const Project({
    required this.name,
  });

  final String name;

  @override
  String get stringValue => name;

  @override
  String toString() => 'Project(name: $name)';

  @override
  bool operator ==(covariant Project other) {
    if (identical(this, other)) return true;

    return other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String get prefix => '@';
}
