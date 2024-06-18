// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter_test/flutter_test.dart';
import 'package:notion_inbox/src/module/context/domain/entity/context_entity.dart';
import 'package:notion_inbox/src/module/projects/domain/entity/project_entity.dart';
import 'package:notion_inbox/src/module/tasks/data/models/notion_task_entity.dart';

const _databaseId = 'dummy-database-id';

void main() {
  test(
    'throw Argument error if databaseId is empty',
    () {
      final _result = () => const NotionTaskEntity(name: 'foo bar').toMap('');

      expect(_result, throwsA(isA<ArgumentError>()));
    },
  );

  test('expected map when only name is passed in', () {
    const _expectedResult = <String, Object?>{
      'parent': {
        'database_id': 'dummy-database-id',
      },
      'properties': {
        'Name': {
          'title': [
            {
              'text': {
                'content': 'foo bar',
              }
            }
          ]
        }
      }
    };

    final _result = const NotionTaskEntity(name: 'foo bar').toMap(_databaseId);

    expect(_result, _expectedResult);
  });

  test(
    'expected map when due date is not empty',
    () {
      const _expectedResult = <String, Object?>{
        'parent': {
          'database_id': 'dummy-database-id',
        },
        'properties': {
          'Name': {
            'title': [
              {
                'text': {
                  'content': 'foo bar',
                }
              }
            ]
          },
          'Due Date': {
            'date': {
              'start': '2021-10-10',
            }
          }
        }
      };

      final _result = NotionTaskEntity(
        name: 'foo bar',
        dueDate: DateTime(2021, 10, 10),
      ).toMap(_databaseId);

      expect(_result, _expectedResult);
    },
  );

  test(
    'expected map when project is not empty',
    () {
      const _projectId = 'dummy-project-id';

      const _expectedResult = <String, Object?>{
        'parent': {
          'database_id': 'dummy-database-id',
        },
        'properties': {
          'Name': {
            'title': [
              {
                'text': {
                  'content': 'foo bar',
                }
              }
            ]
          },
          'Project': {
            'relation': [
              {
                'id': _projectId,
              }
            ]
          }
        }
      };

      final _result = const NotionTaskEntity(
        name: 'foo bar',
        project: ProjectEntity(name: 'Project Name', id: _projectId),
      ).toMap(_databaseId);

      expect(_result, _expectedResult);
    },
  );

  test('expected map when context is not null', () {
    const _contextId = 'dummy-context-id';

    const _expectedResult = <String, Object?>{
      'parent': {
        'database_id': 'dummy-database-id',
      },
      'properties': {
        'Name': {
          'title': [
            {
              'text': {
                'content': 'foo bar',
              }
            }
          ]
        },
        'Context': {
          'relation': [
            {
              'id': _contextId,
            }
          ]
        }
      }
    };

    final _result = const NotionTaskEntity(
      name: 'foo bar',
      context: ContextEntity(id: _contextId, name: 'foo bar'),
    ).toMap(_databaseId);

    expect(_result, _expectedResult);
  });

  test('expected map when all fields are passed in', () {
    const _projectId = 'dummy-project-id';
    const _contextId = 'dummy-context-id';

    const _expectedResult = <String, Object?>{
      'parent': {
        'database_id': 'dummy-database-id',
      },
      'properties': {
        'Name': {
          'title': [
            {
              'text': {
                'content': 'foo bar',
              }
            }
          ]
        },
        'Due Date': {
          'date': {
            'start': '2021-10-10',
          }
        },
        'Project': {
          'relation': [
            {
              'id': _projectId,
            }
          ]
        },
        'Context': {
          'relation': [
            {
              'id': _contextId,
            }
          ]
        }
      }
    };

    final _result = NotionTaskEntity(
      name: 'foo bar',
      dueDate: DateTime(2021, 10, 10),
      project: const ProjectEntity(name: 'Project Name', id: _projectId),
      context: const ContextEntity(id: _contextId, name: 'foo bar'),
    ).toMap(_databaseId);

    expect(_result, _expectedResult);
  });
}
