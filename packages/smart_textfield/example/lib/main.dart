import 'package:flutter/foundation.dart';
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
        home: Builder(builder: (context) {
          return const SmartTextFieldScreen();
        }),
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
    tokenizers: [],
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
        title: const Text('Material App Bar'),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                        .copyWith(
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
