import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../projects/domain/entity/project_tokenizer.dart';
import '../../../projects/presentation/state/projects.dart';

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
    });
  }

  Future<void> _fetchProjects() async {
    final _projects = await ref.read(projectsProvider.future);

    final _tokenizer = ProjectTokenizer(values: _projects);

    _smartTextFieldController.addTokenizer(_tokenizer);
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
            children: [
              Container(
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
                    Icon(
                      Icons.watch_later_rounded,
                      size: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tomorrow',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
