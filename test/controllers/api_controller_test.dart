// test/controllers/api_controller_test.dart
import 'package:cargo_pro_assignments/services/api_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cargo_pro_assignments/controllers/api_controller.dart';
import 'package:cargo_pro_assignments/models/api_object.dart';
class MockApiService extends ApiService {
  @override
  Future<List<ApiObject>> getObjects({int page = 1, int limit = 10}) async {
    return [
      ApiObject(id: '1', name: 'Mocked Object', data: {'key': 'value'}),
    ];
  }
}

void main() {
  late ApiController controller;

  setUp(() {
    controller = ApiController(service: MockApiService());
  });

  test('fetchObjects updates objects list', () async {
    await controller.fetchObjects();
    expect(controller.objects.length, 1);
    expect(controller.objects[0].name, 'Mocked Object');
    expect(controller.error.value, '');
  });
}
