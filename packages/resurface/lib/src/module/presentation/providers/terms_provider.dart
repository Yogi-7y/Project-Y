import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resurface/src/module/domain/entity/term.dart';
import 'package:resurface/src/module/domain/use_case/term_use_case.dart';

final termsProvider = FutureProvider<List<Term>>(
  (ref) async {
    final _useCase = ref.read(termUseCaseProvider);

    final _result = await _useCase.fetchTerms();

    return _result.when(
      success: (value) => value ?? [],
      failure: (error, _, __) => throw error,
    );
  },
  dependencies: [termUseCaseProvider],
);
