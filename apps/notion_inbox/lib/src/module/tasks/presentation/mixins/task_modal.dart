import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../projects/presentation/models/project_token.dart';
import '../../../projects/presentation/state/projects.dart';

mixin TaskModals {
  Future<void> addTaskBottomSheet({
    required BuildContext context,
  }) {
    return showModalBottomSheet<void>(
      context: context,
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
  late final SmartTextFieldController _smartTextFieldController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _smartTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SmartTextField(controller: _smartTextFieldController),
        ],
      ),
    );
  }
}
