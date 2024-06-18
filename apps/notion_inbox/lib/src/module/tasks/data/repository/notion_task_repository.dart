// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:core/core.dart';
import 'package:network/network.dart';

import '../../../../core/env/env.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/repository/task_repository.dart';
import '../models/notion_task_entity.dart';
import 'notion_requests.dart';

class NotionTaskRepository implements TaskRepository {
  NotionTaskRepository({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<Result<void>> addTask({required TaskEntity task}) async {
    final _notionTask = NotionTaskEntity.fromTask(task);

    final _request = CreateTaskRequest(
      task: _notionTask,
      databaseId: Env.taskDatabaseId,
    );

    final _response = await apiClient<Map<String, Object?>>(_request);

    return _response;
  }

  @override
  Future<Result<List<TaskEntity>>> inboxTasks() async {
    const _request = GetInboxTasksRequest();

    final _response = await apiClient<Map<String, Object?>>(_request);

    return _response.map(
      (data) {
        final _results = List.castFrom<dynamic, Map<String, Object?>>(
          data['results'] as List<dynamic>? ?? [],
        );

        final _tasks = _results.map(NotionTaskEntity.fromMap).toList();

        return _tasks;
      },
    );
  }
}
