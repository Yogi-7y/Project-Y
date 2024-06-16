// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:core/core.dart';
import 'package:flutter/material.dart';

typedef Projects = List<ProjectEntity>;
typedef AsyncProjects = Future<Result<Projects>>;

@immutable
class ProjectEntity {
  const ProjectEntity({
    required this.id,
    required this.name,
  });

  final String id;

  final String name;
}
