// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../presentation/models/project_token.dart';

typedef Projects = List<ProjectEntity>;
typedef AsyncProjects = Future<Result<Projects>>;

@immutable
class ProjectEntity implements Tokenable {
  const ProjectEntity({
    required this.id,
    required this.name,
  });

  final String id;

  final String name;

  @override
  String get prefix => ProjectTokenizer.prefixId;

  @override
  String get stringValue => name;

  @override
  String toString() => 'ProjectEntity(id: $id, name: $name)';

  @override
  bool operator ==(covariant ProjectEntity other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
