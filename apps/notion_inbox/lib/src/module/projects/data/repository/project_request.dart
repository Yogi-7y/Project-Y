import 'package:network/network.dart';

class ProjectRequest extends GetRequest {
  const ProjectRequest({
    super.host = 'api.notion.com',
    super.endpoint = '/v1/databases/12345678-1234-1234-1234-1234567890ab/query',
  });
}
