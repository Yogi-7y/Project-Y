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
    return Padding(
      padding: const EdgeInsets.all(20) +
          EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmartTextField(
            controller: _smartTextFieldController,
            decoration: InputDecoration(
              hintText: "What's the task?",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            suggestionItemBuilder: (context, suggestion) => ListTile(
              title: Text(suggestion),
            ),
          ),
        ],
      ),
    );
  }
}
