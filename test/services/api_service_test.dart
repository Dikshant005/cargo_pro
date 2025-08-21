// test/services/api_service_test.dart
import 'dart:convert';
import 'package:cargo_pro_assignments/services/api_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:cargo_pro_assignments/models/api_object.dart';

void main() {
  group('ApiService', () {
    test('returns list of ApiObjects if the http call completes successfully', () async {
      final mockClient = MockClient((request) async {
        final response = jsonEncode([
          {'id': '123', 'name': 'Test', 'data': {'foo': 'bar'}}
        ]);
        return http.Response(response, 200);
      });

      final apiService = ApiService(client: mockClient);

      final result = await apiService.getObjects();

      expect(result, isA<List<ApiObject>>());
      expect(result.length, 1);
      expect(result[0].name, 'Test');
    });

    test('throws exception if http call fails', () {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final apiService = ApiService(client: mockClient);

      expect(apiService.getObjects(), throwsException);
    });
  });
}
