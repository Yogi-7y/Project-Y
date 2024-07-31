import 'package:core_y/core_y.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_y/network_y.dart';
import 'package:network_y/src/client/executors/api_executor.dart';
import 'package:network_y/src/exceptions/api_exception.dart';
import 'package:network_y/src/request/request.dart';
import 'package:test/test.dart';

class MockApiExecutor extends Mock implements ApiExecutor {}

class MockGetRequest extends Mock implements GetRequest {}

class MockPostRequest extends Mock implements PostRequest {}

class MockUnsupportedRequest extends Mock implements Request {}

void main() {
  late ApiClient apiClient;
  late MockApiExecutor mockApiExecutor;

  setUp(() {
    mockApiExecutor = MockApiExecutor();
    apiClient = ApiClient(apiExecutor: mockApiExecutor);
  });

  group(
    'ApiClient',
    () {
      test('setup should call apiExecutor.setUp', () async {
        when(() => mockApiExecutor.setUp()).thenAnswer((_) async => const Success(null));

        await apiClient.setup();

        verify(() => mockApiExecutor.setUp()).called(1);
      });

      test('call with GetRequest should use apiExecutor.get', () async {
        final request = MockGetRequest();
        const expectedResult = Success<String, ApiException>('Success');

        when(() => mockApiExecutor.get<String>(request)).thenAnswer((_) async => expectedResult);

        final result = await apiClient.call<String>(request);

        expect(result, expectedResult);
        verify(() => mockApiExecutor.get<String>(request)).called(1);
      });

      test('call with PostRequest should use apiExecutor.post', () async {
        final request = MockPostRequest();
        const expectedResult = Success<String, ApiException>('Success');

        when(() => mockApiExecutor.post<String>(request)).thenAnswer((_) async => expectedResult);

        final result = await apiClient.call<String>(request);

        expect(result, expectedResult);
        verify(() => mockApiExecutor.post<String>(request)).called(1);
      });

      test('call with unsupported request type should return Failure', () async {
        final request = MockUnsupportedRequest();

        final result = await apiClient.call<String>(request);

        expect(result, isA<Failure<String, ApiException>>());
        expect((result as Failure<String, ApiException>).error.exception.toString(),
            contains('Unsupported request type'));
      });
    },
  );
}
