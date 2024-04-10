import 'dart:async';

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
        theme: ThemeData.dark(
          useMaterial3: true,
        ).copyWith(
          scaffoldBackgroundColor: const Color(0xff0f0e0e),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: maroonColor,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        ),
                        child: SmartTextField(
                          selectionMenus: _selectionMenus,
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

const primaryColor = Color(0xff0f0e0e);
const maroonColor = Color(0xff541212);
const greenColor = Color(0xff8b9a46);
const grey = Color(0xffeeeeee);

final _selectionMenus = [
  Projects(
    builder: (context, item) => ListTile(
      title: Text(item.projectName),
    ),
    items: const [
      Project(projectName: 'Lorem Ipsum'),
      Project(projectName: 'Dolor Sit'),
      Project(projectName: 'Amet Consectetur'),
      Project(projectName: 'Adipiscing Elit'),
    ],
  ),
];

@immutable
class Projects extends SelectionMenu<Project> {
  const Projects({
    required super.builder,
    required super.items,
    super.pattern = '@',
  });
}

@immutable
// ignore: avoid_implementing_value_types
class Project implements SelectionMenuItem {
  const Project({
    required this.projectName,
  });

  final String projectName;

  @override
  String get queryContent => projectName;
}
