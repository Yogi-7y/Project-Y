import 'package:flutter/material.dart';
import 'package:smart_textfield/smart_textfield.dart';

import 'module/splash_screen/presentation/splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const SmartTextFieldOverlay(
      child: MaterialApp(
        title: 'Notion Inbox',
        home: SplashScreen(),
      ),
    );
  }
}
