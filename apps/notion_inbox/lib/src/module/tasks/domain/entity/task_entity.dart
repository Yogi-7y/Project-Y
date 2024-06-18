// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../context/domain/entity/context_entity.dart';
import '../../../projects/domain/entity/project_entity.dart';

@immutable
class TaskEntity {
  const TaskEntity({
    required this.name,
    required this.project,
    required this.context,
    this.id,
    this.dueDate,
  });

  final String? id;
  final String name;
  final ProjectEntity project;
  final ContextEntity context;
  final DateTime? dueDate;

  TaskEntity copyWith({
    String? id,
    String? name,
    ProjectEntity? project,
    ContextEntity? context,
    DateTime? dueDate,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      project: project ?? this.project,
      context: context ?? this.context,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  String toString() {
    return 'TaskEntity(id: $id, name: $name, project: $project, context: $context, dueDate: $dueDate)';
  }

  @override
  bool operator ==(covariant TaskEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.project == project &&
        other.context == context &&
        other.dueDate == dueDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ project.hashCode ^ context.hashCode ^ dueDate.hashCode;
  }
}
