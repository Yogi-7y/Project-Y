import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/project_entity.dart';
import '../repository/project_repository.dart';

class ProjectUseCase {
  const ProjectUseCase({
    required this.projectRepository,
  });

  final ProjectRepository projectRepository;

  AsyncProjects getProjects() async => projectRepository.getProjects();
}

final projectUseCaseProvider = Provider<ProjectUseCase>((ref) {
  final _projectRepository = ref.watch(projectRepositoryProvider);

  return ProjectUseCase(projectRepository: _projectRepository);
});
