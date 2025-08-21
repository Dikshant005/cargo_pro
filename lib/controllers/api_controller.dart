import 'package:cargo_pro_assignments/services/api_services.dart';
import 'package:get/get.dart';
import '../models/api_object.dart';

class ApiController extends GetxController {
  late ApiService apiService;

  ApiController({ApiService? service}) {
    apiService = service ?? ApiService();
  }

  var objects = <ApiObject>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var error = ''.obs;
  var selectedObject = Rxn<ApiObject>();

  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMore = true;

  Future<void> fetchObjects({bool loadMore = false}) async {
    if (loadMore) {
      if (!_hasMore || isMoreLoading.value) return;
      isMoreLoading.value = true;
      _currentPage++;
    } else {
      isLoading.value = true;
      _currentPage = 1;
      _hasMore = true;
      objects.clear();
    }
    try {
      error.value = '';
      final fetched = await apiService.getObjects(page: _currentPage, limit: _pageSize);
      if (fetched.length < _pageSize) _hasMore = false;

      if (loadMore) {
        // Avoid duplicates
        final newObjects = fetched.where((newObj) =>
            !objects.any((existingObj) => existingObj.id == newObj.id)
        ).toList();
        objects.addAll(newObjects);
      } else {
        objects.addAll(fetched);
      }
    } catch (e) {
      error.value = e.toString();
      if (loadMore) _currentPage--;
    } finally {
      if (loadMore)
        isMoreLoading.value = false;
      else
        isLoading.value = false;
    }
  }

  Future<void> loadObjectById(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      selectedObject.value = await apiService.getObjectById(id);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createObject(ApiObject obj) async {
    try {
      isLoading.value = true;
      error.value = '';
      final newObject = await apiService.createObject(obj);
      objects.insert(0, newObject);
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateObject(ApiObject obj) async {
    try {
      isLoading.value = true;
      error.value = '';
      final updated = await apiService.updateObject(obj);
      final index = objects.indexWhere((element) => element.id == updated.id);
      if (index != -1) {
        objects[index] = updated;
      }
      if (selectedObject.value?.id == updated.id) {
        selectedObject.value = updated;
      }
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteObject(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      await apiService.deleteObject(id);
      objects.removeWhere((element) => element.id == id);
      if (selectedObject.value?.id == id) {
        selectedObject.value = null;
      }
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
