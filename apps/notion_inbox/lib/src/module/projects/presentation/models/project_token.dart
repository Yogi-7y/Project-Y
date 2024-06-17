import 'package:smart_textfield/smart_textfield.dart';

import '../../domain/entity/project_entity.dart';

class ProjectToken extends ProjectEntity implements Tokenable {
  const ProjectToken({required super.id, required super.name});

  @override
  String get prefix => throw UnimplementedError();

  @override
  String get stringValue => throw UnimplementedError();
}
