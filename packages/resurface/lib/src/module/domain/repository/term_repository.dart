import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:resurface/resurface.dart';
import 'package:resurface/src/module/data/repository/term_repository.dart';
import 'package:resurface/src/module/domain/entity/term.dart';

typedef AsyncTerms = AsyncResult<List<Term>>;

@immutable
abstract class TermRepository {
  AsyncTerms fetchTerms();

  AsyncResult<void> addTerm(Term term);
}

final termRepositoryProvider = Provider<TermRepository>(
  (ref) {
    try {
      final _apiClient = ref.read(dependenciesProvider).apiClient;

      return TermRepositoryImpl(_apiClient);
    } catch (e) {
      rethrow;
    }
  },
  dependencies: [dependenciesProvider],
);
