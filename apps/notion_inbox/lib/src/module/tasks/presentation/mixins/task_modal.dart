import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../context/domain/entity/context_entity.dart';
import '../../../context/domain/entity/context_tokenizer.dart';
import '../../../projects/domain/entity/project_entity.dart';
import '../../../projects/domain/entity/project_tokenizer.dart';
import '../../../projects/presentation/state/projects.dart';
import '../../domain/entity/task_entity.dart';
import '../state/task_form_provider.dart';

mixin TaskModals {
  Future<void> addTaskBottomSheet({
    required BuildContext context,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      builder: (context) => const AddTaskWidget(),
    );
  }
}

class AddTaskWidget extends ConsumerStatefulWidget {
  const AddTaskWidget({
    super.key,
  });

  @override
  ConsumerState<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends ConsumerState<AddTaskWidget> {
  late final _smartTextFieldController = SmartTextFieldController(tokenizers: []);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      unawaited(_fetchProjects());
      _smartTextFieldController.addListener(_fetchDataFromTextField);
    });
  }

  Future<void> _fetchProjects() async {
    final _projects = await ref.read(projectsProvider.future);

    final _tokenizer = ProjectTokenizer(values: _projects);

    _smartTextFieldController.addTokenizer(_tokenizer);
  }

  void _fetchDataFromTextField() {
    final _extractedDateTime = _smartTextFieldController.highlightedDateTime;
    final _tokens = _smartTextFieldController.highlightedTokens;

    final _project = _tokens[ProjectTokenizer.prefixId]?.value as ProjectEntity?;
    final _context = _tokens[ContextTokenizer.prefixId]?.value as ContextEntity?;

    ref.read(dueDateTaskFormProvider.notifier).update((state) => _extractedDateTime);
    ref.read(projectTaskFormProvider.notifier).update((state) => _project);
    ref.read(contextTaskFormProvider.notifier).update((state) => _context);
  }

  @override
  void dispose() {
    _smartTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(.5),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(20) +
          EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SmartTextField(
            controller: _smartTextFieldController,
            decoration: InputDecoration(
              hintText: "What's the task?",
              border: _border,
              enabledBorder: _border,
              focusedBorder: _border,
            ),
            suggestionItemBuilder: (context, suggestion) => ListTile(
              dense: true,
              title: Text(
                suggestion,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            children: ref.watch(extractedTokenChipsProvider),
          )
        ],
      ),
    );
  }
}

class TokenValueChip extends StatelessWidget {
  const TokenValueChip({
    required this.prefix,
    required this.value,
    required this.onClose,
    super.key,
  });

  final String value;
  final String prefix;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(.7),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(
          //   Icons.watch_later_rounded,
          //   size: 14,
          //   color: Theme.of(context).colorScheme.primary,
          // ),
          Text(
            prefix,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}
