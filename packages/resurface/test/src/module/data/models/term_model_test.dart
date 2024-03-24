import 'package:flutter_test/flutter_test.dart';
import 'package:resurface/src/module/data/models/term_model.dart';
import 'package:resurface/src/module/domain/entity/term.dart';

void main() {
  test('serialize term', () {
    const _expectedResult = NotionTermDto(
      definition: 'Dummy content (definition)',
      term: 'Dummy content (Term)',
      score: 0,
    );

    final _result = NotionTermDto.fromMap(_dummyNotionData);

    expect(_result, _expectedResult);
  });
}

const _dummyNotionData = {
  "object": "dummy_object",
  "id": "dummy_id",
  "created_time": "2000-01-01T00:00:00.000Z",
  "last_edited_time": "2000-01-01T00:00:00.000Z",
  "created_by": {"object": "dummy_object", "id": "dummy_id"},
  "last_edited_by": {"object": "dummy_object", "id": "dummy_id"},
  "cover": null,
  "icon": {
    "type": "dummy_type",
    "external": {"url": "https://dummy.url/dummy_icon.svg"}
  },
  "parent": {"type": "dummy_type", "database_id": "dummy_id"},
  "archived": false,
  "properties": {
    "Last edited time": {
      "id": "dummy_id",
      "type": "dummy_type",
      "last_edited_time": "2000-01-01T00:00:00.000Z"
    },
    "Definition": {
      "id": "dummy_id",
      "type": "dummy_type",
      "rich_text": [
        {
          "type": "dummy_type",
          "text": {"content": "Dummy content (definition)", "link": null},
          "annotations": {
            "bold": false,
            "italic": false,
            "strikethrough": false,
            "underline": false,
            "code": false,
            "color": "default"
          },
          "plain_text": "Dummy plain text",
          "href": null
        }
      ]
    },
    "Score": {"id": "dummy_id", "type": "dummy_type", "number": 0},
    "Term": {
      "id": "dummy_id",
      "type": "dummy_type",
      "title": [
        {
          "type": "dummy_type",
          "text": {"content": "Dummy content (Term)", "link": null},
          "annotations": {
            "bold": false,
            "italic": false,
            "strikethrough": false,
            "underline": false,
            "code": false,
            "color": "default"
          }
        }
      ]
    }
  }
};
