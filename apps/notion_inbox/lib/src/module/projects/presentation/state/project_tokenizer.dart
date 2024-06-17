import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../domain/entity/project_tokenizer.dart';
import 'projects.dart';

final projectTokenizerProvider = Provider<Tokenizer>((ref) {
  final _projects = ref.watch(projectsProvider).valueOrNull ?? [];

  return ProjectTokenizer(values: _projects);
});
