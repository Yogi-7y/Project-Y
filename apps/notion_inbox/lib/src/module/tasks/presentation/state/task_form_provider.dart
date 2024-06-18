import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../context/domain/entity/context_entity.dart';
import '../../../projects/domain/entity/project_entity.dart';
import '../mixins/task_modal.dart';

final dueDateTaskFormProvider = StateProvider<DateTime?>((ref) => null);

final projectTaskFormProvider = StateProvider<ProjectEntity?>((ref) => null);

final contextTaskFormProvider = StateProvider<ContextEntity?>((ref) => null);

final extractedTokenChipsProvider = Provider<List<TokenValueChip>>((ref) {
  final _dueDate = ref.watch(dueDateTaskFormProvider);
  final _project = ref.watch(projectTaskFormProvider);
  final _context = ref.watch(contextTaskFormProvider);

  final _chips = <TokenValueChip>[];

  if (_dueDate != null) {
    _chips.add(TokenValueChip(
      prefix: '',
      value: _dueDate.toString(),
      onClose: () => ref.read(dueDateTaskFormProvider.notifier).update((state) => null),
    ));
  }

  if (_project != null) {
    _chips.add(TokenValueChip(
      prefix: _project.prefix,
      value: _project.stringValue,
      onClose: () => ref.read(projectTaskFormProvider.notifier).update((state) => null),
    ));
  }

  if (_context != null) {
    _chips.add(
      TokenValueChip(
        prefix: _context.prefix,
        value: _context.stringValue,
        onClose: () => ref.read(contextTaskFormProvider.notifier).update((state) => null),
      ),
    );
  }

  return _chips;
});
