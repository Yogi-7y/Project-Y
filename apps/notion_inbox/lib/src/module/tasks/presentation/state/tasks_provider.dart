import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task_entity.dart';
import '../../domain/use_case/task_use_case.dart';

final tasksProvider = FutureProvider<List<TaskEntity>>((ref) async {
  final _taskUseCase = ref.watch(taskUseCaseProvider);

  final _result = await _taskUseCase.inboxTasks();

  return _result.valueOrNull ?? [];
});
