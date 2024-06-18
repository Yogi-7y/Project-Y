import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/api_service.dart';
import '../../data/repository/notion_task_repository.dart';
import '../entity/task_entity.dart';

abstract class TaskRepository {
  Future<Result<void>> addTask({required TaskEntity task});
}

final taskRepositoryProvider = Provider<TaskRepository>(
    (ref) => NotionTaskRepository(apiClient: ref.watch(apiServiceProvider)));
