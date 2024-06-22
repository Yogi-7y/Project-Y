import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/context_entity.dart';
import '../repository/context_repository.dart';

class ContextUseCase {
  const ContextUseCase({
    required this.repository,
  });

  final ContextRepository repository;

  AsyncContexts getContexts() async => repository.getContexts();
}

final contextUseCaseProvider = Provider<ContextUseCase>((ref) {
  return ContextUseCase(repository: ref.watch(contextRepositoryProvider));
});
