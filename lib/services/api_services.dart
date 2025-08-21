import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/api_object.dart';

class ApiService {
  final http.Client client;
  final String baseUrl = 'https://api.restful-api.dev/objects';

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<ApiObject>> getObjects({int page = 1, int limit = 10}) async {
    try {
      final res = await client.get(Uri.parse('$baseUrl?page=$page&limit=$limit'));
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        return data.map((item) => ApiObject.fromJson(item)).toList();
      } else {
        throw ApiException(res.statusCode, res.reasonPhrase ?? 'Error fetching objects');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiObject> getObjectById(String id) async {
    try {
      final res = await client.get(Uri.parse('$baseUrl/$id'));
      if (res.statusCode == 200) {
        return ApiObject.fromJson(json.decode(res.body));
      } else {
        throw ApiException(res.statusCode, res.reasonPhrase ?? 'Error fetching object');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiObject> createObject(ApiObject obj) async {
    try {
      final res = await client.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(obj.toJson()),
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        return ApiObject.fromJson(json.decode(res.body));
      } else {
        throw ApiException(res.statusCode, res.reasonPhrase ?? 'Error creating object');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiObject> updateObject(ApiObject obj) async {
    try {
      final res = await client.put(
        Uri.parse('$baseUrl/${obj.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(obj.toJson()),
      );
      if (res.statusCode == 200) {
        return ApiObject.fromJson(json.decode(res.body));
      } else {
        throw ApiException(res.statusCode, res.reasonPhrase ?? 'Error updating object');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteObject(String id) async {
    try {
      final res = await client.delete(Uri.parse('$baseUrl/$id'));
      if (res.statusCode != 200) {
        throw ApiException(res.statusCode, res.reasonPhrase ?? 'Error deleting object');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      rethrow;
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'API Error $statusCode: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'Network Error: $message';
}
