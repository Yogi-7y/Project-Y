import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notion_inbox/src/module/projects/data/model/project_model.dart';

void main() {
  test(
    'throw SerializationException if "id" is missing',
    () {
      expect(
        () => ProjectModel.fromMap(const <String, Object?>{}),
        throwsA(
          isA<SerializationException>().having(
            (e) => e.code,
            'code',
            AppExceptionCode.missingKey,
          ),
        ),
      );
    },
  );

  test(
    'throws SerializationException when "plain_text" is missing',
    () {
      expect(
        () => ProjectModel.fromMap(const <String, Object?>{
          'id': 'dummy-id',
        }),
        throwsA(
          isA<SerializationException>().having(
            (e) => e.code,
            'code',
            AppExceptionCode.missingKey,
          ),
        ),
      );
    },
  );

  test(
    'serializes to object when data is correct',
    () {
      final _result = ProjectModel.fromMap(_notionPayloadExample);

      expect(_result.id, 'dummy-id');
      expect(_result.name, 'Project Name');
    },
  );
}

const _notionPayloadExample = {
  'object': 'page',
  'id': 'dummy-id',
  'created_time': '2024-06-16T08:08:00.000Z',
  'last_edited_time': '2024-06-16T08:29:00.000Z',
  'created_by': {'object': 'user', 'id': 'dummy-user-id'},
  'last_edited_by': {'object': 'user', 'id': 'dummy-user-id'},
  'cover': null,
  'icon': {
    'type': 'external',
    'external': {'url': 'https://www.notion.so/icons/hammer_blue.svg'}
  },
  'parent': {'type': 'database_id', 'database_id': 'dummy-database-id'},
  'archived': false,
  'in_trash': false,
  'properties': {
    'Name': {
      'id': 'dummy-property-id',
      'type': 'title',
      'title': [
        {
          'type': 'text',
          'text': {'content': 'Project Name', 'link': null},
          'annotations': {
            'bold': false,
            'italic': false,
            'strikethrough': false,
            'underline': false,
            'code': false,
            'color': 'default'
          },
          'plain_text': 'Project Name',
          'href': null
        }
      ]
    }
  },
  'url': 'https://www.notion.so/Notion-Inbox-dummy-id',
  'public_url': null
};
