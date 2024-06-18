import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:network/network.dart';

import '../../../../core/env/env.dart';
import '../models/notion_task_entity.dart';

@immutable
class CreateTaskRequest extends PostRequest {
  const CreateTaskRequest({
    required this.task,
    required this.databaseId,
    super.host = 'api.notion.com',
    super.endpoint = '/v1/pages',
  });

  final NotionTaskEntity task;
  final String databaseId;

  @override
  Map<String, String> get headers => {
        'Authorization': 'Bearer ${Env.notionSecret}',
        'Notion-Version': Env.notionVersion,
      };

  @override
  Map<String, Object?> get body => {
        ...super.body,
        ...task.toMap(databaseId),
      };
}

@immutable
class GetInboxTasksRequest extends PostRequest {
  const GetInboxTasksRequest({
    super.host = 'api.notion.com',
    super.endpoint = '/v1/databases/${Env.taskDatabaseId}/query',
  });

  @override
  Map<String, Object?> get body => {
        'filter': {
          'property': 'Inbox',
          'checkbox': {'equals': true},
        }
      };

  @override
  Map<String, String> get headers => {
        'Authorization': 'Bearer ${Env.notionSecret}',
        'Notion-Version': Env.notionVersion,
      };
}
