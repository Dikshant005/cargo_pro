class ApiObject {
  final String id;
  final String name;
  final Map<String, dynamic> data;

  ApiObject({
    required this.id,
    required this.name,
    required this.data,
  });

  factory ApiObject.fromJson(Map<String, dynamic> json) {
    return ApiObject(
      id: json['id'] as String,
      name: json['name'] as String,
      data: Map<String, dynamic>.from(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'data': data,
      };
}
