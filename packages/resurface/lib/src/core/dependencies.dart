import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/network.dart';
import 'package:resurface/resurface.dart';

@immutable
class Dependencies {
  const Dependencies({
    required this.apiClient,
  });

  final ApiClient apiClient;
}

final dependenciesProvider = Provider<Dependencies>((ref) {
  throw UnimplementedError('You must provide a Dependencies instance.');
});

mixin TermsModule {
  Future<void> openTermsModule({
    required BuildContext context,
    required Dependencies dependencies,
  }) async {
    final _router = MaterialPageRoute(
      builder: (context) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        overrides: [dependenciesProvider.overrideWithValue(dependencies)],
        child: TermScreen(dependencies: dependencies),
      ),
    );

    Navigator.of(context).push(_router);
  }
}
