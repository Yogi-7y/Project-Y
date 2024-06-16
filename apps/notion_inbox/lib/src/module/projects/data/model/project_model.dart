import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/project_entity.dart';

@immutable
class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
  });

  factory ProjectModel.fromMap(Map<String, Object?> map) {
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

    return ProjectModel(
      id: _id,
      name: _plainText,
    );
  }
}
