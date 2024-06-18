import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/task_entity.dart';
import '../repository/task_repository.dart';

class TaskUseCase {
  const TaskUseCase({required this.repository});
  final TaskRepository repository;

  Future<Result<void>> addTask({required TaskEntity task}) async {
    return repository.addTask(task: task);
  }
}

final taskUseCaseProvider = Provider<TaskUseCase>((ref) {
  final _repository = ref.watch(taskRepositoryProvider);

  return TaskUseCase(repository: _repository);
});
