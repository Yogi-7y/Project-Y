import 'package:flutter/material.dart';
import 'package:smart_textfield/smart_textfield.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SmartTextFieldOverlay(
      child: MaterialApp(
        title: 'Material App',
        home: Builder(builder: (context) => const SmartTextFieldScreen()),
      ),
    );
  }
}

class SmartTextFieldScreen extends StatefulWidget {
  const SmartTextFieldScreen({
    super.key,
  });

  @override
  State<SmartTextFieldScreen> createState() => _SmartTextFieldScreenState();
}

class _SmartTextFieldScreenState extends State<SmartTextFieldScreen> {
  late final _controller = SmartTextFieldController(
    tokenizers: [
      ProjectTokenizer(values: _projects),
      LabelTokenizer(values: _labels),
    ],
  );

  // ignore: type_annotate_public_apis
  var dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.dateTime != null) {
        setState(() {
          dateTime = _controller.dateTime!;
        });
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart TextField'),
      ),
      body: Center(
        child: Text(
          showFormattedDateTime(dateTime),
          style: const TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SmartTextField(
                  controller: _controller,
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String showFormattedDateTime(DateTime dateTime) =>
      '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
}

@immutable
class ProjectTokenizer extends Tokenizer<Project> {
  ProjectTokenizer({
    required super.values,
    super.prefix = '@',
  });
}

@immutable
// ignore: avoid_implementing_value_types
class Project implements Tokenable {
  const Project({
    required this.name,
  });

  final String name;

  @override
  String get stringValue => name;

  @override
  String get prefix => '@';
}

final _projects = [
  const Project(name: 'John Doe'),
  const Project(name: 'Jane Doe'),
  const Project(name: 'Baz qux'),
  const Project(name: 'Foo bar'),
  const Project(name: 'Foo baz'),
  const Project(name: 'Foo qux'),
  const Project(name: 'Foo foo'),
];

@immutable
class LabelTokenizer extends Tokenizer<Label> {
  LabelTokenizer({
    required super.values,
    super.prefix = '#',
  });
}

@immutable
// ignore: avoid_implementing_value_types
class Label implements Tokenable {
  const Label({required this.name});

  final String name;

  @override
  String get stringValue => name;

  @override
  String get prefix => '#';
}

final _labels = [
  const Label(name: 'Label 1'),
  const Label(name: 'Label 2'),
  const Label(name: 'Label 3'),
  const Label(name: 'Label 4'),
];
