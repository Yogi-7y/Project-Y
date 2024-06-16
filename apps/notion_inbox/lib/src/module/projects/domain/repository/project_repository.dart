import '../entity/project_entity.dart';

abstract class ProjectRepository {
  AsyncProjects getProjects();
}
