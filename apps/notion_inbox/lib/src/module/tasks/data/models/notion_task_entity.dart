import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/task_entity.dart';

@immutable
class NotionTaskEntity extends TaskEntity {
  const NotionTaskEntity({
    required super.name,
    super.project,
    super.context,
    super.dueDate,
    super.id,
  });

  factory NotionTaskEntity.fromMap(Map<String, Object?> map) {
    final _id = map['id'] as String? ?? '';

    if (_id.isEmpty) {
      throw SerializationException(
        code: AppExceptionCode.missingKey,
        consoleMessage: 'Key: id not found in source: $map',
      );
    }

    final _properties = map['properties'] as Map<String, Object?>? ?? {};
    final _name = _properties['Name'] as Map<String, Object?>? ?? {};
    final _title = _name['title'] as List<Object?>? ?? [];

    if (_title.isEmpty) {
      throw SerializationException(
        code: AppExceptionCode.missingKey,
        consoleMessage: 'Key: title not found in source: $map',
      );
    }

    final _firstElement = _title.first as Map<String, Object?>? ?? {};
    final _plainText = _firstElement['plain_text'] as String? ?? '';

    if (_plainText.isEmpty) {
      throw SerializationException(
        code: AppExceptionCode.missingKey,
        consoleMessage: 'Key: plain_text not found in source: $map',
      );
    }

    return NotionTaskEntity(
      name: _plainText,
    );
  }

  factory NotionTaskEntity.fromTask(TaskEntity task) => NotionTaskEntity(
        name: task.name,
        project: task.project,
        context: task.context,
        dueDate: task.dueDate,
        id: task.id,
      );

  Map<String, Object?> toMap(String databaseId) {
    if (databaseId.isEmpty) throw ArgumentError('databaseId cannot be empty');

    final _name = {
      'Name': {
        'title': [
          {
            'text': {'content': name}
          }
        ]
      }
    };

    final _dueDate = {
      'Due Date': {
        'date': {
          'start': dueDate?.toIso8601String().split('T').first,
        }
      }
    };

    final _project = {
      'Project': {
        'relation': [
          {'id': project?.id}
        ]
      }
    };

    final _context = {
      'Context': {
        'relation': [
          {'id': context?.id}
        ]
      }
    };

    return <String, Object?>{
      if (databaseId.isNotEmpty)
        'parent': <String, Object?>{
          'database_id': databaseId,
        },
      'properties': {
        if (name.isNotEmpty) ..._name,
        if (dueDate != null) ..._dueDate,
        if (project != null) ..._project,
        if (context != null) ..._context,
      }
    };
  }
}
