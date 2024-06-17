import 'package:smart_textfield/smart_textfield.dart';

import 'project_entity.dart';

class ProjectTokenizer extends Tokenizer<ProjectEntity> {
  ProjectTokenizer({
    required super.values,
    super.prefix = ProjectTokenizer.prefixId,
  });
  static const prefixId = '@';
}
