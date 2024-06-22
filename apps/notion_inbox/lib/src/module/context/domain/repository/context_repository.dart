import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/api_service.dart';
import '../../data/repository/context_repository.dart';
import '../entity/context_entity.dart';

abstract class ContextRepository {
  AsyncContexts getContexts();
}

final contextRepositoryProvider = Provider<ContextRepository>((ref) {
  final _apiService = ref.watch(apiServiceProvider);

  return NotionContextRepository(apiClient: _apiService);
});
