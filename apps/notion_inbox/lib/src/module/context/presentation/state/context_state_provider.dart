import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/context_entity.dart';
import '../../domain/use_case/context_use_case.dart';

final contextStateProvider = FutureProvider<Contexts>((ref) async {
  final _useCase = ref.watch(contextUseCaseProvider);

  final _result = await _useCase.getContexts();

  return _result.valueOrNull ?? [];
});
