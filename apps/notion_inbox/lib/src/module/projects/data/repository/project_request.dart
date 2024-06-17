import 'package:network/network.dart';

import '../../../../core/env/env.dart';

class ProjectRequest extends PostRequest {
  static const _projectId = Env.projectDatabaseId;

  // ignore: sort_constructors_first
  const ProjectRequest({
    super.host = 'api.notion.com',
    super.endpoint = '/v1/databases/$_projectId/query',
  });

  @override
  Map<String, String> get headers => {
        'Authorization': 'Bearer ${Env.notionSecret}',
        'Notion-Version': Env.notionVersion,
      };
}
