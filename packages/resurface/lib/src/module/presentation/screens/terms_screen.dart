import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resurface/src/core/dependencies.dart';
import 'package:resurface/src/module/presentation/providers/terms_provider.dart';

@immutable
class TermScreen extends ConsumerWidget {
  const TermScreen({
    super.key,
    required this.dependencies,
  });

  final Dependencies dependencies;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final _data = ref.read(dependenciesProvider);
          print('hi');
          print(_data);

          ref.read(termsProvider);
        },
      ),
    );
  }
}

// class _TermScreen extends ConsumerWidget {
//   const _TermScreen();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       body: ref.watch(termsProvider).when(
//             data: (data) => Center(
//               child: Text(
//                 'data',
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//             error: (error, stackTrace) => Center(
//               child: Text(
//                 'Error..',
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//             loading: () => Center(
//               child: Text(
//                 'Loading..',
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//           ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           final _data = ref.read(dependenciesProvider);
//           print('hi');
//           print(_data);
//         },
//       ),
//     );
//   }
// }
