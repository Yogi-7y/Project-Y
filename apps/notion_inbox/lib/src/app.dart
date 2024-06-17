import 'package:flutter/material.dart';

import 'module/splash_screen/presentation/splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Notion Inbox',
      home: SplashScreen(),
    );
  }
}
