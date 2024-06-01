import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_textfield/smart_textfield.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SmartTextFieldOverlay(
      child: MaterialApp(
        title: 'Smart TextField',
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
    ],
  );

  DateTime? _extractedDateTime;
  Project? _extractedProject;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_handleTextFieldChanges);
  }

  void _handleTextFieldChanges() {
    _extractedDateTime = _controller.highlightedDateTime;

    final _tokens = _controller.highlightedTokens;

    final _projectToken = _tokens[ProjectTokenizer.prefixId];

    if (_projectToken != null && _projectToken.value is Project?) {
      _extractedProject = _projectToken.value as Project?;
    } else {
      _extractedProject = null;
    }

    Future.delayed(
      Duration.zero,
      () => setState(() {}),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getFormattedDateTime(DateTime dateTime) {
    final formatter = DateFormat("d MMM, yyyy 'at' h:mma");
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart TextField')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SmartTextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              suggestionItemBuilder: (context, suggestion) => ListTile(
                title: Text(suggestion),
              ),
            ),
            const SizedBox(height: 40),
            Text(
                'Extracted DateTime: ${_extractedDateTime != null ? getFormattedDateTime(_extractedDateTime!) : 'None'}'),
            Text(
                'Extracted Project: ${_extractedProject != null ? _extractedProject!.name : 'None'}')
          ],
        ),
      ),
    );
  }
}

@immutable
// ignore: avoid_implementing_value_types
class Project implements Tokenable {
  const Project({required this.name});

  final String name;

  @override
  String get prefix => ProjectTokenizer.prefixId;

  @override
  String get stringValue => name;
}

class ProjectTokenizer extends Tokenizer<Project> {
  ProjectTokenizer({
    required super.values,
    super.prefix = prefixId,
  });

  static const prefixId = '@';
}

const _projects = <Project>[
  Project(name: 'Run a marathon'),
  Project(name: 'Learn to code'),
  Project(name: 'Write a book'),
  Project(name: 'House renovation'),
  Project(name: 'Travel to Japan'),
  Project(name: 'Learn to play the guitar'),
];
