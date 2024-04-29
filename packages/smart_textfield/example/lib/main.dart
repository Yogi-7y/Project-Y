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
          return Scaffold(
              appBar: AppBar(
                title: const Text('Material App Bar'),
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
                        padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20)
                            .copyWith(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        ),
                        child: const SmartTextField(
                          // selectionMenus: _selectionMenus,
                          tokenizers: [],
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              ));
        }),
      ),
    );
  }
}
