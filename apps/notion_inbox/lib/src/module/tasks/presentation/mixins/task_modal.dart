import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../../widgets/async_button.dart';
import '../../../context/domain/entity/context_entity.dart';
import '../../../context/domain/entity/context_tokenizer.dart';
import '../../../context/presentation/state/context_state_provider.dart';
import '../../../projects/domain/entity/project_entity.dart';
import '../../../projects/domain/entity/project_tokenizer.dart';
import '../../../projects/presentation/state/projects.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/use_case/task_use_case.dart';
import '../state/task_form_provider.dart';
import '../state/tasks_provider.dart';

mixin TaskModals {
  Future<void> addTaskBottomSheet({
    required BuildContext context,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
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
      unawaited(_fetchContext());
      _smartTextFieldController.addListener(_fetchDataFromTextField);
    });
  }

  Future<void> _fetchProjects() async {
    final _projects = await ref.read(projectsProvider.future);

    final _tokenizer = ProjectTokenizer(values: _projects);

    _smartTextFieldController.addTokenizer(_tokenizer);
  }

  Future<void> _fetchContext() async {
    final _context = await ref.read(contextStateProvider.future);

    final _tokenizer = ContextTokenizer(values: _context);

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
          Wrap(
            runSpacing: 8,
            spacing: 8,
            children: ref.watch(extractedTokenChipsProvider),
          ),
          const SizedBox(height: 20),
          AsyncButton(
            onPressed: () async {
              final _dueDate = ref.read(dueDateTaskFormProvider);
              final _project = ref.read(projectTaskFormProvider);
              final _context = ref.read(contextTaskFormProvider);

              final task = TaskEntity(
                name: _smartTextFieldController.text,
                dueDate: _dueDate,
                project: _project,
                context: _context,
              );

              final _result = await ref.read(taskUseCaseProvider).addTask(task: task);

              _result.when(
                success: (value) {
                  final _scaffoldMessenger = ScaffoldMessenger.of(context);
                  ref.invalidate(tasksProvider);

                  Navigator.of(context).pop();

                  _scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Task created!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                failure: (message, error, stackTrace) {
                  final _scaffoldMessenger = ScaffoldMessenger.of(context);
                  Navigator.of(context).pop();

                  _scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Error: $message'),
                    ),
                  );
                },
              );
            },
            text: 'Create',
            endToEndWidth: true,
          ),
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
      margin: const EdgeInsets.only(top: 12),
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
