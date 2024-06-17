import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'PROJECT_DATABASE_ID')
  static const String projectDatabaseId = _Env.projectDatabaseId;

  @EnviedField(varName: 'NOTION_SECRET')
  static const String notionSecret = _Env.notionSecret;

  @EnviedField(varName: 'VERSION')
  static const String notionVersion = _Env.notionVersion;
}
