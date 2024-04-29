import 'package:network/network.dart';
// import 'package:resurface/src/core/secret.dart';

class FetchTermsRequest extends PostRequest {
  FetchTermsRequest({
    super.host = 'api.notion.com',
    // super.endpoint = '/v1/databases${resurfaceDatabaseId}query',
    super.endpoint = '',
  });
}
