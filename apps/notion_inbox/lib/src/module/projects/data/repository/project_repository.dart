import 'package:network/network.dart';

import '../../domain/entity/project_entity.dart';
import '../../domain/repository/project_repository.dart';
import '../model/project_model.dart';
import 'project_request.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  const ProjectRepositoryImpl({
    required this.apiClient,
  });

  final ApiClient apiClient;

  @override
  AsyncProjects getProjects() async {
    final _response = await apiClient<Map<String, Object?>>(const ProjectRequest());

    return _response.map(
      (data) {
        final _result = List.castFrom<dynamic, Map<String, Object?>>(
          data['results'] as List<dynamic>? ?? [],
        );

        final _projects = _result.map(ProjectModel.fromMap).toList();

        return _projects;
      },
    );
  }
}
