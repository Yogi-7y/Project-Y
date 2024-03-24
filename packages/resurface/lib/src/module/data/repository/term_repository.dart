import 'package:core/src/types/result.dart';
import 'package:network/network.dart';
import 'package:resurface/src/module/data/models/term_model.dart';
import 'package:resurface/src/module/data/repository/term_request.dart';
import 'package:resurface/src/module/domain/entity/term.dart';
import 'package:resurface/src/module/domain/repository/term_repository.dart';

class TermRepositoryImpl implements TermRepository {
  TermRepositoryImpl(this.apiClient);
  final ApiClient apiClient;

  @override
  AsyncResult<void> addTerm(Term term) {
    throw UnimplementedError();
  }

  @override
  AsyncTerms fetchTerms() async {
    final request = FetchTermsRequest();

    final _response = await apiClient.call<Map<String, Object?>>(request);

    return _response.map(
      (value) {
        final _results = value['results'] as List<Map<String, Object?>>? ?? [];

        return _results.map((e) => NotionTermDto.fromMap(e)).toList();
      },
    );
  }
}
