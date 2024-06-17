import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/project_entity.dart';
import '../../domain/use_case/project_use_case.dart';

final projectsProvider = FutureProvider<Projects>((ref) async {
  final _useCase = ref.watch(projectUseCaseProvider);

  final _projects = await _useCase.getProjects();

  return _projects.valueOrNull ?? [];
});
