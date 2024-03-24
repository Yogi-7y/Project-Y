import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/network.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(apiExecutor: DioApiExecutor()));
