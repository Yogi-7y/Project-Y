import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/api_service.dart';
import '../../data/repository/project_repository.dart';
import '../entity/project_entity.dart';

abstract class ProjectRepository {
  AsyncProjects getProjects();
}

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final _apiService = ref.watch(apiServiceProvider);

  print(_apiService);

  return ProjectRepositoryImpl(apiClient: _apiService);
});
