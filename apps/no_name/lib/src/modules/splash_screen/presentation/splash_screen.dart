import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resurface/resurface.dart';

import '../../../core/api/api_client.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TermsModule {
  @override
  void initState() {
    super.initState();
    unawaited(_asyncInit());
  }

  Future<void> _asyncInit() async {
    await _setUp();

    if (!mounted) return;
    final _apiClient = ref.read(apiClientProvider);

    final _termDependencies = Dependencies(
      apiClient: _apiClient,
    );

    await openTermsModule(
      context: context,
      dependencies: _termDependencies,
    );
  }

  Future<void> _setUp() async {
    await ref.read(apiClientProvider).setup();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
