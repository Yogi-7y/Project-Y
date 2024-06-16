import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'PROJECT_DATABASE_ID')
  static const String projectDatabaseId = _Env.projectDatabaseId;
}
