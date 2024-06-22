import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'NOTION_SECRET')
  static const String notionSecret = _Env.notionSecret;

  @EnviedField(varName: 'VERSION')
  static const String notionVersion = _Env.notionVersion;

  @EnviedField(varName: 'PROJECT_DATABASE_ID')
  static const String projectDatabaseId = _Env.projectDatabaseId;

  @EnviedField(varName: 'TASK_DATABASE_ID')
  static const String taskDatabaseId = _Env.taskDatabaseId;

  @EnviedField(varName: 'CONTEXT_DATABASE_ID')
  static const String contextDatabaseId = _Env.contextDatabaseId;
}
