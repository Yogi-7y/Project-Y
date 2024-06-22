import 'package:network/network.dart';

import '../../../../core/env/env.dart';

class NotionContextRequest extends PostRequest {
  static const _contextId = Env.contextDatabaseId;

  // ignore: sort_constructors_first
  const NotionContextRequest({
    super.host = 'api.notion.com',
    super.endpoint = '/v1/databases/$_contextId/query',
  });

  @override
  Map<String, String> get headers => {
        'Authorization': 'Bearer ${Env.notionSecret}',
        'Notion-Version': Env.notionVersion,
      };
}
