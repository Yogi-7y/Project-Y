import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/task_entity.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    super.key,
  });

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(task.name),
      trailing: Text(task.dueDate?.toIso8601String().split('T').first ?? ''),
      minLeadingWidth: 10,
      leading: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
