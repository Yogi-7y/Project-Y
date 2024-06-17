import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task_entity.dart';

/// Task that is to be added
final taskFormProvider = StateProvider<TaskEntity?>((ref) => null);
