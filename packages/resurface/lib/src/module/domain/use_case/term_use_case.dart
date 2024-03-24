import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resurface/src/module/domain/repository/term_repository.dart';

class TermUseCase {
  const TermUseCase(this.termRepository);

  final TermRepository termRepository;

  AsyncTerms fetchTerms() {
    return termRepository.fetchTerms();
  }
}

final termUseCaseProvider = Provider<TermUseCase>(
  (ref) {
    return TermUseCase(ref.read(termRepositoryProvider));
  },
  dependencies: [termRepositoryProvider],
);
