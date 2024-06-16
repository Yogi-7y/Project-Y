import 'package:flutter/material.dart';

import 'module/tasks/presentation/screens/tasks_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Notion Inbox',
      home: TasksScreen(),
    );
  }
}
