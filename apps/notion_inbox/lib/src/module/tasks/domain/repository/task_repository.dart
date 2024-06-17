import 'package:core/core.dart';

import '../entity/task_entity.dart';

abstract class TaskRepository {
  Future<Result<void>> addTask({required TaskEntity task});
}
