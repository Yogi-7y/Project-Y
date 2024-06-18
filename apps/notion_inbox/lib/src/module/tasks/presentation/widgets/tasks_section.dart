import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/tasks_provider.dart';
import 'task_tile.dart';

@immutable
class TaskSection extends ConsumerWidget {
  const TaskSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tasksProvider).when(
          error: (error, __) => Text('Error: $error'),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (tasks) => ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) => TaskTile(task: tasks[index]),
          ),
        );
  }
}
